Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062900;
	b=PCrT9rEBT6M3gIZyXSBDtrVyMUsVrUJElcbKPUyoSpzO/DWyjz5YBbLOHSr2skMfFaBk
	 o6+BI1GqRe6KvnGTGJbs43eOIfeDHyEFeU3XBJhw2pbpXpqHZ2pmSmTpA3D3DHxOgu3nP
	 gdbnx3nFqSh+4gXQexM5uUSMNYR2WCdfYu3fqRkyCgRG3hi3IubUBy2U6mPbV4/GtiNdU
	 wuBOfjBr8iN1rc19legGrdsPVmrxeEILTkn6ClvwnwkFFM/6N9RI71dE7LvQqsleco640
	 5WOZz4ScGDBcbjruuCqGcQn/8D+jqBeRzUwiaiB5tTbjHYST1xPSALeeJttroo5Uc/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXGDltaaKOfB9xDSaVKqEZsGOi5SyX2/qlCZFNbrW7E=;
	b=q62TYH2yKesHQiwoERH8xcy2mw5LQylLgW1mHbwBiE/6A5nOM73M3cbE6U0FVTyeobpd
	 3TWLG3RA+maJOhIFpMZ1b/3SHM0p1DY2QUUbgSFPL1BC8A9JYv+Vgc37iYam2RsEiW0h7
	 Jcc+7ZjOr6kRlmIky/67UCzyW32StjrsOU8CkVxvzvJuI/nju+jfysMf84N9djQM6W8Db
	 MBG6jPLnvQ5XHTjTAp6/71NWVu7rIJjgsB/sJLJ/Ty49RTNIqv+fvTwZFCIlkipC+tDU4
	 xux2GIuV9OV/AYNZ3jaPH1dwMQv0Oi+KW1GoKu/T0Y5O1yjb3nuCZVH8nNh9CUPE6wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgO9XYJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E260606A32D;
	Sat,  7 Nov 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgO9XYJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06A31F0089F;
	Sat,  7 Nov 2026 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062899;
	bh=bXGDltaaKOfB9xDSaVKqEZsGOi5SyX2/qlCZFNbrW7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgO9XYJpK2F56U9n2hbwqjbk7o6GcWl0T9SP44P1954MzrqLyHX2iyqA9oupvX284
	 boy+HClJgEGkPQEQsrroO5CKPdLLqnlFCmtcNRna7uAzqhcapjT4+sHYyzXoRKDjfA
	 H4wRXG9wEBJa8ng+rjJ6FzjcyBULILawYlvUdgvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/869] i3c: mipi-i3c-hci: Bounce short reads irrespective of the IOMMU
Date: Sat,  7 Nov 2026 08:47:37 -0500
Message-ID: <20261107134858.114663361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b1a25e8e143ef880450e6399fb0733b66a1c29f0 ]

The controller writes whole DWORDs, so a read whose length is not a
multiple of 4 overwrites up to 3 bytes past the end of the destination
buffer. That is a property of the controller, not of the IOMMU, but the
bounce buffer that works around it was used only when the device was
IOMMU mapped. Everywhere else the buffer is left unprotected.

Drop the device_iommu_mapped() condition.

The overrun is easily seen with CONFIG_SLUB_DEBUG=y and kernel command
line options intel_iommu=off slub_debug=FZPU, which reports it as a
kmalloc redzone overwrite, like:

  [kmalloc Redzone overwritten] 0xffff8a354561570e-0xffff8a354561570f @offset=1806. First byte 0x15 instead of 0xcc
  =============================================================================
  BUG kmalloc-8 (Not tainted): Object corrupt
  Allocated in i3c_master_retrieve_dev_info+0xc1/0x760 age=40 cpu=6 pid=1
  ...
  Freed in i3c_master_enec_disec_locked+0xeb/0x140 age=40 cpu=6 pid=1
  ...
  WARNING: mm/slub.c:1233 at object_err+0x1c1/0x1cf, CPU#6: swapper/0/1
  ...

Fixes: 9e23897bca62 ("i3c: mipi-i3c-hci: Use physical device pointer with DMA API")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 37717e530a250..15a34429197b5 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -376,7 +376,7 @@ static void hci_dma_unmap_xfer(struct i3c_hci *hci,
 static struct i3c_dma *hci_dma_map_xfer(struct device *dev, struct hci_xfer *xfer)
 {
 	enum dma_data_direction dir = xfer->rnw ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	bool need_bounce = device_iommu_mapped(dev) && xfer->rnw && (xfer->data_len & 3);
+	bool need_bounce = xfer->rnw && (xfer->data_len & 3);
 
 	return i3c_master_dma_map_single(dev, xfer->data, xfer->data_len, need_bounce, dir);
 }
-- 
2.53.0



