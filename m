Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8767318F2DF;
	Tue, 10 Sep 2024 10:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963802; cv=none; b=QWwrt3Ur6gZeDMYPo5tMv2pHFXC+U7n8miLFIxl47ROusEpS9QOXdi9mo1ea7DpjTLfNKLTLOQ/JwhYITyDUJXM543zTQhgqMAxDjDAACB/Jd4NKYzKDY/tbVKDUA2ZBtmWiKvcgL5Xl1OQwgK7nM2Lmmi+4BxiRrSYGfR72ggE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963802; c=relaxed/simple;
	bh=QWdXBC7fbuF5LIvFkSXk/33xGO47zlxUfpNclLFzqd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZoFUHbogcuDrKKwhsQUO+IXQroy8R3G2suKaRlNDYXFb/+VbftVSR08tyN9rTv2wyemzY+0Dw2F2awkd0dwzupgTsBMMckeceLNnAztHxNNXF+o+myClKtETGr0rXGVAR+sBv+Ve4klcb1Eb+LpOoXISADPj8H1f+mlv5XUPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFM0b27m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFM0b27m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3284C4CEC3;
	Tue, 10 Sep 2024 10:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963802;
	bh=QWdXBC7fbuF5LIvFkSXk/33xGO47zlxUfpNclLFzqd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFM0b27m0SKJMvCCNkMYcJ8ayb2V4Ke0bxmaONAEmAspBsZ9ShA0MFZydGY0pXwPj
	 WOsHZ73yT5WHAQf08aq4oZUI9lS4ZaMW67SxK2TV+2DayCJPkteMsJ8TeSYl3SIL/c
	 8x0AFu9KpO3/h9Yo4ccIVLjo5qs5EXbQrR+A7UiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 182/214] nvmem: Fix return type of devm_nvmem_device_get() in kerneldoc
Date: Tue, 10 Sep 2024 11:33:24 +0200
Message-ID: <20240910092606.132171695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c69f37f6559a8948d70badd2b179db7714dedd62 upstream.

devm_nvmem_device_get() returns an nvmem device, not an nvmem cell.

Fixes: e2a5402ec7c6d044 ("nvmem: Add nvmem_device based consumer apis.")
Cc: stable <stable@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240902142510.71096-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1112,13 +1112,13 @@ void nvmem_device_put(struct nvmem_devic
 EXPORT_SYMBOL_GPL(nvmem_device_put);
 
 /**
- * devm_nvmem_device_get() - Get nvmem cell of device form a given id
+ * devm_nvmem_device_get() - Get nvmem device of device form a given id
  *
  * @dev: Device that requests the nvmem device.
  * @id: name id for the requested nvmem device.
  *
- * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_cell
- * on success.  The nvmem_cell will be freed by the automatically once the
+ * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_device
+ * on success.  The nvmem_device will be freed by the automatically once the
  * device is freed.
  */
 struct nvmem_device *devm_nvmem_device_get(struct device *dev, const char *id)


