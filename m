Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DFB83CC8;
	Mon, 15 Apr 2024 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191365; cv=none; b=OoLJ6z6pqzs66X58cPoxAPmTKhAXC9YzNaxNuI0COpi12fgek2b0F8ooJQ8fOA4DmQxywb4xHodgKfLT2JiFPNi26nRHDbzKPOSNSXQhqvlUeQL9jpWWxcRjtXEWSaB855co+91Dmt8mEd3CNb/HNk+u0z28nEVZ1Umj212bDJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191365; c=relaxed/simple;
	bh=2X1IcXgWpxWfIuNAV23iwtE1RCKtm9c+pwhoYfYP7dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4dJXIdsOfuLHk7VsOOHhc1Dao7DltH00Y2x1vtGohfA/OiS5eESs6AIfOISbiNuVCHjpJTKbib6r3CpUTNeWN7WxPYWNKL96Tryf17I+2dSFLtR3zWfSMVAh6jm5rkld/fFRjzHLa7Ew2zMsKkeEVGJy1omGq572HfyeueJ1L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH2+MZws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH2+MZws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206A2C113CC;
	Mon, 15 Apr 2024 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191365;
	bh=2X1IcXgWpxWfIuNAV23iwtE1RCKtm9c+pwhoYfYP7dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QH2+MZwsaBNLEAh2UaDGNlsaJSXqDWExXXbOFPAvV+0jYEec+h1H+a2CqMzi7BbTd
	 WYjSNuE5feejk+/pthKBhAzrqfPnLTU7YVFtLDCicMuvo030i6Vgm+G+xzKpPOxwo3
	 1htXHDoXzrFrFNWulaD0Gyc4aOzhzxM3oq9cDhgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wachowski, Karol" <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Wachowski
Subject: [PATCH 6.8 118/172] accel/ivpu: Check return code of ipc->lock init
Date: Mon, 15 Apr 2024 16:20:17 +0200
Message-ID: <20240415142003.972789833@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wachowski, Karol <karol.wachowski@intel.com>

commit f0cf7ffcd02953c72fed5995378805883d16203e upstream.

Return value of drmm_mutex_init(ipc->lock) was unchecked.

Fixes: 5d7422cfb498 ("accel/ivpu: Add IPC driver and JSM messages")
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Wachowski, Karol <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-2-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_ipc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include <linux/genalloc.h>
@@ -501,7 +501,11 @@ int ivpu_ipc_init(struct ivpu_device *vd
 	spin_lock_init(&ipc->cons_lock);
 	INIT_LIST_HEAD(&ipc->cons_list);
 	INIT_LIST_HEAD(&ipc->cb_msg_list);
-	drmm_mutex_init(&vdev->drm, &ipc->lock);
+	ret = drmm_mutex_init(&vdev->drm, &ipc->lock);
+	if (ret) {
+		ivpu_err(vdev, "Failed to initialize ipc->lock, ret %d\n", ret);
+		goto err_free_rx;
+	}
 	ivpu_ipc_reset(vdev);
 	return 0;
 


