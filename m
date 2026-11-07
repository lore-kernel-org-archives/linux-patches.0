Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064047;
	b=bgtyaGXYwHc62LhvWI8+l7wYPSAU3MDyP3aC3vp0IruEpQIb2N+Dn9F/TDgFEF+S3bYS
	 sbjF1OVB8iIxRONV0vnIy0iI/1TgJJEfqm5FsE1oyFn9AGvbv2eGM5rgQeIv6khPwUDat
	 aUw7xucTkW2ONZalAfdkmCXc+/PYXzxFkhcXfcf4yNSe3yRd5sszOv3s5jSUNt+SjJYVv
	 jPV9d3PaD1UEIB6E44VVadcCsAS7RO94HGDBq9xLz2EaxTmsykru0tofbvIjm2TY4CbtO
	 nfL3iEvZ5Zp/lzxoDSJwdwS1iKjBLo3FqOX+lQX7g4rpZpQYHlAAlSRU4U2axcKKeCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0tPwikjnoTql/z+H5zyIUIqe7yAboCPKP2u9HYDgc2w=;
	b=04rK6Yg64cuTxWZ6ShK63S3TgehwazyVT5YdHPmXVtrJBPXUL7N/IqLahF8pkZ+YRqLj
	 dFCbTIVRFtC0d6uU43lPVoV4MAKbpQOm/bPe/waI2A0nWkDWrFm4D8lTo8vggUG1qrXFV
	 YqwEMvGVeJ7OWrTCTH+t7ZIc4/d62udCkAaXT6/8OiZxnVmXehLhhYXb3oVAdAvXSSrxK
	 fCwQQUsAb1l9RckfM/o3QXZf1yff/1Zm9U7Fms0jz3eZjk8lUCBRs+b0mcrEELeQsJCXe
	 9oUCrzo7vMyYYwHfINJVimyB/oWtDMJrYp1U9jMHWTFGccpEHL+20TKLgXRsRCVNagg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEvIWTSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297F760A5BC3;
	Sat,  7 Nov 2026 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEvIWTSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928511F008A1;
	Sat,  7 Nov 2026 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064046;
	bh=0tPwikjnoTql/z+H5zyIUIqe7yAboCPKP2u9HYDgc2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEvIWTSGvPWkVv1OqGOtsMEeCBULEg3XtA3POPykRZFWLEi2pVf6Y0lyEhz4f0jRD
	 J8WeOOj27JFw6a3xbEdQg1HDnYL5AjDmtV2VvXPH8BqlXNFsw3/j4cdGcRw2KO1VMi
	 cJLIpdlgPBW4BgEYn6XWt8UOTqEMw9tczEkRHC6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0220/1257] i3c: mipi-i3c-hci: Bounce short reads irrespective of the IOMMU
Date: Sat,  7 Nov 2026 08:41:56 -0500
Message-ID: <20261107134945.611659250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7c2b204741304..5b195978f3762 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -428,7 +428,7 @@ static void hci_dma_unmap_xfer(struct i3c_hci *hci,
 static struct i3c_dma *hci_dma_map_xfer(struct device *dev, struct hci_xfer *xfer)
 {
 	enum dma_data_direction dir = xfer->rnw ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	bool need_bounce = device_iommu_mapped(dev) && xfer->rnw && (xfer->data_len & 3);
+	bool need_bounce = xfer->rnw && (xfer->data_len & 3);
 
 	return i3c_master_dma_map_single(dev, xfer->data, xfer->data_len, need_bounce, dir);
 }
-- 
2.53.0



