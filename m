Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B730517B50F;
	Tue, 10 Sep 2024 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964534; cv=none; b=cbhiImXHKcbLHuFTGvPnue8Hz5XfZGnhVzudwSsB41OYZk8gcK1IuSo/KMz97yy4vthE2j9W+ARWmxO+WBvGwp4JaISHv7UhVPisKSpS0e7iqtYBApeS02o9yuDXBBxDAw166CzhXsMdABE9T0zF8xyrKVUBaS3YiY6GsqRaEKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964534; c=relaxed/simple;
	bh=He4qJXx1y3Z37yMCQ90ekQi8Sa1fkuGVP7eMrbMhrl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8Cs38oOD+AK+JcADnoIegGI9ZzbFhE5nSIsMHH3gzfYRD3oGAf7+d52eXDdb+GEMy1Za5Q4UGnYnAs/ZDGmotjKG7zPixsv0xCabykVW1QeGkJVBm5zG6FCEzRDon69aIsx92KBJnn41LNWAvMK7JnCOd4OQtmYacqrdCvwlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6l7ypwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6l7ypwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4101AC4CEC3;
	Tue, 10 Sep 2024 10:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964534;
	bh=He4qJXx1y3Z37yMCQ90ekQi8Sa1fkuGVP7eMrbMhrl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6l7ypwYM1xPWifIGuk/MeAAWHSSqelgqoq3Dl1JeUnAD1gOuLJcbTghXXaidBwCz
	 5IhXtfwDTDBMksHyVIyM7Av2fVyt4KINtZD1Z7y0jMH/6YvMEBZBEb4DhmXQkYkTqF
	 QjZv1x1jLD6jYDvt7jAlAgKkduvv3Fh0CTj5xVyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 216/269] nvmem: Fix return type of devm_nvmem_device_get() in kerneldoc
Date: Tue, 10 Sep 2024 11:33:23 +0200
Message-ID: <20240910092615.693107066@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
@@ -1253,13 +1253,13 @@ void nvmem_device_put(struct nvmem_devic
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


