Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052800;
	b=jUMKe93nhKjjgurhikxEx73inXYDig+3On/Al29xnPjNWagJyKQBwrjXUFryKeEaE5AF
	 3hBGPuQdvrr6YxHa+Zcolfa2xkuvDhfrHC3aCV1BpFR8stMDsLQsnFBgUSvACwJKgtkIH
	 IJFvhMGcrS5z5vjx2G8tICKpP3SD1RwX85MhTdEDwIxxvBVUha0n9/Q5vMeKzIqPpNsPQ
	 e8wqV+ZLQ5SKh/Oe8WkKK4JcW0YqWYUzPeXUSIfaPeHZf7xMJhl371Dl4HpYBq8pMUPPk
	 nlb5fSfLq136WUCAAPRD+LsqIZbFPv6uzJQ6iKBibfuAF+CRGcgEZrnaMY+BjXN60RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ya9pU7si3apvEpSaPh9DdOLz2mKWGxgICR8Rgb9773E=;
	b=u1OZgCJQBr2Ad/TlkXOkbYUXDKAJhbJ3ho7v1YXDjFbAIPe4gCQoxeWpYgkFE5wy1IRb
	 v1+OOlixW0wZc3uZGuKxmxPt9b09l6+KhnRzi5j4mjyiFXROxmU1aFXtlf375C6wzLLpa
	 FHr7C1uIp4cnwxsxDmwsce0cEoTP77d1KrsftaLZxUvnOshbE6Q9wzdDZCLEvo//pd1NM
	 T6mk0Ae115V45cD7iIZOSyq/chePsPjrRq7wQwuRoz3rt1nmw+5D4rEoOQ0kRkDRiGEhg
	 aTRPK7z+lkLaCU5uaRtkdY21whzBVM1JqprVUiGzJwUoOhRusZAokj0KHXZhktKKaxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cimn0CNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A83606A32A;
	Thu, 19 Nov 2026 01:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cimn0CNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABCD1F000C4;
	Thu, 19 Nov 2026 01:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052800;
	bh=Ya9pU7si3apvEpSaPh9DdOLz2mKWGxgICR8Rgb9773E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cimn0CNJmfpgQ2i+OPtW03KoHfV4H3di2cz7ofkgl0MGskECAEJZ4PnPHug6Spplk
	 YkylfUP8pCZtjEe1ULK8Z+XSYPg4bv0ctH9O/3wonzZaJCpt+eTeJjeiesOGgSpLHj
	 BH2gcoXXza0/nEd+EIvKorm+hUIUb6G5xo4+phfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0694/2214] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Wed, 18 Nov 2026 15:39:30 +0100
Message-ID: <20261118150039.546958641@linuxfoundation.org>
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
index 038701d483513..bec0b1fcad27a 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -258,7 +258,12 @@ static struct platform_device *pdev = NULL;
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



