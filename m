Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E6619409E;
	Wed,  2 Oct 2024 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879512; cv=none; b=Sg826oMRdGS4+/L2yRlooIEM56sCsp18IR4fFfJFLQJ+e2bdNnGxi05yFWvONf4JS/BtPwnUDtMZZNdfelpnaJY+46L5jx4dayAatOp+V2hcixpuepjfR6KLwy6v6yHXg4xmNkcTJhCqows0F+UXCh1PNB+mmdON7X1mZJeP5QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879512; c=relaxed/simple;
	bh=4Zqv8FnpupVrit6xb4x5JqH/OEIeNNIeM1OFMFOCqr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hu+Pn1W17Euw8Mwk84o/yRWUas87WGz7RuZrag7hNEr79PVBuDFCg7gNxDynUpHmfHpMlcpIUy5Atdq4XXZQGfzpduKqdP9wul1cz/rNNBQa57BJ0kypEQmz8yj6Y/dJer/i4qDctFvITXuGMSIUr8kE9wpb5OGrKNgbqnA46s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OB5yDMPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OB5yDMPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFEEC4CEC2;
	Wed,  2 Oct 2024 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879512;
	bh=4Zqv8FnpupVrit6xb4x5JqH/OEIeNNIeM1OFMFOCqr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OB5yDMPcdN9rh2PT7TZsV8vygsyzxoFUdVnXFqsn04FLn2B2TSsWanGOarFjrcOv8
	 ZjPyqYhEuyFB1JiJp07MvYWcGocZRRZDv41pLcdMKpULhCOjMvyg8weboOuOeHevql
	 1jNJzQE8Q12KFLXF0iZaI+JxlpYdj/pIupbwgNKY=
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
Subject: [PATCH 6.6 145/538] drm/amd/amdgpu: Properly tune the size of struct
Date: Wed,  2 Oct 2024 14:56:24 +0200
Message-ID: <20241002125757.964374177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 104a5ad8397da..198687545407e 100644
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



