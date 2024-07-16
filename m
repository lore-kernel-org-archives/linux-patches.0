Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5107717A93F;
	Tue, 16 Jul 2024 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145106; cv=none; b=gaq9HqEh42fxRTHntRxneIPUddcpST/ZQD9XSZNX4fpl2M5WADw7ynxsw0qaYUd3ePte8dnKMdYgyL3SsMHXz8xRto0d2hOJbbXGJ7u2OYzzC8GKUnjU80Ze5I5JQMSgasSfkwWkQ1lY3rm63uk5LVjVfbrzHhFBCjHR38cEx/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145106; c=relaxed/simple;
	bh=FzMdAoUN0grSqFg2BedME6W4cL9Q0n/j1kU32WLWsi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+dzZWlkJoksAbBAShGYj2RYG6ooLOigRBned4fropeS3IrkGL5KR/OSphOthEc0z7aCgJhXTLvL2vv6iIO6Dn9kG6r0jlwSVLWH+vRTFKGoTH8obSaywCHvKgcuKmEWDfvBFJFSQ7JJsB+MkJ1BF24Rn6PrFGxELEfEJNI3ZsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZgNmyVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZgNmyVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0E9C4AF0D;
	Tue, 16 Jul 2024 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145106;
	bh=FzMdAoUN0grSqFg2BedME6W4cL9Q0n/j1kU32WLWsi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZgNmyVuMPIMjbs/xF8cN7WJTZdFanB4F1VzXCC9C7w8NOm9HtC/nkyf3BN1AdM62
	 geXPf58IXzVUOSfI3gi3sJxxe0nt8cS1XaRbwmyhcM8hAdn/08PsVu3fl5J9hUmbv9
	 Pa0y2HbQEbtqJmS3DMXEiz5/0hVaJ854DDva9Lyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 101/143] nvmem: core: only change name to fram for current attribute
Date: Tue, 16 Jul 2024 17:31:37 +0200
Message-ID: <20240716152759.864969637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,10 +396,9 @@ static int nvmem_sysfs_setup_compat(stru
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


