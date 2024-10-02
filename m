Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCE61D078B;
	Wed,  2 Oct 2024 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877765; cv=none; b=KSmGY8oKnolKILWtt5BMUg5ueq7xiCgRchYqsVkzhm1i4QYA2qFECJ5cuWHJZKn6En5InMc8/jB5CTqIvLyGfvxv/hQEcC78Kpv93zQI8CSA7CLS03YTehnYp2GfL8gd3S0UnwCluGCZ2L1iMjHIkKtqf80ZZpRioiuJuecaau4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877765; c=relaxed/simple;
	bh=wxIpTNNR312YTC+SLUX1z/DXHwNJ5FuAYc+C2HuDmNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWTgMDq2p3HHdcnnJl9DRGn3bCuUfNTDMHdtzJnb/XIRGA6oOpbX3vWjbPgG5VvZjJoP6KxOwWFmgB9xERURHwgVv+v5228Z6CAWlgmQDfShwdBElcYCfif8ZmREvE5JE4258hcKwj3+8qYH77joM7DfHyC1HyvpP/J8IkhJgGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+T/rIdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+T/rIdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E00C4CEC2;
	Wed,  2 Oct 2024 14:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877764;
	bh=wxIpTNNR312YTC+SLUX1z/DXHwNJ5FuAYc+C2HuDmNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+T/rIdzmEmCH7s0RN47c9k2XmHic0bej+qlpssgf0W9LT4L4Q8iUTH1Y6FFt7odN
	 24RWf/Q2jqN5Be8an/oO+hMZH80DjvBf6Yi5/7V5AhabHdxjJ3ozrjUs8pV3VO+5uD
	 LcsgFiJs7304RlewFQXqNJ/3VR45v0AtlEIEACDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	wenlunpeng <wenlunpeng@uniontech.com>,
	Su Hui <suhui@nfschina.com>,
	WangYuli <wangyuli@uniontech.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 186/634] drm/amd/amdgpu: Properly tune the size of struct
Date: Wed,  2 Oct 2024 14:54:46 +0200
Message-ID: <20241002125818.448916185@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 0cee47cde41e22712c034ae961076067d4ac13a0 ]

The struct assertion is failed because sparse cannot parse
`#pragma pack(push, 1)` and `#pragma pack(pop)` correctly.
GCC's output is still 1-byte-aligned. No harm to memory layout.

The error can be filtered out by sparse-diff, but sometimes
multiple lines queezed into one, making the sparse-diff thinks
its a new error. I'm trying to aviod this by fixing errors.

Link: https://lore.kernel.org/all/20230620045919.492128-1-suhui@nfschina.com/
Link: https://lore.kernel.org/all/93d10611-9fbb-4242-87b8-5860b2606042@suswa.mountain/
Fixes: 1721bc1b2afa ("drm/amdgpu: Update VF2PF interface")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: wenlunpeng <wenlunpeng@uniontech.com>
Reported-by: Su Hui <suhui@nfschina.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
index fb2b394bb9c55..6e9eeaeb3de1d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
@@ -213,7 +213,7 @@ struct amd_sriov_msg_pf2vf_info {
 	uint32_t gpu_capacity;
 	/* reserved */
 	uint32_t reserved[256 - AMD_SRIOV_MSG_PF2VF_INFO_FILLED_SIZE];
-};
+} __packed;
 
 struct amd_sriov_msg_vf2pf_info_header {
 	/* the total structure size in byte */
@@ -273,7 +273,7 @@ struct amd_sriov_msg_vf2pf_info {
 	uint32_t mes_info_size;
 	/* reserved */
 	uint32_t reserved[256 - AMD_SRIOV_MSG_VF2PF_INFO_FILLED_SIZE];
-};
+} __packed;
 
 /* mailbox message send from guest to host  */
 enum amd_sriov_mailbox_request_message {
-- 
2.43.0



