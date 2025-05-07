Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1873642A83;
	Wed,  7 May 2025 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643829; cv=none; b=p9K9wvCnh7YTeDbd8feMb+AslgPAAgwZP7DLtZDZ1vY0DnNyQkkFNYi6nopgd9w09zqO9GdcJPHHPStKm3I7DqdTB4y/xdOvWQHWrHWB9snNU0klPyIhUmWJc7R68byUjyCdZ0CnH4kYgESH1BXC1qL52dcyFfxAaDc4QpsTPWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643829; c=relaxed/simple;
	bh=BRnaPCIjcqRvX87+rh6dI0r6GfgVQmzscaVZEdEYqIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocGOAY6qKOE2QiqdkjJsymK/ook6h1Bl2H4TCGYQ7HDhkU8oDT6GEiv4Hx/vRkXrB8ziMt8OGKDqQ4+DxS7r322aPpMxprdPa1+qF8A53h3pdQuTrYWOg8umzFIaLBFitso/XAn0hdgzkqOGN3YVSp4BcMXlgIrgw1d8vsIWaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M85C3u6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M85C3u6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F62C4CEE2;
	Wed,  7 May 2025 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643829;
	bh=BRnaPCIjcqRvX87+rh6dI0r6GfgVQmzscaVZEdEYqIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M85C3u6c18QdN7Nieln41IMfiifto5ebpUNT3f9WbrkE2t/06KwKTzcKTXZS4JBX2
	 pv618HpgsdMcATgONZFP0v3RnaUt36CBdgrQy7rZ4lX/j9OyL4tVTRwywYX6FFf7Ug
	 YSZo2v5av1L3auyyXsLGOP+qlNROxZEU+Hjzwu6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 031/183] drm/amdgpu: Fix offset for HDP remap in nbio v7.11
Date: Wed,  7 May 2025 20:37:56 +0200
Message-ID: <20250507183825.951692124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit 79af0604eb80ca1f86a1f265a0b1f9d4fccbc18f upstream.

APUs in passthrough mode use HDP flush. 0x7F000 offset used for
remapping HDP flush is mapped to VPE space which could get power gated.
Use another unused offset in BIF space.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8116a32cdbe456c7f511183eb9ab187e3d590fb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
@@ -361,7 +361,7 @@ static void nbio_v7_11_get_clockgating_s
 		*flags |= AMD_CG_SUPPORT_BIF_LS;
 }
 
-#define MMIO_REG_HOLE_OFFSET (0x80000 - PAGE_SIZE)
+#define MMIO_REG_HOLE_OFFSET 0x44000
 
 static void nbio_v7_11_set_reg_remap(struct amdgpu_device *adev)
 {


