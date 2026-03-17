Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4CE3ED5A8;
	Tue, 17 Mar 2026 16:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765737; cv=none; b=fLCZUoee/jqdD1TsHhzkNHJMSbZyApTv0bS8LOtgdWmCv13+gMgKBsCrdyRsqQZUtDSADTY5i9t2aghzjkCyvZKZbt/H2tE7iXwD4YkQ3qtw/mfYk/YCmi/kHVCwKWt1jDHBheLs/SEkYng3sGCt7s0EU8EZlf/tA/yWAqBaGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765737; c=relaxed/simple;
	bh=SZmJTsrKHjIKR8zBgGNsOAf8m52DS8yHT4kjqSq+3h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l03ghrKoBOuj79EBtx9jH5LoPPim3pH75ip51+hCX5RNR8ajhZ+59PDfcXhlqOtKyCqGhHS7dbs5nmy6RVycS8YiiVxM5lSRIf16W4l59Vlv6SoMMyHTz2iS7KAjUEXtyBy+lsaHFPJ6PS3Lzsoc/fd4LPdmjR9+wG1FrIRKcu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6CcekUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6CcekUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F02C4CEF7;
	Tue, 17 Mar 2026 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765736;
	bh=SZmJTsrKHjIKR8zBgGNsOAf8m52DS8yHT4kjqSq+3h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6CcekUY/6h7/7m30ALCiJR09F96d4NN+cW9KsqS0ReVvn+nQ/BWsEg+o/xqlXjbH
	 Bhu8wR/9T0gn9QTwEzMj2b8K/N5aP4lmE28TZQlxt3301RyuTEid/51YvbAz2w7qae
	 F9B1zbV2I9nRViHMjxeoYGLgpUcEotatjWKOurNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 083/378] regulator: pca9450: Correct probed name for PCA9452
Date: Tue, 17 Mar 2026 17:30:40 +0100
Message-ID: <20260317163010.069229423@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 21b3fb7dc19caa488d285e3c47999f7f1a179334 ]

An incorrect device name was logged for PCA9452 because the dev_info()
ternary omitted PCA9452 and fell through to "pca9450bc". Introduce a
type_name and set it per device type so the probed message matches the
actual PMIC. While here, make the PCA9451A case explicit.

No functional changes.

Fixes: 017b76fb8e5b6 ("regulator: pca9450: Add PMIC pca9452 support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260310-pca9450-irq-v1-2-36adf52c2c55@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 2205f6de37e7d..45d7dc44c2cd0 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -1293,6 +1293,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	struct regulator_dev *ldo5;
 	struct pca9450 *pca9450;
 	unsigned int device_id, i;
+	const char *type_name;
 	int ret;
 
 	pca9450 = devm_kzalloc(&i2c->dev, sizeof(struct pca9450), GFP_KERNEL);
@@ -1303,15 +1304,22 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	case PCA9450_TYPE_PCA9450A:
 		regulator_desc = pca9450a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450a_regulators);
+		type_name = "pca9450a";
 		break;
 	case PCA9450_TYPE_PCA9450BC:
 		regulator_desc = pca9450bc_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450bc_regulators);
+		type_name = "pca9450bc";
 		break;
 	case PCA9450_TYPE_PCA9451A:
+		regulator_desc = pca9451a_regulators;
+		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		type_name = "pca9451a";
+		break;
 	case PCA9450_TYPE_PCA9452:
 		regulator_desc = pca9451a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		type_name = "pca9452";
 		break;
 	default:
 		dev_err(&i2c->dev, "Unknown device type");
@@ -1413,9 +1421,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 					  pca9450_i2c_restart_handler, pca9450))
 		dev_warn(&i2c->dev, "Failed to register restart handler\n");
 
-	dev_info(&i2c->dev, "%s probed.\n",
-		type == PCA9450_TYPE_PCA9450A ? "pca9450a" :
-		(type == PCA9450_TYPE_PCA9451A ? "pca9451a" : "pca9450bc"));
+	dev_info(&i2c->dev, "%s probed.\n", type_name);
 
 	return 0;
 }
-- 
2.51.0



