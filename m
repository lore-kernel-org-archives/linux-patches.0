Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585768;
	b=Wnzg7L2oyaC6NAGqvt7MAuOmss980zFiGhA2WH1I+QEXwJpr/uEYS+pEhwFhCRFf1Byi
	 w7WopQpPQqUkDNLz/EKO0Nti5cy05JOsbSx2wuo6R40ToJZphEmAd9RvDTxZ/+ljVjkFF
	 HaBpsafawkbE/j05+8Qods9R1/MV7xj06JNul8vzmvgkaTRf/a6WgdGT3N9RlRN+wbnTk
	 CDbNKZQRWB3sBCCrMu5OhJvX8k0IH+DudrM4xZQAl8uars8CFoor35VDNxgqLMl5/O9LK
	 BX8Kl2eRJQ0w74f93vUYXiVJ6mOz4ZqkL6ZdBLGm50m/y4Fa6FWcphvTlihuzkPjxOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=197yTnPRsaaW0269lsh51DyY2+64W2HDSpxzJZY6gFw=;
	b=dT/pZF2JgCcdekkfminPglXB/p77xcp/YvhUb18NOf7hJFSJ6yCFE7gkiMDzOUqu6Tmc
	 ahBUbZRGK0xShJ2TUepYqOaVOtPb1e8146a+2fdeNf8JKkJcEOlcvedUz8VFByA32g4AA
	 d6qJSmQ1Me15Zuvsz4bbMyDiGJSzGrgtt/IKUn2HHYS7mooSTMXe0tpbI6BT/X6t+ol2e
	 bEk/zQrZ4nO8f1Q4IB6/a59e5vxhSO+h+EsJ5HyiZyVSqMA5aKQ2Lf7t3zM2ho+qtAMSZ
	 jUj63kvknOHvXtMUIfW43kU5B75P7jU34V/GYt0uwodPv4H15AyuHhYOQRWO66hIT/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXehgM4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2EF606D451;
	Fri, 13 Nov 2026 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXehgM4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8966C1F000C4;
	Fri, 13 Nov 2026 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585768;
	bh=197yTnPRsaaW0269lsh51DyY2+64W2HDSpxzJZY6gFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXehgM4jpu5DEDA4uTaMkHB7+hAOgiAQ6zgfVr/wzse+V7cbuE0KBZPinsEUMkJHf
	 nEq8yDi/f5CZa/Vp1Pbtj/r8Wqwbn158H/in3Gb/Sg/k45iaePXgiM/Kfk9C4gB/kI
	 uIqre/q9yVypTzb2AMFRH3DHInT2qScY5xF+0b8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 360/507] drm/amdgpu: Ensure that harvest information gets set
Date: Fri, 13 Nov 2026 10:51:04 -0500
Message-ID: <20261113153808.107911302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Russell <kent.russell@amd.com>

[ Upstream commit 4c5ec969b9b011e824f1850d7ffe4fa5c41ba890 ]

After the earlier patch exported IP discovery on probe failure, there was
an unexpected consequence where harvest info was not populated. The
early-exit in amdgpu_discovery_sysfs_init meant that we never called
amdgpu_discovery_get_harvest_info, which is where we set the actual
harvest value. The first time we call amdgpu_discovery_sysfs_recurse
with NULL instead of adev, most values can get set. The 2nd time
amdgpu_discovery_sysfs_recurse is called, we bail early.

To keep the logic of the first patch intact, ensuring that older kernels
can still discover the IP blocks, add a separate call in the early-exit
section that sets the harvest information.

This should be the only functionality that is missed in this flow, as the
rest of the calls either work fine with adev=NULL, or use the discovery_bin
directly.

Fixes: 402e04f11ff7 ("drm/amdgpu: Export ip_discovery sysfs on probe failure")
Assisted-by: LLM Claude
Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ca0812a625d112df556e37550e6accceea33e485)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 44 +++++++++++++++++--
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 7ab2ad2c5ba99..6d9a3e3b35468 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1402,6 +1402,40 @@ static int amdgpu_discovery_sysfs_recurse(struct amdgpu_device *adev,
 	return 0;
 }
 
+#define list_to_kobj(el) container_of(el, struct kobject, entry)
+
+static void amdgpu_discovery_sysfs_update_harvest(struct amdgpu_device *adev)
+{
+	struct ip_discovery_top *ip_top = adev->discovery.ip_top;
+	struct ip_die_entry *ip_die_entry;
+	struct list_head *el_die, *el_hw_id, *el_hw_inst;
+	struct ip_hw_id *hw_id;
+	struct kset *die_kset;
+	struct ip_hw_instance *ip_inst;
+
+	if (!ip_top)
+		return;
+
+	die_kset = &ip_top->die_kset;
+
+	guard(spinlock)(&die_kset->list_lock);
+	list_for_each(el_die, &die_kset->list) {
+		ip_die_entry = to_ip_die_entry(list_to_kobj(el_die));
+
+		list_for_each(el_hw_id, &ip_die_entry->ip_kset.list) {
+			hw_id = to_ip_hw_id(list_to_kobj(el_hw_id));
+
+			list_for_each(el_hw_inst, &hw_id->hw_id_kset.list) {
+				ip_inst = to_ip_hw_instance(list_to_kobj(el_hw_inst));
+				ip_inst->harvest =
+					amdgpu_discovery_get_harvest_info(
+						adev, ip_inst->hw_id,
+						ip_inst->num_instance);
+			}
+		}
+	}
+}
+
 static int amdgpu_discovery_sysfs_init(struct amdgpu_device *adev)
 {
 	uint8_t *discovery_bin = adev->discovery.bin;
@@ -1412,9 +1446,13 @@ static int amdgpu_discovery_sysfs_init(struct amdgpu_device *adev)
 	if (!discovery_bin)
 		return -EINVAL;
 
-	/* If early init already created sysfs in standalone mode, skip normal init */
-	if (adev->discovery.ip_top && adev->discovery.ip_top->standalone_mode)
+	/* If early init already created sysfs in standalone mode, update harvest info
+	 * now that adev is fully initialized, then skip the rest of normal init.
+	 */
+	if (adev->discovery.ip_top && adev->discovery.ip_top->standalone_mode) {
+		amdgpu_discovery_sysfs_update_harvest(adev);
 		return 0;
+	}
 
 	ip_top = kzalloc_obj(*ip_top);
 	if (!ip_top)
@@ -1469,8 +1507,6 @@ static int amdgpu_discovery_sysfs_init(struct amdgpu_device *adev)
 
 /* -------------------------------------------------- */
 
-#define list_to_kobj(el) container_of(el, struct kobject, entry)
-
 static void amdgpu_discovery_sysfs_ip_hw_free(struct ip_hw_id *ip_hw_id)
 {
 	struct list_head *el, *tmp;
-- 
2.53.0



