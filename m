Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121BB5C613;
	Thu, 30 Jul 2026 14:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422441; cv=none; b=UKq4GRMzIQu7C7Xiwrn7/nr3ObNFHGMF7xc9V/9LRoGoA/S4/8GJzSbCZTk7hHWL3Dw/4KM/eYhBCzPPRgnWuiOI/MA/SnU8wK7kYfPUYcdpKZs2D0cmYUKICbSBUy0w3C6Zxvjp579+5BOhvS0S5EeespvpiQyLf660CzThIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422441; c=relaxed/simple;
	bh=xnBj2dR8UOG3TThokUpCoYzn+UK9QxmVnG+pV4b2TLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St8PxhZURsctHGvlOufiUb+l3w/hUN4TXaFvWDb6DLQQwT+/HyvFDGaqSeq5/IDEcMQLS4jSlFLbAr0fJdzxZ+paDjKLbOpDUYcqQTRN5lSk6cr1u+IdN7H1yma94lOpA3JIgHj3VzvJQUQcgEuEeH6/0vB/BOMalvUNcZ/HlKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzAcnwPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzAcnwPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFCE1F000E9;
	Thu, 30 Jul 2026 14:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422440;
	bh=6OQ/a0G1Ja342M1Z02IgUnf5jc+2Xcpm97zoZZR3M98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzAcnwPurCfmIJ7aTLuHuufYe9Ec1G2+wNqLB+jFHpVtCZ3QcxdgponKcv+q3aTPy
	 pG19HO8/osbaBzobfUNQZP4NgWNmt3wGr+6BOEo4jI2XqRPzrYAaxJlXTbflqjE5ii
	 O0t26NMr0oL8A+JsKOzqAwYIMumAl8xUOd8TArA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 412/744] drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size
Date: Thu, 30 Jul 2026 16:11:25 +0200
Message-ID: <20260730141453.053367877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

commit 8cd2ea7bab77b7aa087b1a6cc26d2df03c2a6ed9 upstream.

To avoid wraparound if the value is 0.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0cae35661868af207077a4306bc42c7c972947c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -198,8 +198,8 @@ static void update_mqd(struct mqd_manage
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -237,8 +237,8 @@ static void update_mqd(struct mqd_manage
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -212,8 +212,8 @@ static void update_mqd(struct mqd_manage
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -294,8 +294,8 @@ static void update_mqd(struct mqd_manage
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -209,8 +209,8 @@ static void __update_mqd(struct mqd_mana
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control |= min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1);
+	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
+		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =


