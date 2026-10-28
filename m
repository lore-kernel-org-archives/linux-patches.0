Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216817;
	b=itBMwHh0osB9LooYxQTGFt9zRGsYuv+FwOMFkxS9ohGsuhR/iwSnc+ZtZzKhLRpU6iMG
	 915xQW/600nHDWNRY5IVxLMoJs70Hy5qYVYmnYQQYc8IBkXMfXdiC426olprJhSM6FPR4
	 Jx29VhCpE0fxFD5fEOQBIcHbEvqh5pC17loR3C4JwdcxdkOOhu0FrOFkSX2fJFcGXpOXE
	 wEQxYJaiaW3ph1cJX2zRBAwwXZo4CWQdePNrajn4tWYUHYMxag04RzFsObMBadVm5omxW
	 g0EDw7kabeqkq/I1gW5E8xcdUIox0znDOCTjYicEyQ2xCC7FhTJWM+nvyN+43n5vz+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuZdUQPQLmvPq3Mhve2N8Kf1MDpdNs+GYTKmDJCH/dE=;
	b=NLIwl//DkhXNSLsbfNSRLqtpmOBX56WvwWlLnjuxaG5mZAp/T+3XpPXtz8Gpoa7hGCgv
	 icOiJuTHfhdkb9MAiKgeoj59ASO4iZLQzARg06zwBGJ4tehV9yl9uWU4HukrTI54HQ9gu
	 Dr7xjvwNf+injUz9zB4RvjVt78oAbTYj0Fz0INlV+8ljYm6qPri+OvPTTp7iWhBW2sKW9
	 AgWTa1fKsserq0DlkR1kpd78QciuosdiWn4Hv2sLnW3xqDLrkx0LoFgx+KdUc+zofo3FX
	 uKFqhdBmqi9LC5df3S1Tn+QGH7MEWyma3eSiKit5di/c0gMQwvGviMb7w+JnmDnDH0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trR7iT5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055F6606A31A;
	Wed, 28 Oct 2026 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trR7iT5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B021F01825;
	Wed, 28 Oct 2026 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216816;
	bh=iuZdUQPQLmvPq3Mhve2N8Kf1MDpdNs+GYTKmDJCH/dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trR7iT5OJ1fDAq5A/VfxHfFRIL1vL9ueIXVKfekJChTezd4dTNJRIZuCkujv2iq8f
	 nPPA2mWXjk/LUqN1VScSAXPhT/R2IMVppm+GQhlZpnzXEMO2E+d+72ZmCH0wbHxH+N
	 bm9zyscjHiaXhF4V3lvXcWcCy8iXmIzx+LvXbTqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1687/1887] scsi: qla2xxx: Skip vport under deletion in report ID acquisition
Date: Wed, 28 Oct 2026 18:03:03 +0100
Message-ID: <20261028170537.846492482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 23582731afa35031c94fadb71a4f3b4afd094649 ]

qla24xx_report_id_acquisition() format-1 handling walks ha->vp_list under
vport_slock, takes a vref_count on the matching vport and calls
qla_update_host_map() to register its port id.

A vport teardown via qla24xx_vport_delete() sets VPORT_DELETE, then
qla24xx_disable_vp() removes the vport from the host_map btree and zeroes
vha->d_id (RESET_AL_PA). The vport is only unlinked from vp_list later,
in qla24xx_deallocate_vp_id(), which clears vp_map[idx] (RESET_VP_IDX)
but does not touch host_map. In the window in between, report ID
acquisition can still find the vport on vp_list and call
qla_update_host_map(); with d_id already zeroed it takes the
btree_insert32() path and re-inserts the dying vport into host_map.
Nothing cleans that entry afterwards, so once scsi_host_put() frees the
vha a later host_map lookup dereferences freed memory.

Skip a vport that has VPORT_DELETE set before taking the reference, so it
is neither re-registered nor scheduled for DPC re-registration. This
mirrors the existing guard in qla2x00_alert_all_vps().

Fixes: 41dc529a4602 ("qla2xxx: Improve RSCN handling in driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-22-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 583585783893c..828c424abb3dd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4147,6 +4147,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (rptid_entry->vp_idx == vp->vp_idx) {
+					if (test_bit(VPORT_DELETE, &vp->dpc_flags))
+						break;
 					found = 1;
 					atomic_inc(&vp->vref_count);
 					break;
-- 
2.53.0



