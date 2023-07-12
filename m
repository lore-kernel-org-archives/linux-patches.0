Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764111C39
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C295EC433C7
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689421729;
	bh=acAKSUZaLKtpc9FocLuUTUcFuwY4CaEPgdn/dCfp924=;
	h=Resent-From:Resent-Date:Resent-To:From:Date:References:
	 In-Reply-To:To:Cc:Subject:From;
	b=Yt+cWobWpOEevmXZ05qeiWVyaSy1Zqc0TSRm41CiUsZ35UgflP/o2piX2ssiL10r8
	 tyTuKhB0yWNZff/Y+l32R/iHGH8M7lM0w6oMANScdOyQ+2phRY/bsxGpqK6iKW6A2o
	 1H/zonuuBb00T71kFVwYUU9dC0mkBz6ituhNsSOaJRw0suqcnhWuV4sLIgBnyKeqwu
	 NtqsJhxbGl4cMDApw+I/lp8U3k8CrpuXDO/zCpCiFC3KDb+pevoTMYl8tO3z6GMFdI
	 rfbXs7zF8MiJE+y5t7P0WL3zFzy2uGzhiM92VckXIBZjLFX94/K1Rl1FEXexaXa17q
	 57XzKyuXauGYA==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Sat, 15 Jul 2023 12:48:45 +0100
Resent-Message-ID: <ZLKHnU/NCiLYD1Fn@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 12 Jul 2023 12:16:55 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <broonie@kernel.org>)
	id 1qJXq1-004s0U-0y
	for broonie@sirena.co.uk; Wed, 12 Jul 2023 12:16:55 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 5158461757
	for <broonie@sirena.co.uk>; Wed, 12 Jul 2023 11:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D13FDC433C8; Wed, 12 Jul 2023 11:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410F3C433C7;
	Wed, 12 Jul 2023 11:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689160611;
	bh=acAKSUZaLKtpc9FocLuUTUcFuwY4CaEPgdn/dCfp924=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aGKoVx7CGyY3UUmoimB0gRnVMkPeCgqiXOAYl3bsvDQHvREy8TahCUqE358Cjn/c+
	 ITMRfNVCrg4+ZhQOScp48NYWkSzkTcAWlJ48Sp2DcvU9WM273J7Ugqb0aIgRfpqYNv
	 8Msposspm2mR6LcJr311bXPQ/b6FVvjHlH4CkmCCeYAjttI70ji/fux1udjBIZlH4e
	 OkbLZ1cKuwJtAGchvN93ttE5pJThvPi1gDLcSakcxjq80+8REGZo2PpsTkOS0X+Jst
	 XCHpvWha2SR8HXeS+/a4BEjm7/HitiugMZ3siTCGFB/S0LuZHv7/Ap3fwO+rfcDJ3n
	 DbOacTqREmYzg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Jul 2023 12:16:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230712-regmap-max-transfer-v1-2-80e2aed22e83@kernel.org>
References: <20230712-regmap-max-transfer-v1-0-80e2aed22e83@kernel.org>
In-Reply-To: <20230712-regmap-max-transfer-v1-0-80e2aed22e83@kernel.org>
To: Ansuel Smith <ansuelsmth@gmail.com>, Jim Wylder <jwylder@google.com>, 
 Xu Yilun <yilun.xu@intel.com>, matthew.gerlach@linux.intel.com, 
 Mark Brown <broonie@kernel.org>
Cc: stable@kernel.org
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1961; i=broonie@kernel.org;
 h=from:subject:message-id; bh=acAKSUZaLKtpc9FocLuUTUcFuwY4CaEPgdn/dCfp924=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkroucm3pJUFWFPJe35G9zGr28uvkHP7LrIaU7y
 BmULAuSAAOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6LnAAKCRAk1otyXVSH
 0NlPB/9qJouWrFFllsw9QOQaN9ryF5xdunm5Skx9sw4usSvbHLSz0wnidutZa94W8XNUsBjbgep
 ZM+9EfExKJu/Mj5qD30OM6Jpyo8CwZZ2eakVpNaeGomk4ridUDNoF/MTB5AbjP9oOYUO2EdhTeT
 jZQmmL0QuW6cYYe5ks7R5CxE/h4Jhc+YonOBOctG05ipKmy5JTxZBTuUPGvYUTi6oa3LpzURv/Q
 /joeCbDvykr9+hp8Q6Sr8tHH4iXsI+buxWOWATM79jHUu+AWy+JsjlegS+bO+uJjEBSHPmWSZFu
 UPASNhzIDBhtghtI8MstdNIxP4mUNukI+JzTkRye42fIfdeo
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: [PATCH 2/2] regmap: Account for register length in SMBus I/O
 limits
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: rwt4SRW+XVFq

The SMBus I2C buses have limits on the size of transfers they can do but
do not factor in the register length meaning we may try to do a transfer
longer than our length limit, the core will not take care of this.
Future changes will factor this out into the core but there are a number
of users that assume current behaviour so let's just do something
conservative here.

This does not take account padding bits but practically speaking these
are very rarely if ever used on I2C buses given that they generally run
slowly enough to mean there's no issue.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@kernel.org
---
 drivers/base/regmap/regmap-i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 980e5ce6a3a3..3ec611dc0c09 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -242,8 +242,8 @@ static int regmap_i2c_smbus_i2c_read(void *context, const void *reg,
 static const struct regmap_bus regmap_i2c_smbus_i2c_block = {
 	.write = regmap_i2c_smbus_i2c_write,
 	.read = regmap_i2c_smbus_i2c_read,
-	.max_raw_read = I2C_SMBUS_BLOCK_MAX,
-	.max_raw_write = I2C_SMBUS_BLOCK_MAX,
+	.max_raw_read = I2C_SMBUS_BLOCK_MAX - 1,
+	.max_raw_write = I2C_SMBUS_BLOCK_MAX - 1,
 };
 
 static int regmap_i2c_smbus_i2c_write_reg16(void *context, const void *data,
@@ -299,8 +299,8 @@ static int regmap_i2c_smbus_i2c_read_reg16(void *context, const void *reg,
 static const struct regmap_bus regmap_i2c_smbus_i2c_block_reg16 = {
 	.write = regmap_i2c_smbus_i2c_write_reg16,
 	.read = regmap_i2c_smbus_i2c_read_reg16,
-	.max_raw_read = I2C_SMBUS_BLOCK_MAX,
-	.max_raw_write = I2C_SMBUS_BLOCK_MAX,
+	.max_raw_read = I2C_SMBUS_BLOCK_MAX - 2,
+	.max_raw_write = I2C_SMBUS_BLOCK_MAX - 2,
 };
 
 static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,

-- 
2.39.2

