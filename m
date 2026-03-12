Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432B738C2C0;
	Thu, 12 Mar 2026 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773352015; cv=none; b=bIi36Y4TdwCvkxFbWgfQAZkRWKTbPVlcbv1Nzm9hR/4h3oRiiyRt9sjrxfOuc+EwBf5f44u00VSksarqoqk53feUEBhfVBHuPnK3/+zZyQTEsh1J4jwVNrh23Y3r8hdXJGPaW2IH8YjA+iEteeDZVNyKemj1hdVHYGk9nN3IWQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773352015; c=relaxed/simple;
	bh=NwDzJSDpxtFSvPZOy19nkzCcGXaIV5w84KoC01820Eo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=loMXwB8Qx7bqQqIyJJaLj6ZxkdKx0pl+G0cYQhCfzxFQEe8yJ0RzqxhnIOennnDUuHl+S0FMU15S8UuKLPlTLB0L90T5LbfPAAoIPiybbqXFmHDCY37xh0DPGI0A/JC/j+j4vxqMtw9uLimfev50SBMz7P2DM5PQylXtnwD7BFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=an2krcmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="an2krcmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E98BC19425;
	Thu, 12 Mar 2026 21:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773352014;
	bh=NwDzJSDpxtFSvPZOy19nkzCcGXaIV5w84KoC01820Eo=;
	h=From:Date:Subject:To:Cc:From;
	b=an2krcmwEQKGvOo/WYOQYpB8MBoeCrJua7aUbBNkTUFU1nLzEWUNQUrjqiOOswAvC
	 2UXtqBTmh6/AtGUrz0CdY8nVXpLjBbYXDTq3eBiIe0YGOnExQ2e1iB3m5gNq7Dcc0O
	 ZKrwdUkcp8RmVGPUWsJI39VXd83LC9ugezgLDL9GKTsxOdHyveKjS70OrRSvAWP1fi
	 XgGl2WSmhVIotEg7qjgZkZXuwXCfEKzKbr3azE2VT4pOOydXZ+Z1hI10keair1YaE9
	 4LVEmclf78OPCAY+j5fpvUDDvoYyuPvQAEmYQGW09X4QqDhLCgVFecEIrpR0T6Bzlr
	 POU8uL4U1Ghww==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 12 Mar 2026 14:46:48 -0700
Subject: [PATCH] drm/amdgpu/discovery: Add braces to case statements in
 amdgpu_discovery_table_check()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260312-amdgpu-fix-clang-c23-extensions-v1-1-59883120a451@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWN0QqCQBBFf0XmuQF3DIl+JXrQ8WobtcmOiiD+e
 2M9Hjj33I0MOcLoWmyUsUSLn+QQTgXpo0kDOHbOJKXUZRWEm3c3jDP3cWV9ucAqFWOdkI6pceh
 buQCozyrklTHD3d/D7f5nm9sndDqytO9f/timeoMAAAA=
X-Change-ID: 20260312-amdgpu-fix-clang-c23-extensions-1fb28eee64c2
To: Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>, 
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4596; i=nathan@kernel.org;
 h=from:subject:message-id; bh=NwDzJSDpxtFSvPZOy19nkzCcGXaIV5w84KoC01820Eo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmbTXwUSpfrcoSzSGe/y7jIOrOF4/kn3q0/RRS2tiqsl
 r0m7lXRUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZyZg7DP+MfTZLXVqwMVjTX
 emXG7lraukOLzctoiqTf1RTV0nsn2xn+F7ZXquapWzcJb/Cf3hL/k0lhOlPWXofZIaUcz5/opDZ
 zAgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with a version of clang that supports the narrower
'-fms-anonymous-structs' (as opposed to the wider '-fms-extensions')
along with the associated kernel support (such as in next-20260312 [1]),
there are warnings (or errors with CONFIG_WERROR=y / W=e) from the
switch statement added by commit 47ab777c16c7 ("drm/amdgpu/discovery:
use common function to check discovery table").

  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:560:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    560 |                 struct ip_discovery_header *ihdr =
        |                 ^
  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:568:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    568 |                 struct gpu_info_header *ghdr =
        |                 ^
  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:576:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    576 |                 struct harvest_info_header *hhdr =
        |                 ^
  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:584:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    584 |                 struct vcn_info_header *vhdr =
        |                 ^
  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:592:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    592 |                 struct mall_info_header *mhdr =
        |                 ^

If '-fms-extensions' were not present, this would be a hard error in
older clang versions.

Add braces to the case statements that declare variables to clear up the
warnings.

Fixes: 47ab777c16c7 ("drm/amdgpu/discovery: use common function to check discovery table")
Link: https://git.kernel.org/next/linux-next/c/0d3fccf68d9873a3c824fb70be0dbb2c4642aa90 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index f9f785c5d8ac..4209945af66f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -556,7 +556,7 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 	checksum = le16_to_cpu(info->checksum);
 
 	switch (table_id) {
-	case IP_DISCOVERY:
+	case IP_DISCOVERY: {
 		struct ip_discovery_header *ihdr =
 			(struct ip_discovery_header *)(discovery_bin + offset);
 		act_val = le32_to_cpu(ihdr->signature);
@@ -564,7 +564,8 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 		table_size = le16_to_cpu(ihdr->size);
 		table_name = "data table";
 		break;
-	case GC:
+	}
+	case GC: {
 		struct gpu_info_header *ghdr =
 			(struct gpu_info_header *)(discovery_bin + offset);
 		act_val = le32_to_cpu(ghdr->table_id);
@@ -572,7 +573,8 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 		table_size = le16_to_cpu(ghdr->size);
 		table_name = "gc table";
 		break;
-	case HARVEST_INFO:
+	}
+	case HARVEST_INFO: {
 		struct harvest_info_header *hhdr =
 			(struct harvest_info_header *)(discovery_bin + offset);
 		act_val = le32_to_cpu(hhdr->signature);
@@ -580,7 +582,8 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 		table_size = sizeof(struct harvest_table);
 		table_name = "harvest table";
 		break;
-	case VCN_INFO:
+	}
+	case VCN_INFO: {
 		struct vcn_info_header *vhdr =
 			(struct vcn_info_header *)(discovery_bin + offset);
 		act_val = le32_to_cpu(vhdr->table_id);
@@ -588,7 +591,8 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 		table_size = le32_to_cpu(vhdr->size_bytes);
 		table_name = "vcn table";
 		break;
-	case MALL_INFO:
+	}
+	case MALL_INFO: {
 		struct mall_info_header *mhdr =
 			(struct mall_info_header *)(discovery_bin + offset);
 		act_val = le32_to_cpu(mhdr->table_id);
@@ -597,6 +601,7 @@ static int amdgpu_discovery_table_check(struct amdgpu_device *adev,
 		table_name = "mall table";
 		check_table = false;
 		break;
+	}
 	default:
 		dev_err(adev->dev, "invalid ip discovery table id %d specified\n", table_id);
 		check_table = false;

---
base-commit: 7a9419ab42699fd3d4c857ef81ae097d8d8d5899
change-id: 20260312-amdgpu-fix-clang-c23-extensions-1fb28eee64c2

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

