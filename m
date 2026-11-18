Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057721;
	b=0DB5BpAEsCBW3L3sworECE7ghL5b7gG5siKxj2IV4Is9x2hHMxqNTw5OhNcryu9KFp3G
	 rkuy/gPPfHddrA2jhR8by6G6QByfOsBFY5mFvvKwnoc5ItUp/w5yOvNlmxskfO2x3pyfA
	 G1q661NPZlOIuFVQCl2uvCMLxoJ3v/lhJNMNsvu/NU2gVq3nOcIVuAah0vz32+I0dri4Z
	 xgxP84YYdZR37dWp0KWGObQmE427fZyjcUynGAR35/yjii3gXjKEilf7kUNoUYkrYLjcu
	 DgQvPGCH49DCvxnsLW58xI2dr5JFpCKJtfnlWBx4bogwnZBiIqFw0Hf+Tgv66ueGCPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfdGH2c6OQu/ig9eDY2yME9r4x14Rq5+N+mx35jt+BA=;
	b=Tr/DVFEsRSmLTGplLV1uGkQeYjj4PWFmwYBOadwJ0ArJR+Yj+9ZyIK+GknBZStOvRYzE
	 qSE+l1ywLWhdkXtAG08nFwM+N43jw5GPpYbKrH5vBBA+1k86HWG7hlYO8s8jtQYP9QJ+c
	 zPHU2gVQVEdhdX5BPgIliLSBXXjFnuYdGwpJgm2n5hi6+rUrIYEtkazVIthXSN9BrUoPM
	 hKj8HK33C3Q6INsth43QYxVF4Ud3yvIJpxRmBtk+dd28m4EBm7n8qMoZO5Iz/hvQcmz6n
	 z0nTDC0oj6hjyqp9pCyQ0hCiJ3j6Mh62P9hY6BCYLGGf4CzrPKf4V8fuZLaVNzrcDVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3fa6sfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32AB606A325;
	Thu, 19 Nov 2026 03:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3fa6sfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9211F000C4;
	Thu, 19 Nov 2026 03:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057721;
	bh=sfdGH2c6OQu/ig9eDY2yME9r4x14Rq5+N+mx35jt+BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3fa6sfOYioL/4Brd80XUj0MFRG/f1TuV1mlbjCAD/7UVElDzWWo3gn/XhLSYX7Ha
	 dS+XyMK4RF55VWJTiBsTttOBZaqPjDm/+3tjhluGigVxPolPFxxj3Mx5ktIlndmIvP
	 VwmWfI+7R4S225Z6HFOsFnTI4uzCHzZfo7GIBwrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 0232/1848] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed, 18 Nov 2026 15:37:50 +0100
Message-ID: <20261118145921.674958739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1642,6 +1642,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


