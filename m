Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A321A314B;
	Wed, 19 Feb 2025 08:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955567; cv=none; b=aehUwYI64uVrx5ZNIWEyPhZeZu9GG6IxcSwb2YL4moRxHb7oxIWBTUIOC/VRSDjC0nvWPGwN83pFHkH69x9RyZGtCcwhIrhcJ5R/ouV+Ht4RBGxUitYipnweiA92BTXp8nzE8fFZ/qK4M4N+uqUfV4XETPajwdm9qGFM9E0jfl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955567; c=relaxed/simple;
	bh=pTilOpqQoYvzHzQQaHODtaEDh22dDquQ5igl/7wKL2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbkDclDCCPl+bdeKVCGdmKdam2cOPT7INE1oGu5Ra0fnvMaVRrKFYA7CuwBbYXwiq9FQo1vtLRz1h/yli2+eLjhEVdWZWllCsMAPcKo6yZkmElJ7oj6r9nfZLI2j6VSE1kFyyk92h8Di4euaKV+9kj3Mw1ybkabQH/knokLdylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3lHimM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3lHimM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A981BC4CED1;
	Wed, 19 Feb 2025 08:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955567;
	bh=pTilOpqQoYvzHzQQaHODtaEDh22dDquQ5igl/7wKL2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3lHimM89dLt/SmB/TO2hR2V5Rr7EEpG/fjsWec5ClDI0/SpC5oOBLZNGiYQYXmSB
	 LYCrCNBUZu9i+k2oNbRHzLbJGlJL6GNRG11Qw/zWXRcMU6ALVm1RfSIzSAZlFbc6Wj
	 j+4eM4ZdrPyMX5Ju+KbCdQRP7SEvzrxKzyERdsNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/152] soc/tegra: fuse: Update Tegra234 nvmem keepout list
Date: Wed, 19 Feb 2025 09:27:21 +0100
Message-ID: <20250219082551.151766342@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

[ Upstream commit 836b341cc8dab680acc06a7883bfeea89680b689 ]

Various Nvidia userspace applications and tests access following fuse
via Fuse nvmem interface:

	* odmid
	* odminfo
	* boot_security_info
	* public_key_hash
	* reserved_odm0
	* reserved_odm1
	* reserved_odm2
	* reserved_odm3
	* reserved_odm4
	* reserved_odm5
	* reserved_odm6
	* reserved_odm7
	* odm_lock
	* pk_h1
	* pk_h2
	* revoke_pk_h0
	* revoke_pk_h1
	* security_mode
	* system_fw_field_ratchet0
	* system_fw_field_ratchet1
	* system_fw_field_ratchet2
	* system_fw_field_ratchet3
	* optin_enable

Update tegra234_fuse_keepouts list to allow reading these fuse from
nvmem sysfs interface.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Link: https://lore.kernel.org/r/20241127061053.16775-1-kkartik@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra30.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra30.c b/drivers/soc/tegra/fuse/fuse-tegra30.c
index e94d46372a639..402cf939c0326 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -646,15 +646,20 @@ static const struct nvmem_cell_lookup tegra234_fuse_lookups[] = {
 };
 
 static const struct nvmem_keepout tegra234_fuse_keepouts[] = {
-	{ .start = 0x01c, .end = 0x0c8 },
-	{ .start = 0x12c, .end = 0x184 },
+	{ .start = 0x01c, .end = 0x064 },
+	{ .start = 0x084, .end = 0x0a0 },
+	{ .start = 0x0a4, .end = 0x0c8 },
+	{ .start = 0x12c, .end = 0x164 },
+	{ .start = 0x16c, .end = 0x184 },
 	{ .start = 0x190, .end = 0x198 },
 	{ .start = 0x1a0, .end = 0x204 },
-	{ .start = 0x21c, .end = 0x250 },
-	{ .start = 0x25c, .end = 0x2f0 },
+	{ .start = 0x21c, .end = 0x2f0 },
 	{ .start = 0x310, .end = 0x3d8 },
-	{ .start = 0x400, .end = 0x4f0 },
-	{ .start = 0x4f8, .end = 0x7e8 },
+	{ .start = 0x400, .end = 0x420 },
+	{ .start = 0x444, .end = 0x490 },
+	{ .start = 0x4bc, .end = 0x4f0 },
+	{ .start = 0x4f8, .end = 0x54c },
+	{ .start = 0x57c, .end = 0x7e8 },
 	{ .start = 0x8d0, .end = 0x8d8 },
 	{ .start = 0xacc, .end = 0xf00 }
 };
-- 
2.39.5



