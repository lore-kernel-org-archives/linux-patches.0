Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA0242D7F;
	Wed, 28 Jan 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615875; cv=none; b=q8EA5Ep0qjdFnzCEZmoc1et9UakVfE08O9jpPKDRYCCHeVMhBIxN5/iMPWoQKvTqzj0GcBmh9RbTAW+OfxDCqW5pe9mbuuI52mTAOkJPCuq2VmARk4hBkxrcmmn6DXq+sle+hR9eLZj10WmO3DOQuBds6vx32QCGrjwfZm/z7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615875; c=relaxed/simple;
	bh=oau5qT/aNIX29ByH0wN8C8CD9aR7n6llJHjpBcu7sr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdA4hfbDfAxmF1kJ2yQQX383eFYdidQ/jJAmDauHp3yc5xeh1ilepmJg7TaFpvuQ1lpbMQ7ivTFWlw6VhGrv1mjGQ3d2i4phKUpP5A8XCX0mzLTOxR9ozcu4Qfis568FkCApAyEHAiBMAbAw7AhcHt9m8WgVsky0TSOEmaWjrpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zbdbqy8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zbdbqy8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40996C4CEF1;
	Wed, 28 Jan 2026 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615874;
	bh=oau5qT/aNIX29ByH0wN8C8CD9aR7n6llJHjpBcu7sr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zbdbqy8sg+jeq33VI0gXKlr5/F+lr8SLtLA48/dP1i6knSQ2xMwvWwyShbsg29YV2
	 NTH0ahh1F+AsAV5q570+DojSJ7RaZ4P8EJ0taObs+GNnFj60bM13VnerIi+wwXfbZ8
	 g3bdJn3sH19obxbvJUQK1JyhCQclSJ04S+33sBXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/227] drm/xe/xe_late_bind_fw: fix enum xe_late_bind_fw_id kernel-doc
Date: Wed, 28 Jan 2026 16:22:22 +0100
Message-ID: <20260128145347.822316166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit dc1d0ffee09740088eb190af84a2c470d279bad9 ]

Fix kernel-doc warnings on enum xe_late_bind_fw_id:

Warning: ../drivers/gpu/drm/xe/xe_late_bind_fw_types.h:19 cannot
  understand function prototype: 'enum xe_late_bind_fw_id'

Fixes: 45832bf9c10f ("drm/xe/xe_late_bind_fw: Initialize late binding firmware")
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Link: https://patch.msgid.link/20260107155401.2379127-3-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a857e6102970c7bd8f2db967fe02d76741179d14)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_late_bind_fw_types.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_late_bind_fw_types.h b/drivers/gpu/drm/xe/xe_late_bind_fw_types.h
index 0f5da89ce98b8..2a8a985c37e71 100644
--- a/drivers/gpu/drm/xe/xe_late_bind_fw_types.h
+++ b/drivers/gpu/drm/xe/xe_late_bind_fw_types.h
@@ -15,10 +15,12 @@
 #define XE_LB_MAX_PAYLOAD_SIZE SZ_4K
 
 /**
- * xe_late_bind_fw_id - enum to determine late binding fw index
+ * enum xe_late_bind_fw_id - enum to determine late binding fw index
  */
 enum xe_late_bind_fw_id {
+	/** @XE_LB_FW_FAN_CONTROL: Fan control */
 	XE_LB_FW_FAN_CONTROL = 0,
+	/** @XE_LB_FW_MAX_ID: Number of IDs */
 	XE_LB_FW_MAX_ID
 };
 
-- 
2.51.0



