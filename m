Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5962B330B2B;
	Fri, 17 Oct 2025 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716658; cv=none; b=C/0hWmVEhA+4LCrsOUc8129HNehujTgcpBLUUgPuilZS9ORq5MJNUSuwm/PwOFsXTpHbL343zb7j+4hF4G6HQh7NvbdiUnKsL7k2XKyVytfDKVSoTh/75psOYN8X4D+4hyDvRuMI+RLmr2CDRY3r83E3kBTbJZcKT7+2JIJZw2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716658; c=relaxed/simple;
	bh=qYFQM8I9FlncEhkurtsNGyAZy/cmg5EUyUO4XTtQWW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0C4MeiksxSpEKlGtrt+1+NJfuCLgTu3yuR0c5DAM/bguHKpEN8Rg3j2ALlFrJP3fVdIOu1MnVR3u7L9owV7EQ6IWlpNmEqlWC4Z25q5juxamu2tRPkfCieQZkALnrN82JtnLJtZ/Wk5MyeReL5biU8wBCWwF4LL0AJh2K7iPjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz8NrBrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz8NrBrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD53CC4CEE7;
	Fri, 17 Oct 2025 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716658;
	bh=qYFQM8I9FlncEhkurtsNGyAZy/cmg5EUyUO4XTtQWW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fz8NrBrEYrcRG6VrEENn5NKNw+IkidGJCSy5PHLMj9GeQ2oSgjIox17grK4yiOSby
	 gm1ML3t51gvTeFb+zqKGMMPIh83QwHmQ1BpLfukVWAxQ69baRocQ0hPRw1ubiYNg1l
	 evnOpfabZALFUFg1vUT4fCZuj94SENsT/+R26BHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/276] media: switch from pci_ to dma_ API
Date: Fri, 17 Oct 2025 16:56:00 +0200
Message-ID: <20251017145152.231536604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 887069f424550ebdcb411166733e1d05002b58e4 ]

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

It has been compile tested.

@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 23b53639a793 ("media: cx18: Add missing check after DMA map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cobalt/cobalt-driver.c           |    4 ++--
 drivers/media/pci/cx18/cx18-driver.c               |    2 +-
 drivers/media/pci/cx18/cx18-queue.c                |   13 +++++++------
 drivers/media/pci/cx18/cx18-streams.c              |   16 ++++++++--------
 drivers/media/pci/ddbridge/ddbridge-main.c         |    4 ++--
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c      |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/pluto2/pluto2.c                  |   20 ++++++++++----------
 drivers/media/pci/pt1/pt1.c                        |    2 +-
 drivers/media/pci/tw5864/tw5864-core.c             |    2 +-
 10 files changed, 34 insertions(+), 33 deletions(-)

--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -333,8 +333,8 @@ static int cobalt_setup_pci(struct cobal
 		}
 	}
 
