Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F281DE3AF;
	Wed, 19 Feb 2025 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954956; cv=none; b=inE0pU4AtqupVsFwa5/CyMVdOBZLCOr+8GSaVCE336f/JUt2itSCDrzbVs64qr8ksEzWSaoKvYoc/wBPgNadKw+cgBvX/xqiSKNkUqAYQu21vPRR/9AOrv/i3siXYZbu2T1Tpqn8fV7A0UX3ivB8jI08IgIp8jfQ9iUSeuKmzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954956; c=relaxed/simple;
	bh=0YMd8nVhTIL6b8c+MUlzw5V12Tn0QGn8cfrAHmaYnVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZJamkn+xqtpo/vYFQ0h5hJAoRB0HQI1Gh9UCk0rtb9SnmUcH9GqFBay6bMRp0xEqEP1n8OE8PVLKHJxS8bvdoicrsDp0rtlgx6OXA9a4yNUlzfTkx3G8DyDJsVPPuEyzrgO8UGlwSnH2bo1Hf6x4Y90k335c7UKMK99i9p50LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYpeDvYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYpeDvYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB97C4CEE7;
	Wed, 19 Feb 2025 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954956;
	bh=0YMd8nVhTIL6b8c+MUlzw5V12Tn0QGn8cfrAHmaYnVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYpeDvYL8hP5cA00YJOcEA0QIRBTYxR/3Xo1Xvbwdiymn0PaLzjBrPXALUeo0O9X4
	 K0QKU3m40nqkXSA984KqQUKgbjMi6d7PYTIZpXHiSzJGLm/dVtuuZUP3hX/UT8YIMw
	 gvBuh+6k0qA9ej1s3G9Dq/QbKMdKAfbSAKdCfGGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/230] soc/tegra: fuse: Update Tegra234 nvmem keepout list
Date: Wed, 19 Feb 2025 09:26:18 +0100
Message-ID: <20250219082604.100880981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eb14e5ff5a0aa..e24ab5f7d2bf1 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -647,15 +647,20 @@ static const struct nvmem_cell_lookup tegra234_fuse_lookups[] = {
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



