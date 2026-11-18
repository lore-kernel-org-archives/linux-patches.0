Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023462;
	b=3QU9Dzxs1CENzI3TsDlmi/eZt0AESdg94GnTKQrMD22nIOXOjZt/2AuyltvriC9FDLv9
	 ea10DIE/EUBwhG4y4noRMfeS/Bj+UtE8ZPide7EllVHUwQK1sbHPmT/aXP6xi8YP6+WWR
	 zdyxfaV9c1WWnsTIKjMx6+wRuhxeALxLIp7dn6WYID4vKkI7Fu+ttirPlIaN5DpKrI1FL
	 UoLrL8Be+FuraBGKdraxCTsC2gTv3j8GgLHnsj7uHBEtQF9i2igsYZmpbdHVEnjPOyNod
	 YTglRmT8OB0bvOGUjbYP+fuJK3Nvs+na7Aa1DglkkfVIDjv2Q08w+BwzVf8yHYSFH9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sMj8C9II4qIqfteMXuOAuvhh1EinkU4tmGYtJ6W5gNA=;
	b=R2dMrF+nWvzdVHnf5B5qnnS+j5wz++KHtVXUuBbKMEUtjiE9j9tQiFTmMMUW4r4duIpp
	 XErj8wSP7U0pg5lRnDXeUT3Jj6t4yo7WOadBOwI4/fXqM5BMI61O09KoIuyTc+S3dBS2P
	 8HrNkrGUUZ11jAW6SBqPUKvaQDrcGSHY+jM19u33HH0ZWQw/4BuKI2ENgjkKWKBe5D8dG
	 +v3mXwH84R58uIv7vRvGu6+GiubfC3yakpJpyFnsOzFFAxPvgFwcrRf6XtlswhglIHRdy
	 cF6a2n6IG5EBLRWPEQvnplztaktjV5KuOqwdlyunHVQT2ZOwmPuXYQo0ZS2ureXk3ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7vwCma3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B092A606A336;
	Wed, 18 Nov 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7vwCma3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6F41F000C9;
	Wed, 18 Nov 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023462;
	bh=sMj8C9II4qIqfteMXuOAuvhh1EinkU4tmGYtJ6W5gNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7vwCma3XX2xTtrR1PxH+tNuL7anIAj+LuB0l5r1kIvv6EE4pRQ6xtFHsPVmMhmq1
	 V79Y3lrhVGhYxRas6GrxePm5VdY9Vl1y1lZTpJiUo2vuvr1riuVlZLhSShg6yzBA2N
	 8r5qcURnh6FtpBrW4KlubXF7pXEz2B+fhWJwovZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0377/2151] regulator: ab8500: Propagate mode enable read errors
Date: Wed, 18 Nov 2026 15:35:12 +0100
Message-ID: <20261118150135.822262821@linuxfoundation.org>
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



