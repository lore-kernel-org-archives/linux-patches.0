Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061490;
	b=iaep7MyXqG3CWLZ19064E+q+3DCroDGie9cBX5vk7N5mWpCoPjZKKho4RHqVc7kbrvd+
	 0k+y7h2kbwyM+ViDw1Uup+TI9pqB9Eevhv0TD7nSPAC6DN7TPa3NoOJIIUs8qNl4HA1Xg
	 ZjYdVIXgAuJJwOUllra+lDFn3lhnNEewJD7Y2R4fx7Okt1OtRs+9Enb1jtiqQ92xbWD0Y
	 ahrXh17nAfBnt7uGCrxfvdEE3J8Gw9Eo88OK5eHIoS6amgrSZBk3gOrN8g/q7OWy5RvxW
	 huiWykgxZE8yIvelgzAT8/nJnT8OH8AAn4pDttEcVaQLWLqWi9jby7r4cLr3iCGK73w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UO3KrmNKDGrb4sZJW52LhnERidYiaVV2TjTpq32N9Wo=;
	b=agUk9vlUybtwW4HVF8QiDhCDaI2f45iz0FDRjexK6JmU7QfrsejPLwkKQWfzSymX1bMN
	 sid/6v1oF0dc4vAekM94E6BaqSIvP2YqUAhBIdJOuGQiZAG4nJN3XYaPVDIVbnqwt9dhN
	 VrqTY2oyh5zndgYjsJZ+eHQ4mDERpJQi6c0BZnQ5WvQ9JOJOwrJ6psJWbdx0QYhZTQZ4x
	 sRJU9zYihNM2/7flsE1/Gag/qkLhumf/IedktWB/gxYG6vs6+b07eH+OMwW2auSnVbUhl
	 oIdCOiI9w8dEkUNiPaiuj5gxyxolaeZqrYvqURj6lD373DVnCaxdLM1BAf6Xmm5nq1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPccEm+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178B8606A326;
	Sat,  7 Nov 2026 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPccEm+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B71F0089F;
	Sat,  7 Nov 2026 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061489;
	bh=UO3KrmNKDGrb4sZJW52LhnERidYiaVV2TjTpq32N9Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPccEm+jVLs5D5DR1G0kBqPMj39JccjOAeUwfhqT1a6X/qNGTD0IKcDYMJqKgYpnw
	 hCGKxCi6f6pl3uXUDld2ZOCNXhfQuUlbmpgKU/uB/CnhGMVEq1qryjXfxwruP2DHt7
	 YraqzEsATt1uWsTSgcZZTSpBfgKTfx24cDmDvYFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 0579/1536] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Sat,  7 Nov 2026 08:43:15 -0500
Message-ID: <20261107135013.817399799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


