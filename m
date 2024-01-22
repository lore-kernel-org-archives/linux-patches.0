Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A44F5E9;
	Tue, 23 Jan 2024 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969895; cv=none; b=EwX7Y2nB3mWVg6hxS5f4lElGE2PmKA8tKP83PrPm3Dgd2Qu/uBGMSJiCrobNZmUhUQBYDgRsQtlQie9ZptX21UtL8LIf/IwtGXpe7lS6dt0B+OTH90FjaSwvELJkGU0jM/albuxrFIRuPw98rvb8wTFki9TwnDMytKBDJYMh9JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969895; c=relaxed/simple;
	bh=cFv3EbDLwiDbWZyZNj+KtnvO7wAIcFgT49xdwhJC8Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQewU/0WzavUEekjkmAE4/Mdld4p7tvF9YnfmhEBJVWoce7gBI/S4VQcS7l27HDWpaq1Wfijk+446eFjeWDXNTqSyFdz6iE/aAN+u89NbrWosCTpEoSIZDEq6pXk/Uk8+gZGRaxklK6xkExdFr+W6JCXMrSIk3dBXX1f1QwJjMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yW3w31Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yW3w31Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B455C433F1;
	Tue, 23 Jan 2024 00:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969894;
	bh=cFv3EbDLwiDbWZyZNj+KtnvO7wAIcFgT49xdwhJC8Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW3w31Ei79pZJXnPNi36MPPN8SQ5DIqM/Z0/43h5LE4BWuKkZngbLCIv29p24A680
	 Fm/3ac0enPEmkppfgFZm9GnspZ2ohJBH5tc8StasiEjZz8Dp8PuAtHVZpexJlA3n8o
	 phBkdpTvq+WlAmbuRsYDGIPoZoVrTX0FUdjZlzoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 511/641] staging: vc04_services: Do not pass NULL to vchiq_log_error()
Date: Mon, 22 Jan 2024 15:56:55 -0800
Message-ID: <20240122235834.075595925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit 149261d378d0ca441b16de6c1a250a350df66598 ]

vchiq_add_connected_callback() logs using vchiq_log_error() macro,
but passes NULL instead of a struct device pointer. Fix it.

vchiq_add_connected_callback() is not used anywhere in the vc04_services
as of now. It will be used when we add new drivers(VC shared memory and
bcm2835-isp), hence it kept as it is for now.

Fixes: 1d8915cf8899 ("staging: vc04: Convert vchiq_log_error() to use dynamic debug")
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Link: https://lore.kernel.org/r/20231128201926.489269-2-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vc04_services/interface/vchiq_arm/vchiq_connected.c       | 4 ++--
 .../vc04_services/interface/vchiq_arm/vchiq_connected.h       | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.c
index b3928bd8c9c6..21f9fa1a1713 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.c
@@ -27,7 +27,7 @@ static void connected_init(void)
  * be made immediately, otherwise it will be deferred until
  * vchiq_call_connected_callbacks is called.
  */
-void vchiq_add_connected_callback(void (*callback)(void))
+void vchiq_add_connected_callback(struct vchiq_device *device, void (*callback)(void))
 {
 	connected_init();
 
@@ -39,7 +39,7 @@ void vchiq_add_connected_callback(void (*callback)(void))
 		callback();
 	} else {
 		if (g_num_deferred_callbacks >= MAX_CALLBACKS) {
-			vchiq_log_error(NULL, VCHIQ_CORE,
+			vchiq_log_error(&device->dev, VCHIQ_CORE,
 					"There already %d callback registered - please increase MAX_CALLBACKS",
 					g_num_deferred_callbacks);
 		} else {
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.h b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.h
index 4caf5e30099d..e4ed56446f8a 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.h
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_connected.h
@@ -1,10 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /* Copyright (c) 2010-2012 Broadcom. All rights reserved. */
 
+#include "vchiq_bus.h"
+
 #ifndef VCHIQ_CONNECTED_H
 #define VCHIQ_CONNECTED_H
 
-void vchiq_add_connected_callback(void (*callback)(void));
+void vchiq_add_connected_callback(struct vchiq_device *device, void (*callback)(void));
 void vchiq_call_connected_callbacks(void);
 
 #endif /* VCHIQ_CONNECTED_H */
-- 
2.43.0



