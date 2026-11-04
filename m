Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831388;
	b=q2E73584ZAyOYyYV3KBHTJZGcnw1debV9KM9WgB6kr0l058fUxgW7/IgD34pC4SDMq1Q
	 lbuLR0ywx/nt1Mq5Ig37zjt0X4ANiXY5TViqeWw3fx8olsIhjWyNaXREzQJpmHkJ5Y9Pr
	 c3Z8MxS3M9E5but2YjEAigm+2XVzPjTA/oMDznT/KXMpOSGxDd3W2X8cboDC4J33w++6k
	 g/VX3ojhpxyQFikM39rGA3CMmW8SYT1DA4kuOQq2IUc+hcX66yt/4S2LEvlMbpshInYgh
	 /ITJIBRc2q/ttZ6NgBmvqgPfrm+WdNkjy4yHQkXQ/EPcX9qtFa21tyxoc3Rno/kRvXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mr2yJHb/kudPLp8t0b6nJ9GhDBYUtcNhuA9VXzZexlE=;
	b=vhOF7E/c4N11+iD47zCZOAMCgJG+8qPDNJNrr/2p9ibj5IQUmP80pafXneDAj3RBkuAY
	 xNBE62a67yw5goi3uVeD4BJu/aZhJ5scp+XkEOvT9kt8VHlrbe5o5iTC0vvJrmdkphWCn
	 VFqD6eptojuw0kNSLf0YyASS/zLYABv6uisrd9oZySkglvT421oluA7jVlvcCA7cPs1Yq
	 jjRitTZljLwlz7xDp/iOcPYLAU6WcFlIkA1s1b6dl92oSunr2ZldMV6+t+uPfjAXGqqW5
	 M+Jv6BTVTAfsj6d8XTDDFlUYs/pNiO3nuGK+zAvI502n3mCTtNAq1zZ/u3yPbfpxJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxY3Xfnc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D732A606A87A;
	Wed,  4 Nov 2026 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxY3Xfnc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7268C1F000C1;
	Wed,  4 Nov 2026 22:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831387;
	bh=Mr2yJHb/kudPLp8t0b6nJ9GhDBYUtcNhuA9VXzZexlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxY3XfnchzvxZfSUcnbFkHk3jgmaEPcdju5MDjjoXRrI3/weOCBAbUd+TnZR+O1LC
	 //wY/ldxmcgMb+EcSJAJ1XT6pvnG5m+Pt9xilisdtVV/8NHtl7ERxJBAseoiegMu+K
	 fweVn2Bo5w7BO0ocZeBDtBOfRG+Wo8M1qYUubz5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 0637/1005] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed,  4 Nov 2026 16:06:10 -0500
Message-ID: <20261104211101.611055498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1682,6 +1682,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


