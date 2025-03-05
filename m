Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0A52561D9;
	Wed,  5 Mar 2025 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198719; cv=none; b=ad1MXDUgVWh9/nQJIiuxqDrgZKfli0DrXv2CWx6J/wH0NeEqet2hzHENdtndPo8PqavxU5axTFnNcEoxsbHsTH2Pg6ANA9mw5MVb3wkk7kW0JZZicbcJM6KeUSRuJL4zLMlt56zNrsJkhY4serWtCRpSjtLCGQ+4nyyRH46BSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198719; c=relaxed/simple;
	bh=B3o48Xqky6fgKHuWJGglnBiKH1IFT3kPlqOxlvI+Xig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFlRFPyL4IS6yfeMkir06QzA/h2/Fuy5+aYope3jAWFnvW0c5O2AaTtLBd0PI/9ftMZHpb7H53JzJgY3OIL+TGsfb/lzxmKMbGdSeaYdtgVbWJS7b0J+zoHRQjvII3ODrp3hb+0aNXz8I0osjDDrxVU8L1F92vd5KRrW120wGpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFMjWTYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFMjWTYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A4C4CED1;
	Wed,  5 Mar 2025 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198719;
	bh=B3o48Xqky6fgKHuWJGglnBiKH1IFT3kPlqOxlvI+Xig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFMjWTYZp77MlGj5Sio8AyT1x8iDbevGI0q/zqwth3/7VYvxQlXg495GHg7mQ03G5
	 qUOYqW5F3ExyfbXnzd5eVdWF2iI3YTzaSnsHlKKI5UXasnawiigr05sk6gv0pkoAsG
	 HeNzi3yynbfI1FS5Al7Tkt+CgsdE6MF9YeaMGr6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <David.YatSin@amd.com>,
	Jay Cornwall <jay.cornwall@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 093/157] drm/amdkfd: Preserve cp_hqd_pq_control on update_mqd
Date: Wed,  5 Mar 2025 18:48:49 +0100
Message-ID: <20250305174509.052792095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


