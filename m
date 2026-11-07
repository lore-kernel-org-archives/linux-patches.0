Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063591;
	b=SZ7I2gQTQ6T2qEx1nzTURm9ivbx9sAMZ/Lv0OfXi9pjfzZtIQNCxZQV2rZcp4dQseU31
	 AnIwH/9CMK4jxgPYC+raT4nYnll30g3AxZsKJYJ8C3m88S3nQRLhubjZXPVfCNaPdsd/G
	 sMDz4bho6V23ly2T3NxXsHAvfnvLHjKdhtj2bMaJcc8l7dPFjQR0zGURCivw8bhw8T2h7
	 BAhnSVm2W+CB3S9I9SXhD1LI+VbUF3iujURg7XQ8sWXXdpcSKZDapoN2a302iY9Qdhu9z
	 R4YAK+XIMEQeNP6TnZlzoPaEj1O+dK2x4Otot++I6P46gPG37LLgRD+GeLHqwzJFcjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ElSXzu8aFvKmNWEdkJoxD/KbQt7B7ij8qBTAml9ZuY=;
	b=d585jB20ZLK5Y0u5DaFygk6dDlrV7dLSzYtdjODR0bvq2NceCglVl3Si8CQXB7JtoBtZ
	 w8UUHO5nJ3Y015X/vvfox3AoY1AlBOxzahCIybOJQKXFPFTCcSsxExtz4dq/W4UP1oxsE
	 CUtbYNa629nyhYD0Kg7oXLrLRKFcMrGxDlbdNm9ezbdC4IBCmGOiDTBubLksgR4qUWThw
	 YZDZcW72SGxUu2gg+KmWYpzQMMnJtszv1hpy5vyuvp1kjKHAaTN9pZaTwK+IA23vYGgTj
	 1hxwIcDkSyshZ1FrCVEZG0elM0Mq+Glw1XTjeBKKNjGFnb3sWqPElOqcyQUc1DH/EZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCq8alA+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFD606D826;
	Sat,  7 Nov 2026 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCq8alA+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388FD1F008A1;
	Sat,  7 Nov 2026 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063591;
	bh=0ElSXzu8aFvKmNWEdkJoxD/KbQt7B7ij8qBTAml9ZuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCq8alA+s1mzFfgYfvTP8gmw2joUbCO+Uzr5hGqVPOTSBX385z3kOVvcnu686psR8
	 RRlsgjtLKNA8fA4yJab8xNVFxUJ/KfFEf7w0gdNH64vypaG5Dn1Gu2wUZgkaAp4g7s
	 Y9qoNz/Dbg83YlIK7NOWEIMPzNtoripLEjmofXIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 717/869] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Sat,  7 Nov 2026 08:56:39 -0500
Message-ID: <20261107134917.160213220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 1900449684cf71427a51e0bb1d7914c0c8b39152 ]

tpm_nsc_remove() is used as the release callback of the hand-created
platform device and dereferences the chip drvdata unconditionally.
If init fails before tpmm_chip_alloc() (e.g. request_region() cannot
claim the ports), the error path drops the last device reference and
the release callback runs with chip == NULL, crashing module init.

Return early when the chip has not been created yet.

Cc: stable@vger.kernel.org
Fixes: afb5abc262e9 ("tpm: two-phase chip management functions")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/d5f0b38d6d6c17c01519c879d26448dbae388b0e.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_nsc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 879ac88f5783c..46a52dc99b148 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -259,7 +259,12 @@ static struct platform_device *pdev = NULL;
 static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_nsc_priv *priv;
+
+	if (!chip)
+		return;
+
+	priv = dev_get_drvdata(&chip->dev);
 
 	tpm_chip_unregister(chip);
 	release_region(priv->base, 2);
-- 
2.53.0



