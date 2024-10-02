Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0B1CFECF;
	Wed,  2 Oct 2024 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875757; cv=none; b=HL+82vhBasBe/BN29eQ7brWmhfVqNuTr55b1th7bNv3Dqi1s59soR3I6vsuYBP1L0H9AUeYwboQz1tsHs7Od+tVw59qiBqIqpmWmIvcrBn15sVEy699RUvnok5ljHJRYIeldfagx5kUDbPwsQXaiJJkcC6US9skUaSr89MVBHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875757; c=relaxed/simple;
	bh=ShDQyM3TtMlClTIs1ldSuxFAmaztkd85o319esO+OI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knR5QM+/W3B2EJWgA3y3LkiaqG9nmQMuRlHF3A2Ib5wDdkd8lnbad6Usj7c4re+qrIQBTYnOxXfaJoz0kCFHYECrEF3fhj87CS7wt42DZiyU7Z8EMj3VRq2M1M1b+0CzP7SXXaMbKE51ZXzGjBVoepl/Z8QQeMxuKtxuORk7T40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyA8C+sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyA8C+sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0006AC4CEC5;
	Wed,  2 Oct 2024 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875757;
	bh=ShDQyM3TtMlClTIs1ldSuxFAmaztkd85o319esO+OI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyA8C+sa975gYl8ZO/VTZeYFQZDD5S+vi9ZfqAWeK2pCn3dw9kHbycFDJ7B6jGitv
	 RICPfzk8WnPVLhLKAT2cdFPI8K8mbt2nVwMD0B2CG4ADgaVTDm1w3gIcHIrtjx8U0E
	 1DEINQ/I0bxq+XJZ9a+ZgV3qd1gzjEIrJqzSZULc=
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
Subject: [PATCH 6.11 210/695] drm/amd/amdgpu: Properly tune the size of struct
Date: Wed,  2 Oct 2024 14:53:28 +0200
Message-ID: <20241002125830.842950398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



