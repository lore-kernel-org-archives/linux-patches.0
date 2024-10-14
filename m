Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74D1AAE38;
	Mon, 14 Oct 2024 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917715; cv=none; b=uDhhQMswuGo9Uu4p402nxdrvAosq/UtUXXOOeyNK/0ZDw64GOmafWdkyfhs6nLg7JMqiagAY3EjMYQa6YGJtVNzuhdr+kxdv4d9rwO02bOtH827RcIw2hxv4tK88ZI13w8KV2kKrYCEwIeLasb+KHjc0NoVVr/RZLcB/zq1nP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917715; c=relaxed/simple;
	bh=/51fLKPWDUX6bIs1g2wIZVbiBgXTGwemzafGrytGHto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyVBHA7d4efKc4HIieiZtxXBYpaBeaaN8IwUnYHHKB+i9tv9rhWevQ5hmLM/Imlvb/KsSCA7gg6EHRVNEx6XMSOKeiAvrUn74HZ6kP2wla5Q2AoEwcgzw8Dy7RGUl2Kg0s7nfVkWotwWUtJVpyvBKhQfhWNUpqckJXmW9Uclhao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qx+pku4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qx+pku4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE663C4CEC3;
	Mon, 14 Oct 2024 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917715;
	bh=/51fLKPWDUX6bIs1g2wIZVbiBgXTGwemzafGrytGHto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx+pku4tPeA6yaTfZCyRuGh+1trPzFJGpNOo6z98/JeZuClBRnPC2seNz8fJvUlAw
	 2e8XPFRVtm7QY5+n/eLwOwLOpo92S6L22Z/DYzyXyHnha4jFTsHIg7p3rKoPjAoK3o
	 P56Ap9YXb0ygAxZzWWujgLbc0Wtbmf0HSACoixWs=
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
Subject: [PATCH 6.1 112/798] drm/amd/amdgpu: Properly tune the size of struct
Date: Mon, 14 Oct 2024 16:11:06 +0200
Message-ID: <20241014141222.326090612@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 6c97148ca0ed3..99f459bd2748d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h
@@ -209,7 +209,7 @@ struct amd_sriov_msg_pf2vf_info {
 	uint32_t pcie_atomic_ops_support_flags;
 	/* reserved */
 	uint32_t reserved[256 - AMD_SRIOV_MSG_PF2VF_INFO_FILLED_SIZE];
-};
+} __packed;
 
 struct amd_sriov_msg_vf2pf_info_header {
 	/* the total structure size in byte */
@@ -267,7 +267,7 @@ struct amd_sriov_msg_vf2pf_info {
 
 	/* reserved */
 	uint32_t reserved[256 - AMD_SRIOV_MSG_VF2PF_INFO_FILLED_SIZE];
-};
+} __packed;
 
 /* mailbox message send from guest to host  */
 enum amd_sriov_mailbox_request_message {
-- 
2.43.0



