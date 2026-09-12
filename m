Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF802332610;
	Sat, 12 Sep 2026 07:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198669; cv=none; b=cMSURNc+rtABwLXptrMYZf8eTc8nDdU0vmDA0Ck0XeYkeooA6maBh2xNzSIjF1z8hMVEb0jtEYtmW3VRCpXbctFTcoJzf6VmbMaNXewJ0AkRPbg/8S/YB60Nx+U/FbFhNT1v9/xsQtFeItFNUvmHlBa+JrVebsWlJv+XzKBqVwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198669; c=relaxed/simple;
	bh=w95dsElzTXFltFVF1DBmqlYOenbS/+TA1vfE6raXXlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oizFRwPXp4b0cgzQrhh8ZXmwGD7EjtUFF1HPCwchvnyQD4yfEkzUPh/qpsYW1Y9L2RN3X0UmMMbxQeBdRyy8+drH1+agcgsxff/0xanp8e0Q9QULY5shiFfZ6ieQomsWtMgQ4aMvgsK3+3HSRhc2xwxTqWdXxO8aVitgK10Qai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXhV2LE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXhV2LE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837B1F000FF;
	Sat, 12 Sep 2026 07:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198667;
	bh=O6FFSDkxQnCAbCpCde0RksuKJ2EzCAv2KuXq35WIBk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXhV2LE5AUuEaH9XVtIF+7vNqHan1J+4eayMJmidLmkEKSqjt4bKq2hKdSmjd3I6C
	 PSvy/Csjdr4KKqxfj69sDib2+xiGEy8Nl0T/cjzNydqDx246ebcm0ZCKWNOSA8u8ZR
	 4183IIlKAvESnO1X6rTRNc1Z+oXwaiTwfQqMGhBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0428/1815] media: ti: vpe: Select V4L2_FWNODE for VIP
Date: Sat, 12 Sep 2026 08:36:18 +0200
Message-ID: <20260912065658.943632699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

[ Upstream commit 46f563185b23443894c4d6aa86942851bda6f5dc ]

The VIP driver uses v4l2_fwnode_endpoint_parse() and the
v4l2_async_nf_*() notifier APIs, but its Kconfig entry does not
select V4L2_FWNODE. Hence kernel test robot reports:

  vip.c:3236: undefined reference to `v4l2_async_nf_unregister'
  vip.c:3237: undefined reference to `v4l2_async_nf_cleanup'
  vip.c:3339: undefined reference to `v4l2_fwnode_endpoint_parse'
  vip.c:3346: undefined reference to `v4l2_async_nf_init'
  vip.c:3348: undefined reference to `__v4l2_async_nf_add_fwnode'
  vip.c:3357: undefined reference to `v4l2_async_nf_register'

Select V4L2_FWNODE, which in turn selects V4L2_ASYNC, providing
all the missing symbols.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607031826.vOPABT39-lkp@intel.com/
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti/Kconfig b/drivers/media/platform/ti/Kconfig
index d0cb05481bd85..1a020b2bbb4f2 100644
--- a/drivers/media/platform/ti/Kconfig
+++ b/drivers/media/platform/ti/Kconfig
@@ -50,6 +50,7 @@ config VIDEO_TI_VIP
         select VIDEO_TI_VPDMA
         select VIDEO_TI_SC
         select VIDEO_TI_CSC
+        select V4L2_FWNODE
         help
         Driver support for VIP module on certain TI SoC's
         VIP = Video Input Port.
-- 
2.53.0



