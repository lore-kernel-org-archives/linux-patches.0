Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B52CA9;
	Tue, 12 Aug 2025 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024495; cv=none; b=Vl1d/Xb8awe1IB8ZVnIh2MvdBfoTOFHof44PPcIVJm3l9bh7F1eArJONAxaoa7ZD25APsou4aqAC4lE2mllYyx/Gd9p3Xz9rL6kZu/ibFfYa/Ajs0O7P57LDGLuP4x6TNQd3mTL71VQwSKHFipk4fgZyqvQCfyYuv+i38T/3CB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024495; c=relaxed/simple;
	bh=Kf2z03Z3wezYVNv4Ki32CZ5jPlO3YZoDe17to4dCZZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqML/1x148RTIBnHVRB5lgAqr91Z0Q4Qlygjw065UhA8vs3Q06MkmgfPfw7nrZZMNVkn90BNH55Pa8Gx+vWlw76kXEpW5xGC+H19H47FOoxQgl5S9/FPm2PoaJHFPi8heZHY38X+KJSaBsm0Ofb9qSJBE0keooIkoiX3vlOqMYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiicpHvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiicpHvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3183EC4CEF0;
	Tue, 12 Aug 2025 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024495;
	bh=Kf2z03Z3wezYVNv4Ki32CZ5jPlO3YZoDe17to4dCZZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiicpHvrJhZoxMlocao/y9D9GpVy3wzmIdFawIiEN9J4NOHesU3H4Is4BeeDtPGiO
	 nSwr2drfYotfw38C/F+AyvSY9klgjVxWPmxPV8EGBvIGj38kS+R80d8e42kt4wbGOS
	 mSo5PpkqCejLeGZFqn4k+X4vxDs/BvqH10lPwd7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 391/627] scsi: core: Fix kernel doc for scsi_track_queue_full()
Date: Tue, 12 Aug 2025 19:31:26 +0200
Message-ID: <20250812173434.173486815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 6070bd558aee1eb5114e1676165bf0ccaa08240a ]

Sphinx reports indentation warning on scsi_track_queue_full() return
values:

Documentation/driver-api/scsi:101: ./drivers/scsi/scsi.c:247: ERROR: Unexpected indentation. [docutils]

Fix the warning by making the return values listing a bullet list.

Fixes: eb44820c28bc ("[SCSI] Add Documentation and integrate into docbook build")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20250702035822.18072-2-bagasdotme@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 518a252eb6aa..c2527dd289d9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -242,9 +242,11 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
- * 		-1 - Drop back to untagged operation using host->cmd_per_lun
- * 			as the untagged command depth
+ * Returns:
+ * * 0 - No change needed
+ * * >0 - Adjust queue depth to this new depth,
+ * * -1 - Drop back to untagged operation using host->cmd_per_lun as the
+ *   untagged command depth
  *
  * Lock Status:	None held on entry
  *
-- 
2.39.5



