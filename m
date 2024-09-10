Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1269318CC1A;
	Tue, 10 Sep 2024 10:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963289; cv=none; b=KtUnTineCFf7CTRfYMpwNVaL4AxhjlnL13rozsYHZltE9xdTYNc2hRSYhJdyCeeksnp47lQHsIbCj383jsifl6PnnZNqvDQ+dK9Js5uN3bDadnpYMltqdvVzFrfDXt7MLV7AvgVFBRYUI2DuAyVEY3rCV8usHq0DsebyWnDWEG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963289; c=relaxed/simple;
	bh=iC1N556VCaZDULx/84oJoxmUOQsJOXjpHIE8Cv8wkrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJBy0p+ksXS2nA6KgwrI3aWHaqIPZCqjqpVoBWRN4SstrI76Zm3ARlxjRmmqcH0VlftVWy6eg1yNU9BcWFfUWvDGO57kY5IC6rkoPBxmR3XfM48PAlNMj7eZfxv1AHMkZHb8nPHOtpsyqbpwz8Px+pH/csWY/ifmquBr7wUaAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcmrhEZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcmrhEZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E43C4CEC3;
	Tue, 10 Sep 2024 10:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963289;
	bh=iC1N556VCaZDULx/84oJoxmUOQsJOXjpHIE8Cv8wkrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcmrhEZ+4YSpo+i/6sszwTBTCMQiCNj6x0Eeut7OBK1mZF9f89GH6zDvldg3zZhyd
	 xra6oTDKemS9PbcAqzNZCnPA6d34xeGft+7G9q/Za5/m2oI481dZoViA/p2PWAVfYV
	 Vy6MA/oRdNYCH+Y3rWFaGbBs0+i7p4c2AFRuxNKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/192] drm/amd: Add gfx12 swizzle mode defs
Date: Tue, 10 Sep 2024 11:33:17 +0200
Message-ID: <20240910092604.987707301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 7ceb94e87bffff7c12b61eb29749e1d8ac976896 ]

Add GFX12 swizzle mode definitions for use with DCN401

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/drm_fourcc.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 868d6909b718..52ce13488eaf 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -1390,6 +1390,7 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
 #define AMD_FMT_MOD_TILE_VER_GFX10 2
 #define AMD_FMT_MOD_TILE_VER_GFX10_RBPLUS 3
 #define AMD_FMT_MOD_TILE_VER_GFX11 4
+#define AMD_FMT_MOD_TILE_VER_GFX12 5
 
 /*
  * 64K_S is the same for GFX9/GFX10/GFX10_RBPLUS and hence has GFX9 as canonical
@@ -1400,6 +1401,8 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
 /*
  * 64K_D for non-32 bpp is the same for GFX9/GFX10/GFX10_RBPLUS and hence has
  * GFX9 as canonical version.
+ *
+ * 64K_D_2D on GFX12 is identical to 64K_D on GFX11.
  */
 #define AMD_FMT_MOD_TILE_GFX9_64K_D 10
 #define AMD_FMT_MOD_TILE_GFX9_64K_S_X 25
@@ -1407,6 +1410,19 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
 #define AMD_FMT_MOD_TILE_GFX9_64K_R_X 27
 #define AMD_FMT_MOD_TILE_GFX11_256K_R_X 31
 
+/* Gfx12 swizzle modes:
+ *    0 - LINEAR
+ *    1 - 256B_2D  - 2D block dimensions
+ *    2 - 4KB_2D
+ *    3 - 64KB_2D
+ *    4 - 256KB_2D
+ *    5 - 4KB_3D   - 3D block dimensions
+ *    6 - 64KB_3D
+ *    7 - 256KB_3D
+ */
+#define AMD_FMT_MOD_TILE_GFX12_64K_2D 3
+#define AMD_FMT_MOD_TILE_GFX12_256K_2D 4
+
 #define AMD_FMT_MOD_DCC_BLOCK_64B 0
 #define AMD_FMT_MOD_DCC_BLOCK_128B 1
 #define AMD_FMT_MOD_DCC_BLOCK_256B 2
-- 
2.43.0



