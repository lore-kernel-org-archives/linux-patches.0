Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DE319E7D0;
	Tue, 16 Jul 2024 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145555; cv=none; b=JsYQwmAI+xqh7cnhij7khd6c9D219jnW5/2TFg8gl7TqRksB7W1QvstSzQHtOwxAGafKK3mGQZmZevw8zBmkXXz5wujfkvGZW4u7GEb/O4Qsg3liBtakIKw8QkOJecSelRMgIHRQFsExAXmIiAo7/3Lrk9Xn8xiQezEp/jK3OdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145555; c=relaxed/simple;
	bh=q/njhZvNGrl/YcRW9aPexiJl522eCifYU1dRVJlMmew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbf5JnsvU1vtyhw3c8Z1GvFld9qmY8diE5btSG0yx7iVg1KyOh1n3EbTV9CdJfE5Yp3mdeGBYN8Bmri5NFJAmZzimgCQxTdtS6Jp6IrrpZa2+8bxaolkcdn0SX3ggV1Q+GxfwfyAM3WcdMK1X1V3mdC7hQ6V4ZF8TEr7lO/6XLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdw3zNQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdw3zNQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386E5C4AF0B;
	Tue, 16 Jul 2024 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145555;
	bh=q/njhZvNGrl/YcRW9aPexiJl522eCifYU1dRVJlMmew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdw3zNQRnID39rV3yknCmFI3YQgJw6hpcJrgPQf5pZ+DVIKTCPefLtYMEJ++XoOX5
	 +TSrO+hYruRzMJHvqdfSQOkuZK8/gtsSiyEOGeusYX8HtX612srXMyDP5ps6blLo0x
	 arAfjmLgb5Pv9odUySR278vL9CWFIVAVQR/bRzkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 65/96] nvmem: core: only change name to fram for current attribute
Date: Tue, 16 Jul 2024 17:32:16 +0200
Message-ID: <20240716152749.008910041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 0ba424c934fd43dccf0d597e1ae8851f07cb2edf upstream.

bin_attr_nvmem_eeprom_compat is the template from which all future
compat attributes are created.
Changing it means to change all subsquent compat attributes, too.

Instead only use the "fram" name for the currently registered attribute.

Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -367,10 +367,9 @@ static int nvmem_sysfs_setup_compat(stru
 	if (!config->base_dev)
 		return -EINVAL;
 
-	if (config->type == NVMEM_TYPE_FRAM)
-		bin_attr_nvmem_eeprom_compat.attr.name = "fram";
-
 	nvmem->eeprom = bin_attr_nvmem_eeprom_compat;
+	if (config->type == NVMEM_TYPE_FRAM)
+		nvmem->eeprom.attr.name = "fram";
 	nvmem->eeprom.attr.mode = nvmem_bin_attr_get_umode(nvmem);
 	nvmem->eeprom.size = nvmem->size;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


