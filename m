Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039621;
	b=II2CcRMOvcdg/PRqMHDbKF5o/ZCZOSpSbu4rCwHQhgyR5ZP65yAgeDRqKdvqWk6RkiWG
	 Uy97BW/ZOmKt6hiDnGwp0lQbGIbpO/+C4o0rcle7G2w+PsahpOD8EsrwrfF0ByjZlqkVE
	 +HBQOtEs6VA8iwPlqYNRff2C8hiySp/r6lTKEnTZXo3/e1S+69ZV4RJn/eF195G2ld1TN
	 grpKIwSBNoMPrbOL1pKOYvB4vbvjHkcQmw4CWp0m/9MmuEDkgjCQVA8lXWqFuAmfgA8sh
	 8IUJihsYu+mbKSHlSgks6gdLSTxmMFNFu6HnbQiEUqPDvyizX5Y8SQeMqZKmRzm3hSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ySiw4p3NScsXUjYcgKISWQUf308wEtZN8HCfWAjdNfM=;
	b=n8Zsl9Wb3wxu3V3hKRy4HOx+76tFjDfOqKKGY4OTYPXy+RBFnAG8N/b/EMgqgzJnCmc8
	 cdMlVMf3NuFeXXUQG+k+JFw2csNwFaEk0UVlp38QSSq8U1pqidBMhFaJbGjj+pl/w0Hir
	 mtJIymadtobUzAWWI2pCmxGUwiL3foTeMpEQ0AVxnIKxjNBswoR9cFt5aosVQ2Yzuzk11
	 j1PyTXs8WU13iWWiFGfurgNuFB6gSft3fZRY9M2B2/gaLSFj/qrxIohLLMS9Wy3RZECZM
	 gQnzzqjSNPq30V33NTR32CC2GzEWHtbKty+YYoAXCafeda0XVbnnczbJIg+vUIzaz7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKjZPfRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244C3606A31C;
	Wed, 18 Nov 2026 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKjZPfRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F21F000C5;
	Wed, 18 Nov 2026 22:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039621;
	bh=ySiw4p3NScsXUjYcgKISWQUf308wEtZN8HCfWAjdNfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKjZPfRTXEr02NcThDxBqRURUcRae2k7ZcLiIVE0npWVQ+rXIvgF30TJlXOQwD1Ar
	 vNkbB/0R5udpR1K7Y99kkllCaqj8DZJ20F8TRNS3dV5TVFhVehRlne1RS3rVTn+CPb
	 HQ3PyphUe0qq7iwUf7D0aOy6ycIMnNqsz72aEamE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2166/3318] regulator: ab8500: Propagate mode enable read errors
Date: Wed, 18 Nov 2026 15:46:28 +0100
Message-ID: <20261118150426.981093826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 71ac8878573058e2b85210760ccaeaac90796c35 ]

For regulators whose enable and mode share a state field, set_mode()
first reads that field so changing the requested mode does not enable a
disabled rail. A register read error is currently treated as true and
the driver proceeds to write the new mode, potentially enabling a rail
whose state is unknown.

Return the read error without changing the register or cached mode.

References: AB8500 User Manual, UM0836 Rev 3, p. 227;
AB8505 User Manual, DM00046744 Rev 3, p. 237

Fixes: 438e695b87e0 ("regulator: ab8500: Get rid of is_enabled from struct ab8500_regulator_info")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-6-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 05c6b9c7af0c7..e4c3502c8dbcc 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -433,7 +433,7 @@ static unsigned int ab8500_regulator_get_optimum_mode(
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
-	int ret = 0;
+	int enabled, ret = 0;
 	u8 bank, reg, mask, val;
 	bool lp_mode_req = false;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -490,7 +490,17 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		goto out_unlock;
 	}
 
-	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
+	if (info->mode_mask) {
+		enabled = 1;
+	} else {
+		enabled = ab8500_regulator_is_enabled(rdev);
+		if (enabled < 0) {
+			ret = enabled;
+			goto out_unlock;
+		}
+	}
+
+	if (enabled) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0) {
-- 
2.53.0



