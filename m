Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051648;
	b=BeBtx8nEJKv0OgHEu938FncMKDUQU71bpupO0UwqG4kSnuwKjqzLSAfrKN0pFw3Rsn9j
	 86zZXYEb4U1QkTpq6ntwrkQ5Oex64U68li58rSK+ABLtMt6U3fgBD49sMjoYqZHstRvJk
	 8raHThlSbfCCjirRPq2EhX347AUSXGREZM1jM94gbKkRkO1ebdTIEebLvgSXMuD62A3R5
	 NhFzgCewvGzydThTS4rRwYG6Imbg7saAWigtAgFWD24oHiHVowsv3h/ec1Fn0MzWxrzD7
	 bhQ1s4SurcDB/hIWFT4KL8khK4TQsu4Fa3Od+bL3eqx88jPH9WjG0fFkY477UgYeWVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kNcKSMseq1oSBSi0ZSS/4Y3NIJ7bPrTikWD54Pghi1U=;
	b=okTC92nWqSgL/Q+idVn0uCIg96PAt0xiJ70SRaFOBHySlvpT7m4ZIExMZ7Y/eGFMxwe7
	 t1HyZGL/CKMNwMtIpSbjdYDtadfoHmiYaXBUGNaY/qFQUgJWcRBqdrNwzBYaQDX8yZnvG
	 MAskDpOfrF/s9vlQBFYi0dEYykeF2ksXTVeDt3ixHvBQcHUp0L+Dk2V0+ZHazN9MRguSZ
	 Aubxcdxh7nkM9zjkSwieTkXeQA0Y+UDd1qjWEBuqXvsS9k6Py7jE6W+Q7Od0Tss38Vkw6
	 hr5wFUxGG2kilg73l0lSGGZfNTZDJFtEwgyhVsfNgVpp6m1vdW5RcAvuAKwg8mH31oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r/H1xiZT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE936606A320;
	Thu, 19 Nov 2026 01:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r/H1xiZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAF91F000C4;
	Thu, 19 Nov 2026 01:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051648;
	bh=kNcKSMseq1oSBSi0ZSS/4Y3NIJ7bPrTikWD54Pghi1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/H1xiZTOFQjLJ2wkqpld1Q1aho1N6NrgASKwBWz7xASu1rHbwhZTDNkH4QoJY+lY
	 dZbAZVApg2fn928VJ4mq91J2U5/iCa+f3+8BpumgfpoM+kDNXiJ+5HkdLcsF880bBX
	 qRIXgmnQNF+DhSCo/JpJcCcksT+86Rzayk/Hyoec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 0283/2214] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed, 18 Nov 2026 15:32:39 +0100
Message-ID: <20261118150021.374812633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

commit 1dbd46d4b2fb416a8202b1a8e4ef9d0cadbe075f upstream.

wled_probe() doesn't set the driver data for the platform device.
As a result, platform_get_drvdata() in wled_remove() will return NULL,
and the first dereference of it crashes on unbind.

Set the platform device driver data in wled_probe().

Cc: stable@vger.kernel.org
Fixes: feeab87b3072 ("backlight: qcom-wled: Add support for short circuit handling")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-1-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1679,6 +1679,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


