Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA96D1A9;
	Mon,  8 Apr 2024 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582985; cv=none; b=lV4YPmvNdH26yMD0PPgHhpm7e7gEfrlSGP8Bf1VXS8YgEotCYQYMBCC8/GMG/61w47RMK6futhYQoZWIssn31aRXCG/wqcuo9jNOKrFy4wBRugBYl8b4gdXfHrPcGp4TydZhgdLlWAOmqAYvhx3xIi9q+TOBHK5q11jWe5RMZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582985; c=relaxed/simple;
	bh=Pcj9/mJfk3+IC/53sbw1VlMQfN4nEWIj9+bmFViZLlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+SZcfTfr3stF1RPmnjIA9lsriL5PH0P/uTr2UJkMYhDBc3dOAwcdv1oysn85AZAJbl/Wc6LGfMy2DDn4TbG2E91MI516QlUvO1Qvokp9Akm4xEL+AMX0JJbZ6UoXyzCzAl4Htp4VZPLVUSsRK5SxbGohfjIt2PT1jhOkb1b9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTXNQCXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTXNQCXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA02DC43390;
	Mon,  8 Apr 2024 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582985;
	bh=Pcj9/mJfk3+IC/53sbw1VlMQfN4nEWIj9+bmFViZLlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTXNQCXGtqrnKkMxVvGPZ7WUVF6WhlC+6vE2M54jqrVr9l2qhmofF6MgSLx7IcH35
	 Slcd+xCwm9b+l/YSPEEVOcpwYapl+lPA1vGe3C8C4G6V9cv7PxdHWYoj0+6bP5Buce
	 DcxuPF7UqNrOSAZHWXaj0fGyzqOfjIYRoI4/+PLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 145/252] i40e: Move memory allocation structures to i40e_alloc.h
Date: Mon,  8 Apr 2024 14:57:24 +0200
Message-ID: <20240408125311.153218764@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit ef5d54078d451973f90e123fafa23fc95c2a08ae ]

Structures i40e_dma_mem & i40e_virt_mem are defined i40e_osdep.h while
memory allocation functions that use them are declared in i40e_alloc.h
Move them there.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_alloc.h  | 14 ++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 12 ------------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.h b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
index 267f2e0a21ce8..1c3d2bc5c3f79 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
@@ -4,6 +4,7 @@
 #ifndef _I40E_ADMINQ_H_
 #define _I40E_ADMINQ_H_
 
+#include "i40e_alloc.h"
 #include "i40e_osdep.h"
 #include "i40e_adminq_cmd.h"
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_alloc.h b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
index 4b2d8da048c64..e0dde326255d6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
@@ -4,8 +4,22 @@
 #ifndef _I40E_ALLOC_H_
 #define _I40E_ALLOC_H_
 
+#include <linux/types.h>
+
 struct i40e_hw;
 
+/* memory allocation tracking */
+struct i40e_dma_mem {
+	void *va;
+	dma_addr_t pa;
+	u32 size;
+};
+
+struct i40e_virt_mem {
+	void *va;
+	u32 size;
+};
+
 /* prototype for functions used for dynamic memory allocation */
 int i40e_allocate_dma_mem(struct i40e_hw *hw,
 			  struct i40e_dma_mem *mem,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index 70cac3bb31ec3..fd18895cfb56b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -29,18 +29,6 @@ struct device *i40e_hw_to_dev(struct i40e_hw *hw);
 #define rd64(a, reg)		readq((a)->hw_addr + (reg))
 #define i40e_flush(a)		readl((a)->hw_addr + I40E_GLGEN_STAT)
 
-/* memory allocation tracking */
-struct i40e_dma_mem {
-	void *va;
-	dma_addr_t pa;
-	u32 size;
-};
-
-struct i40e_virt_mem {
-	void *va;
-	u32 size;
-};
-
 #define i40e_debug(h, m, s, ...)				\
 do {								\
 	if (((m) & (h)->debug_mask))				\
-- 
2.43.0



