Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058653;
	b=Q5W3AIsDndl3fvhI3I48cRJUHlfi6DEhrhbz+8AWEmfc+4N1sCeLN17/ZOGbhmLVXCAq
	 OqQIB2vk/syS1+twXggg1ftJZInvU+0R5/HU5Z0iWn10UtjJXpAKtwYlyDONT1soNrE5c
	 Gdi5t+romZMCJW2fda7p6r/klDmdoakPQMLr8rIlxBc1HTS2SJom9ikR61nSp/Q4dk9dH
	 tO62Y64I0kBG54FhzTGMezhjF84FlKLro/ouw+ZX3SDi+DvsC/NB18d6+GMO7IMGqzotj
	 2eXAu0faOf5jkmkZWUAE1y8C6SGpU4EZeUROl9jc6b/TnGoCbzy6HnfoLHoktXGrmPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EwOigKc3DaVPoRRv8Tdu+bhphor3Im8bBhrho1Y0GpY=;
	b=UE2LRahLY7ED3AHa/7n7Hpr12KZEDSDRO/3oaN1lDgernE2sXYk4fe5AgOSjzeDRXpPZ
	 jS8Pkw15mzoEUmg+R0NybQmEqBgF7CVGH23S1aJRZDl0+uYxJ07ORvKxL2Tmro4GuykpQ
	 8iAodUc6lZaiZ0T+CHh3NPsiXmkNC/bCdQ0dSKSJt8zCA3oMHYv5xVyONfVn7ZWhU4EEL
	 Un6OZGTFQBS38O+tJzbUw7+Z1zzDrl8kATHZcHCFSw9aY4wv4ek88RDGREHhnPp51OONW
	 eMLbKYWJtV235akmED8v2dLcHbNDTRABFp/MNFbTjJ8/riZNcqwwuiPqwWTjFQTDmuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkpAk5lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085F606A31C;
	Thu, 19 Nov 2026 03:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkpAk5lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E61F000C5;
	Thu, 19 Nov 2026 03:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058652;
	bh=EwOigKc3DaVPoRRv8Tdu+bhphor3Im8bBhrho1Y0GpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkpAk5lmithQfbUthn2nBj/VXHpVBQxZg10tM/SAgOBc2H3YrwL7vvfCi052aq6yW
	 EhTKy7uM3qzr4WNxz3D/uxRAlADYJ0pJUIyJ4iYcSys8hM1+onzyN24eANLjCI8mfr
	 0B30gDfgO473j5cQbT7nbnIeC4r3//ZkAufZMH+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0561/1848] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118145938.353218361@linuxfoundation.org>
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