-	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
-		ret = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(64))) {
+		ret = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 		if (ret) {
 			cobalt_err("no suitable DMA available\n");
 			goto err_disable;
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -804,7 +804,7 @@ static int cx18_setup_pci(struct cx18 *c
 		CX18_ERR("Can't enable device %d!\n", cx->instance);
 		return -EIO;
 	}
-	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		CX18_ERR("No suitable DMA available, card %d\n", cx->instance);
 		return -EIO;
 	}
--- a/drivers/media/pci/cx18/cx18-queue.c
+++ b/drivers/media/pci/cx18/cx18-queue.c
@@ -325,8 +325,8 @@ void _cx18_mdl_sync_for_device(struct cx
 	struct cx18_buffer *buf;
 
 	list_for_each_entry(buf, &mdl->buf_list, list)
-		pci_dma_sync_single_for_device(pci_dev, buf->dma_handle,
-					       buf_size, dma);
+		dma_sync_single_for_device(&pci_dev->dev, buf->dma_handle,
+					   buf_size, dma);
 }
 
 int cx18_stream_alloc(struct cx18_stream *s)
@@ -385,8 +385,9 @@ int cx18_stream_alloc(struct cx18_stream
 		cx18_enqueue(s, mdl, &s->q_idle);
 
 		INIT_LIST_HEAD(&buf->list);
-		buf->dma_handle = pci_map_single(s->cx->pci_dev,
-				buf->buf, s->buf_size, s->dma);
+		buf->dma_handle = dma_map_single(&s->cx->pci_dev->dev,
+						 buf->buf, s->buf_size,
+						 s->dma);
 		cx18_buf_sync_for_cpu(s, buf);
 		list_add_tail(&buf->list, &s->buf_pool);
 	}
@@ -419,8 +420,8 @@ void cx18_stream_free(struct cx18_stream
 		buf = list_first_entry(&s->buf_pool, struct cx18_buffer, list);
 		list_del_init(&buf->list);
 
-		pci_unmap_single(s->cx->pci_dev, buf->dma_handle,
-				s->buf_size, s->dma);
+		dma_unmap_single(&s->cx->pci_dev->dev, buf->dma_handle,
+				 s->buf_size, s->dma);
 		kfree(buf->buf);
 		kfree(buf);
 	}
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -49,44 +49,44 @@ static struct {
 	{	/* CX18_ENC_STREAM_TYPE_MPG */
 		"encoder MPEG",
 		VFL_TYPE_VIDEO, 0,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 		V4L2_CAP_AUDIO | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_TS */
 		"TS",
 		VFL_TYPE_VIDEO, -1,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 	},
 	{	/* CX18_ENC_STREAM_TYPE_YUV */
 		"encoder YUV",
 		VFL_TYPE_VIDEO, CX18_V4L2_ENC_YUV_OFFSET,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING | V4L2_CAP_AUDIO | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_VBI */
 		"encoder VBI",
 		VFL_TYPE_VBI, 0,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_PCM */
 		"encoder PCM audio",
 		VFL_TYPE_VIDEO, CX18_V4L2_ENC_PCM_OFFSET,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 		V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
 	},
 	{	/* CX18_ENC_STREAM_TYPE_IDX */
 		"encoder IDX",
 		VFL_TYPE_VIDEO, -1,
-		PCI_DMA_FROMDEVICE,
+		DMA_FROM_DEVICE,
 	},
 	{	/* CX18_ENC_STREAM_TYPE_RAD */
 		"encoder radio",
 		VFL_TYPE_RADIO, 0,
-		PCI_DMA_NONE,
+		DMA_NONE,
 		V4L2_CAP_RADIO | V4L2_CAP_TUNER
 	},
 };
@@ -324,7 +324,7 @@ static int cx18_prep_dev(struct cx18 *cx
 
 	/* User explicitly selected 0 buffers for these streams, so don't
 	   create them. */
-	if (cx18_stream_info[type].dma != PCI_DMA_NONE &&
+	if (cx18_stream_info[type].dma != DMA_NONE &&
 	    cx->stream_buffers[type] == 0) {
 		CX18_INFO("Disabled %s device\n", cx18_stream_info[type].name);
 		return 0;
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -180,8 +180,8 @@ static int ddb_probe(struct pci_dev *pde
 
 	pci_set_master(pdev);
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
+		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 
 	dev = vzalloc(sizeof(*dev));
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
@@ -1760,7 +1760,7 @@ static int cio2_pci_probe(struct pci_dev
 
 	pci_set_master(pci_dev);
 
-	r = pci_set_dma_mask(pci_dev, CIO2_DMA_MASK);
+	r = dma_set_mask(&pci_dev->dev, CIO2_DMA_MASK);
 	if (r) {
 		dev_err(dev, "failed to set DMA mask (%d)\n", r);
 		return -ENODEV;
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -846,7 +846,7 @@ static int netup_unidvb_initdev(struct p
 		"%s(): board vendor 0x%x, revision 0x%x\n",
 		__func__, board_vendor, board_revision);
 	pci_set_master(pci_dev);
-	if (pci_set_dma_mask(pci_dev, 0xffffffff) < 0) {
+	if (dma_set_mask(&pci_dev->dev, 0xffffffff) < 0) {
 		dev_err(&pci_dev->dev,
 			"%s(): 32bit PCI DMA is not supported\n", __func__);
 		goto pci_detect_err;
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -228,16 +228,16 @@ static void pluto_set_dma_addr(struct pl
 
 static int pluto_dma_map(struct pluto *pluto)
 {
-	pluto->dma_addr = pci_map_single(pluto->pdev, pluto->dma_buf,
-			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
+	pluto->dma_addr = dma_map_single(&pluto->pdev->dev, pluto->dma_buf,
+					 TS_DMA_BYTES, DMA_FROM_DEVICE);
 
-	return pci_dma_mapping_error(pluto->pdev, pluto->dma_addr);
+	return dma_mapping_error(&pluto->pdev->dev, pluto->dma_addr);
 }
 
 static void pluto_dma_unmap(struct pluto *pluto)
 {
-	pci_unmap_single(pluto->pdev, pluto->dma_addr,
-			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pluto->pdev->dev, pluto->dma_addr, TS_DMA_BYTES,
+			 DMA_FROM_DEVICE);
 }
 
 static int pluto_start_feed(struct dvb_demux_feed *f)
@@ -276,8 +276,8 @@ static void pluto_dma_end(struct pluto *
 {
 	/* synchronize the DMA transfer with the CPU
 	 * first so that we see updated contents. */
-	pci_dma_sync_single_for_cpu(pluto->pdev, pluto->dma_addr,
-			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(&pluto->pdev->dev, pluto->dma_addr,
+				TS_DMA_BYTES, DMA_FROM_DEVICE);
 
 	/* Workaround for broken hardware:
 	 * [1] On startup NBPACKETS seems to contain an uninitialized value,
@@ -310,8 +310,8 @@ static void pluto_dma_end(struct pluto *
 	pluto_set_dma_addr(pluto);
 
 	/* sync the buffer and give it back to the card */
-	pci_dma_sync_single_for_device(pluto->pdev, pluto->dma_addr,
-			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_device(&pluto->pdev->dev, pluto->dma_addr,
+				   TS_DMA_BYTES, DMA_FROM_DEVICE);
 }
 
 static irqreturn_t pluto_irq(int irq, void *dev_id)
@@ -595,7 +595,7 @@ static int pluto2_probe(struct pci_dev *
 	/* enable interrupts */
 	pci_write_config_dword(pdev, 0x6c, 0x8000);
 
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret < 0)
 		goto err_pci_disable_device;
 
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1340,7 +1340,7 @@ static int pt1_probe(struct pci_dev *pde
 	if (ret < 0)
 		goto err;
 
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret < 0)
 		goto err_pci_disable_device;
 
--- a/drivers/media/pci/tw5864/tw5864-core.c
+++ b/drivers/media/pci/tw5864/tw5864-core.c
@@ -262,7 +262,7 @@ static int tw5864_initdev(struct pci_dev
 
 	pci_set_master(pci_dev);
 
-	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&dev->pci->dev, "32 bit PCI DMA is not supported\n");
 		goto disable_pci;


