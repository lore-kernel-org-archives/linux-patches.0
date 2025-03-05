Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EAC1C6FF6;
	Wed,  5 Mar 2025 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198195; cv=none; b=tkDB02pLra5WTfDlO5DToC5D7wjwMX99awzhuSjaJPJIk5z63ZmYb3IkjXZ3EJV73N6XJFtvYeOcD5jzp5S0ualRaToReCzxCP0V1fK+h2AwwafIB9SAtNE4P9mNT3zsuyoSnYfFrnWFbFeVL4FNuClYLG+KzQUnIDosrHQ1hC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198195; c=relaxed/simple;
	bh=a2/BQARqFeiZNkhtN3IdBO7qlL+Y1UYCKP1CV7fJTDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQQgevyiMTK4PaDaMzR4mIz0mlJTnXXvdROwp+eVMlVRo+O2l1ReVayaqWscdm3P2P/Mnsom1x1eWIsfv8Dj4mK9e+qQLSGHJEXUbYFCVQja7ggoUtCaAgzXnNkNxXrTP3WPnknw/1Q8u5je3/1EXOfzKPIY4fgJvXQvC7njmJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+pvJG+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+pvJG+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B4C4CED1;
	Wed,  5 Mar 2025 18:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198195;
	bh=a2/BQARqFeiZNkhtN3IdBO7qlL+Y1UYCKP1CV7fJTDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+pvJG+oVFwwo4wahy3iK+Hm1pvm2NZq1ejUAMoCe0gco8oEg//RnDBmN9ZXNG6zi
	 FyVBAvdA2CJfnZvAYMcoyrWCz9giVvmDv07MDNBH5KeilnQG02BqJre5kCPGrCZIkN
	 mbi7MBgzfXU7mW7aVpZr63nztTuB+cGzSgiBPN1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Jay Cornwall <jay.cornwall@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 096/150] drm/amdkfd: Preserve cp_hqd_pq_control on update_mqd
Date: Wed,  5 Mar 2025 18:48:45 +0100
Message-ID: <20250305174507.668112520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yat Sin <David.YatSin@amd.com>

commit 3502ab5022bb5ef1edd063bdb6465a8bf3b46e66 upstream.

When userspace applications call AMDKFD_IOC_UPDATE_QUEUE. Preserve
bitfields that do not need to be modified as they contain flags to
track queue states that are used by CP FW.

Signed-off-by: David Yat Sin <David.YatSin@amd.com>
Reviewed-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8150827990b709ab5a40c46c30d21b7f7b9e9440)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c |    6 ++++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c |    5 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c |    5 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c  |    5 ++++-
 4 files changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -107,6 +107,8 @@ static void init_mqd(struct mqd_manager
 	m->cp_hqd_persistent_state = CP_HQD_PERSISTENT_STATE__PRELOAD_REQ_MASK |
 			0x53 << CP_HQD_PERSISTENT_STATE__PRELOAD_SIZE__SHIFT;
 
+	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	m->cp_mqd_control = 1 << CP_MQD_CONTROL__PRIV_STATE__SHIFT;
 
 	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
@@ -167,10 +169,10 @@ static void update_mqd(struct mqd_manage
 
 	m = get_mqd(mqd);
 
-	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control &= ~CP_HQD_PQ_CONTROL__QUEUE_SIZE_MASK;
 	m->cp_hqd_pq_control |=
 			ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
-	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
+
 	pr_debug("cp_hqd_pq_control 0x%x\n", m->cp_hqd_pq_control);
 
 	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -154,6 +154,8 @@ static void init_mqd(struct mqd_manager
 	m->cp_hqd_persistent_state = CP_HQD_PERSISTENT_STATE__PRELOAD_REQ_MASK |
 			0x55 << CP_HQD_PERSISTENT_STATE__PRELOAD_SIZE__SHIFT;
 
+	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	m->cp_mqd_control = 1 << CP_MQD_CONTROL__PRIV_STATE__SHIFT;
 
 	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
@@ -221,10 +223,9 @@ static void update_mqd(struct mqd_manage
 
 	m = get_mqd(mqd);
 
-	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control &= ~CP_HQD_PQ_CONTROL__QUEUE_SIZE_MASK;
 	m->cp_hqd_pq_control |=
 			ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
-	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	pr_debug("cp_hqd_pq_control 0x%x\n", m->cp_hqd_pq_control);
 
 	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -121,6 +121,8 @@ static void init_mqd(struct mqd_manager
 	m->cp_hqd_persistent_state = CP_HQD_PERSISTENT_STATE__PRELOAD_REQ_MASK |
 			0x55 << CP_HQD_PERSISTENT_STATE__PRELOAD_SIZE__SHIFT;
 
+	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	m->cp_mqd_control = 1 << CP_MQD_CONTROL__PRIV_STATE__SHIFT;
 
 	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
@@ -184,10 +186,9 @@ static void update_mqd(struct mqd_manage
 
 	m = get_mqd(mqd);
 
-	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control &= ~CP_HQD_PQ_CONTROL__QUEUE_SIZE_MASK;
 	m->cp_hqd_pq_control |=
 			ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
-	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	pr_debug("cp_hqd_pq_control 0x%x\n", m->cp_hqd_pq_control);
 
 	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -182,6 +182,9 @@ static void init_mqd(struct mqd_manager
 	m->cp_hqd_persistent_state = CP_HQD_PERSISTENT_STATE__PRELOAD_REQ_MASK |
 			0x53 << CP_HQD_PERSISTENT_STATE__PRELOAD_SIZE__SHIFT;
 
+	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
+
 	m->cp_mqd_control = 1 << CP_MQD_CONTROL__PRIV_STATE__SHIFT;
 
 	m->cp_mqd_base_addr_lo        = lower_32_bits(addr);
@@ -244,7 +247,7 @@ static void update_mqd(struct mqd_manage
 
 	m = get_mqd(mqd);
 
-	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
+	m->cp_hqd_pq_control &= ~CP_HQD_PQ_CONTROL__QUEUE_SIZE_MASK;
 	m->cp_hqd_pq_control |= order_base_2(q->queue_size / 4) - 1;
 	pr_debug("cp_hqd_pq_control 0x%x\n", m->cp_hqd_pq_control);
 


