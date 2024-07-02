Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696211B583A;
	Tue,  2 Jul 2024 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940645; cv=none; b=ourUzkcmR2fm8tlQCTkLp4OaVuXmtcfj2tDIU7VbJcx5eWSystS2Haeif1+DFJhX+z4z5JqYvkHhYh75vDSQ246d0llppre//uMCDUBUPJ2PiES9DuazcwIqJRveoFB/DS0nOmHxw2DXwriHkrPpoyMC78FUBdpC7SnmxpFcg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940645; c=relaxed/simple;
	bh=wgGEhkKLZ0KY4og9DEIarQR4t3QGwuVEANj8o+5Kj5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKWoZ99+GLrd/0uoihMfSGzncnl255hcTwJRqICl8zvMv3YR8hGzwcoeJcR8kXwlcAW5x7EPFHlNgRk2x5eK1mo6VBSskcTI5LV2hurXBUAEgdRBdiZI3SPZyPAENP4NKe4jvIJEQhyn0RAWmNgmCgCXMCnWekrkBp1hTGSWQJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtdOLkOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtdOLkOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A71C116B1;
	Tue,  2 Jul 2024 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940645;
	bh=wgGEhkKLZ0KY4og9DEIarQR4t3QGwuVEANj8o+5Kj5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtdOLkOMCewE/4voSPM4NSwv75DApMviJWHPCCTgwyU2CFKQ2W/jBU7Mj6oXtN8Ne
	 Mn6Kwg3Hdo93x0hWuZ4HFUm6VtmvYDyUcI/N2VrXcGMWIah2J6aK0PKwDpuWPygzCG
	 ZMzaDu0iyteU0YCt9aWPmoSRbjqzzBNxhaLpdfOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 186/222] drm/amdgpu/atomfirmware: fix parsing of vram_info
Date: Tue,  2 Jul 2024 19:03:44 +0200
Message-ID: <20240702170251.095611874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f6f49dda49db72e7a0b4ca32c77391d5ff5ce232 upstream.

v3.x changed the how vram width was encoded.  The previous
implementation actually worked correctly for most boards.
Fix the implementation to work correctly everywhere.

This fixes the vram width reported in the kernel log on
some boards.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -399,7 +399,7 @@ amdgpu_atomfirmware_get_vram_info(struct
 					mem_channel_number = vram_info->v30.channel_num;
 					mem_channel_width = vram_info->v30.channel_width;
 					if (vram_width)
-						*vram_width = mem_channel_number * (1 << mem_channel_width);
+						*vram_width = mem_channel_number * 16;
 					break;
 				default:
 					return -EINVAL;


