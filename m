Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028204;
	b=Ldgz6IHXH6DCT+8FSdq0rkBGdxXOLXOkrb9XQDVKozMcnfGHl117qyBu1D1q1d8bKsYM
	 s9J4RUajHwEvng+KXBWNA9RIjlANl0DgX3YwLLA0INpo4sewe+WH2xc3PCiAmmXJTzYMV
	 gerHsXz/CTyKb7ddtca7dmwxCnSBr3zLaWydVpdkhTuTkL1YsBvC8NE7/A5rxnTBZit/x
	 BwopR0ipQVzalGG3O3R0Y8AX4JCEpus0oZ4U9+Nwv2I2eqOg3GcqGu+pg1gpOZJFQqV3W
	 3PWOcXVDwIcTj+SPXRmwAhIcRxKUIdfG9qZsuPq7PEMUwAthPO8VTApujENi9HQfC8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FI1trM9ygCGEhrsIvdODjSdIkri0J9HKE/uaXQwJE+w=;
	b=moSLxZIqcEDdzHVZzdaiRcb+8A3NqfOV9SjZPmAnPVCNq/96D/JrmkTkGrWiLVPigjTD
	 KfwfexNRrBwHz9/iSakFZBcz15gyqOKvCw5ARTZWkxzBPQZkJrGDcCme/ZKNgZLznKNIa
	 MZeKI1BAj0OhGBM/5uW76Eqz0VrxhBl/+AGVsu6Y4R5v4npH5F17cIjzY5n1UE3oPcoyT
	 BfvAgGRdSnd5YHuFzTCGedtl8lXqZvm8P8kP+vmxoCe1AOj1WA0/1lfGOxqE7a8iITfSl
	 X9sQczN2FJwhvCWpxM45577lV+s3K3KVL5zJTvES6GmzGxUgCQzxLZUBntU93oEnPHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FPS/Zk0K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93916606A31C;
	Wed, 18 Nov 2026 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPS/Zk0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DB61F000C4;
	Wed, 18 Nov 2026 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028204;
	bh=FI1trM9ygCGEhrsIvdODjSdIkri0J9HKE/uaXQwJE+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPS/Zk0KBEyRloGyUG3JRN8rzPeb2rqb9akXUDZKp6pW2JiAIPWSAeZcxy054y8zO
	 53O9aYZGDMjAT3SiPW1I2dN5ys1eisJhE0SADB4epGMUPxNFa9/yfP05g48Tkz/Qnr
	 U/1ik3nmR4kciIdf4jKBp6KlgeWi+65IZNfvYLss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2062/2151] rtc: s35390a: fix typo in comment
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150236.834879521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 50ccdc31010ed623e68e496aebd4b1d3d8430664 ]

Fix trivial typo

Link: https://patch.msgid.link/20260624204223.1479003-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 6199051016cd ("rtc: s35390a: Read 24-hour mode on access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s35390a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 0713a5afadfa6..94c75cdf0c8a7 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -314,7 +314,7 @@ static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	else
 		sts = S35390A_INT2_MODE_NOINTR;
 
-	/* set interupt mode*/
+	/* set interrupt mode*/
 	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
 	if (err < 0)
 		return err;
-- 
2.53.0



