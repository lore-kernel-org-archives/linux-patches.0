Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C2264614;
	Tue,  8 Apr 2025 11:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111031; cv=none; b=E+y2m688Jg9zGBrrWTUuR6OvDDGo/XzXpTcLir84ztL4wB5Ru5XoM08z1Qb/ZjeUpaZx9gLt41ZES7bFCjUEYEgiqunBond+W1Z0jShzvZo7Biy6yLxtFSK8+1cMTeOpS0P/PteK29Pb5EJO5k7OqSf2sDanNTpFzAEldO04UCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111031; c=relaxed/simple;
	bh=IcqBufGlAaLaBQBltv1sSklNMeuHbti5DexD3ue0NN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtDmz0u1qy+ILgqUhRoWfV2+pdiM/Ie275MCKmcLsYGg+KQWib+uBZRgvE8QwN3bVduqpbd68lDWmr/5VLR2aOlP6z1f+Z/EQ0gzu/ce6jYQHG34qW9MBn7UFEI2//Exm6NFkZsdVxh6JbzjE35AYCAcfONLoVoRVdFaJ4cHf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2daaBsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2daaBsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D246C4CEE5;
	Tue,  8 Apr 2025 11:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111031;
	bh=IcqBufGlAaLaBQBltv1sSklNMeuHbti5DexD3ue0NN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2daaBsuKETI/octhNCj7RCx5oBAIymsZPvjT8Ht0oDr6D8kYEJVWH1NzEqLBB53o
	 V+B/cUFqtafM+YYAY4Vi7oGIBMfKGW2G7E30JS/T4RTa4Bnzhv0PlbPE9yPqpSt3A2
	 TrTswxsjZ0pQ40yQaoTgRi62JHhrLoL9isDz+/sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lang Yu <Lang.Yu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 283/731] drm/amdgpu/umsch: fix ucode check
Date: Tue,  8 Apr 2025 12:43:00 +0200
Message-ID: <20250408104920.861448628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c917e39cbdcd9fff421184db6cc461cc58d52c17 ]

Return an error if the IP version doesn't match otherwise
we end up passing a NULL string to amdgpu_ucode_request.
We should never hit this in practice today since we only
enable the umsch code on the supported IP versions, but
add a check to be safe.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502130406.iWQ0eBug-lkp@intel.com/
Fixes: 020620424b27 ("drm/amd: Use a constant format string for amdgpu_ucode_request")
Reviewed-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
index 78319988b0545..a7f2648245ec0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
@@ -129,7 +129,7 @@ int amdgpu_umsch_mm_init_microcode(struct amdgpu_umsch_mm *umsch)
 		fw_name = "amdgpu/umsch_mm_4_0_0.bin";
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	r = amdgpu_ucode_request(adev, &adev->umsch_mm.fw, AMDGPU_UCODE_REQUIRED,
-- 
2.39.5



