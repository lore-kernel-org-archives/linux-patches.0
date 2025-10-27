Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412C32D0E1;
	Mon, 27 Oct 2025 19:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593118; cv=none; b=TzVtqofITCuvHdwY3xsPTTsu73OUtIBgz+xC++yzVT0Ue1GRcbmzVabKz9QgWhnwtmrp2gBTjr1aUI/QEm9zD+JtGaai7D1g+PaE+rijlemEF2PD7EmoWbddJBsxsfY7LtVyOGgXqA6NaSEkxxPB9mXL8upS7QZRNkk8+8d0tVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593118; c=relaxed/simple;
	bh=Ur+KD3ZrbPO2Ptql7uQL+LzgNJkNWf4RI+RR8Pgqmpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bnt/TA26c1KMPr9mf2tZDwUYn9R+q+byVTfqtETac6hL2COD9MvsHv7fli1L+f7asuy/5Bb3OE54HSX6k8hU/reap7yESvSiZ47NIOSyvSI+qfz5HvvquLT5Zt6v2gOCSsh8iQ+4eHrb59vSzvOQbt7I+ObQhtOFPSwUi1KLyvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3WR/usQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3WR/usQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B147C4CEF1;
	Mon, 27 Oct 2025 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593117;
	bh=Ur+KD3ZrbPO2Ptql7uQL+LzgNJkNWf4RI+RR8Pgqmpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3WR/usQC3YURYGliOMxikU7pWdI4SMQvfcMmR+x9xdtIIVFIhOeqstjcH1obK0oi
	 h1S3dVtccqxI7EdOkngMJCbgluUtTkC9JRMzhH+0czlxe6gZeLTAw6NnuOlfl+ZPrQ
	 kq5vSoR5eFRuAKaQZYjeqvI+n1JV7CzYgukwFYLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.17 002/184] vfio/cdx: update driver to build without CONFIG_GENERIC_MSI_IRQ
Date: Mon, 27 Oct 2025 19:34:44 +0100
Message-ID: <20251027183515.006177240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nipun Gupta <nipun.gupta@amd.com>

commit 9f3acb3d9a1872e2fa36af068ca2e93a8a864089 upstream.

Define dummy MSI related APIs in VFIO CDX driver to build the
driver without enabling CONFIG_GENERIC_MSI_IRQ flag.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508070308.opy5dIFX-lkp@intel.com/
Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://lore.kernel.org/r/20250826043852.2206008-2-nipun.gupta@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/cdx/Makefile  |    6 +++++-
 drivers/vfio/cdx/private.h |   14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/vfio/cdx/Makefile
+++ b/drivers/vfio/cdx/Makefile
@@ -5,4 +5,8 @@
 
 obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
 
-vfio-cdx-objs := main.o intr.o
+vfio-cdx-objs := main.o
+
+ifdef CONFIG_GENERIC_MSI_IRQ
+vfio-cdx-objs += intr.o
+endif
--- a/drivers/vfio/cdx/private.h
+++ b/drivers/vfio/cdx/private.h
@@ -38,11 +38,25 @@ struct vfio_cdx_device {
 	u8			config_msi;
 };
 
+#ifdef CONFIG_GENERIC_MSI_IRQ
 int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
 			    u32 flags, unsigned int index,
 			    unsigned int start, unsigned int count,
 			    void *data);
 
 void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
+#else
+static int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
+				   u32 flags, unsigned int index,
+				   unsigned int start, unsigned int count,
+				   void *data)
+{
+	return -EINVAL;
+}
+
+static void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
+{
+}
+#endif
 
 #endif /* VFIO_CDX_PRIVATE_H */


