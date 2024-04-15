Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7631E4B1;
	Mon, 15 Apr 2024 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191411; cv=none; b=k2c4Onw/YNmNlRLmgRNKcquhoA5PZN/Rg/bv9vwWHHaOVedBX2ULi0UgOS/J/5PoZS96k78gzi4/6vBhmbBY5UC0pYxORPpyclsi8B5n9LKSaLBDzJvgms3Ve6AyCXkBuLH5VHMLd3VL/WKTjQUwTRPSwYzEI7fK63rV+6LAYCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191411; c=relaxed/simple;
	bh=Qi2+WbdjAgRRKFvdFlqmyRd3tmg52YoepRpFyccY+EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=on9lmIKahi1PWNLsO5ysyaj41dR6JxnJFSshc4VklpPINE5bzwxnPmDNW7SGbQ0A/ToDNNtLn466ZowDfnVlT6tGPmLVHXdrSo2hWURpNVhAZlC5Ww7DAAyK/xMKT2AqQyRcvbebeyHDaKa694yM8QZy1gMaIjHyfBX4NGHyMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7ZzAsGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7ZzAsGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A8BC2BD10;
	Mon, 15 Apr 2024 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191411;
	bh=Qi2+WbdjAgRRKFvdFlqmyRd3tmg52YoepRpFyccY+EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7ZzAsGq1dddP4XnJHQrdPb1tqiFhor/3eOV8UiyC1blJxvemWjHv+dQl6AZ5XYKR
	 ZRUBONDJ3e9mvhcAgysuX70pLPK+rILOiCo1Z6dd0ZrEpJ3qVCw0ANPm22lKfhi3MD
	 qa2QWkj0WFHnuvaF1CNmJkT8UXYYtnBNjZbHVdC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 131/172] drm/amdgpu/umsch: reinitialize write pointer in hw init
Date: Mon, 15 Apr 2024 16:20:30 +0200
Message-ID: <20240415142004.360946908@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <Lang.Yu@amd.com>

commit 0f1bbcc2bab25d5fb2dfb1ee3e08131437690d3d upstream.

Otherwise the old one will be used during GPU reset.
That's not expected.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/umsch_mm_v4_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/umsch_mm_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/umsch_mm_v4_0.c
@@ -225,6 +225,8 @@ static int umsch_mm_v4_0_ring_start(stru
 
 	WREG32_SOC15(VCN, 0, regVCN_UMSCH_RB_SIZE, ring->ring_size);
 
+	ring->wptr = 0;
+
 	data = RREG32_SOC15(VCN, 0, regVCN_RB_ENABLE);
 	data &= ~(VCN_RB_ENABLE__AUDIO_RB_EN_MASK);
 	WREG32_SOC15(VCN, 0, regVCN_RB_ENABLE, data);


