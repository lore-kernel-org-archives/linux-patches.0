Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C32B186E5E;
	Mon, 12 Aug 2024 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480300; cv=none; b=KU7637bxFpvLUtIYGoI98+f9eJfPpG/EQkaHtjRVsteR3hJ5wbHgqkbs1zYbWjAbMV45k4yUzT472YOlRH3ojPirLXC9Hqt4Jy38dkgHtOF9lIpMG7/1om/XXKdY5vZ5CEyzsAyV4vZjUfdPBCss8i+uOD32yZ000fmr5o3GQ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480300; c=relaxed/simple;
	bh=fRzxIjokeArFm9j738+96ASEoZSQx4iWDetxiOM2hMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1iYexBX1h9lazoMNbDrQHwRC5vx/41mpjCPXzpOCc7FoCoogXTp8nbt4tngQnSpec218WJf3V+8EfDUxRVZjYGAH6agLTJOlnnvP0dGkmCZ4h2FH91FhpiuwLSiKRVq11UKmgc6wOTr6nwVxFkAgnZSfzaMpxlWkWJCzV9hI4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWJZvqCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWJZvqCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C7BC32782;
	Mon, 12 Aug 2024 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480300;
	bh=fRzxIjokeArFm9j738+96ASEoZSQx4iWDetxiOM2hMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWJZvqCkbkSkpIxhXCkdPuKtfTM5RcbOeJcoZoR7a5C9jbGTJg4JlrhWYh5DEi18A
	 KEmhS15zt8IeYG149IZr3SUypqyBRIjwzFIeoL5hidi0yfnIIlBJFuWvqzMxLz4vlT
	 f3On0BM+lwts1DBdTmaKaPLky7kup2aYIPPc5Ld4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 124/263] media: intel/ipu6: select AUXILIARY_BUS in Kconfig
Date: Mon, 12 Aug 2024 18:02:05 +0200
Message-ID: <20240812160151.295881621@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 423a77ae3a3f916809ff3ab1c8db6d3d580c3120 upstream.

Intel IPU6 PCI driver need register its devices on auxiliary
bus, so it needs to select the AUXILIARY_BUS in Kconfig.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407161833.7BEFXejx-lkp@intel.com/
Fixes: c70281cc83d6 ("media: intel/ipu6: add Kconfig and Makefile")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Cc: stable@vger.kernel.org # for v6.10
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/intel/ipu6/Kconfig b/drivers/media/pci/intel/ipu6/Kconfig
index b7ab24b89836..40e20f0aa5ae 100644
--- a/drivers/media/pci/intel/ipu6/Kconfig
+++ b/drivers/media/pci/intel/ipu6/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_INTEL_IPU6
 	depends on VIDEO_DEV
 	depends on X86 && X86_64 && HAS_DMA
 	depends on IPU_BRIDGE || !IPU_BRIDGE
+	select AUXILIARY_BUS
 	select DMA_OPS
 	select IOMMU_IOVA
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.46.0



