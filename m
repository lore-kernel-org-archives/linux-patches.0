Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623356;
	b=3MUeK/T34AzyPToQhf26/+iePYeg0CtIu9S0Qr8iUB7LwbB3SZITFFSlrujbK0xL4CLT
	 /c6Vsf70p0dD5idgKzM8Uzc+y8Gc7zyBZZIZ+LB6awZqHfzuOBqFIgwoE4K8apxWz0l3Q
	 AB/fhIBOCD/dUD7CPqnbNcYqiewFfav56pGydfAMgbucZz6Y0o9x8MVNHGqcmEazjSfVj
	 5IHNTZ4oqQCdePcPT2Qpf2IoMWhf6qWEr+SeLRd9hDLfQnIlLP8S5W7R8nWajSUFqKM55
	 ZHY1DjwZqhYz5Bl4UkdMdbV6xnnrIzNrpUgHVaULxOrpGp5MEBcPRgXtn2HvhvGh+dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p64zcLfmkyJa/oFNPnax9TpssRtw17nEwlW2I2CACoQ=;
	b=ElXp0MO3O6q+7VN7x+KnxX0LflA2lyJ3Z1pD2iYP3rffqRqTAq8saygoDKXyEKwk6Q5R
	 830IRUMjEWRevZEsTYn+aKF2Ysqt6H5pfcyHL7FU2FRAWuR/7Mg4M4nbg4bfWrUSnu9x4
	 J8twITGChHJYJWptRI3RKGWhfbuhSd9L4Hxgm3aNre3OTSdD+PZnSsaWQ0c5R9vnwvh5+
	 sRpjs8H9zJE02oCEepgz2tY1ufkDMul1Zhm6xCUkaAflcd7XuUL08YUzV99MIPcL9pr1j
	 68ZnnxGghaUkK4x/B/1hQ7ywuXIlv6HBecQ2V1Z8TxSpW37oHeL2pOa9zfVNM+cdFFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcpeauiL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6A606A31E;
	Wed, 25 Nov 2026 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcpeauiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5BE1F000C0;
	Wed, 25 Nov 2026 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623356;
	bh=p64zcLfmkyJa/oFNPnax9TpssRtw17nEwlW2I2CACoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcpeauiL2j8TFMTyEMu2/n0VCUvKNQg4xcmUAjKFhp6TOqGrTZoMWsf5U2DziO26L
	 8ryjXWhIttgP0gLl79su92E4EAmgQUtUCPDKdzkyV22k80JIMkpyy7FZOCzuq4osuR
	 bXx/vix1Qb+Z6dMpU07y67D9gC+Of2bb5KuPantI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 830/990] gpio: virtuser: remove the debugfs files before freeing the line data
Date: Wed, 25 Nov 2026 15:36:37 +0100
Message-ID: <20261125143841.478182958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yu Zhang <yuz08559@gmail.com>

commit c2d0710318b8cd57d0ef6088d0ee4bbc1e827fd3 upstream.

gpio_virtuser_probe() registers the devm action that removes the debugfs
directory before it allocates the per-line and per-array data that the
debugfs files point to. devres releases resources in reverse order, so
on unbind the line data is freed, the consumer_lock mutex is destroyed
and the GPIO descriptors are put first, and the debugfs files are only
removed afterwards.

A read or write of any of the per-line debugfs files (value, direction,
consumer, interrupts, ...) that runs in that window dereferences the
freed data. debugfs_remove_recursive() waits for in-flight file
operations, but by then the data has already been freed.

Running eight threads that read the per-line debugfs files while
another task writes 1 and 0 to the configfs "live" attribute triggers
this within a second on a KASAN kernel, with gpio-sim as the provider:

  BUG: KASAN: slab-use-after-free in gpio_virtuser_value_get+0x19/0x60
  Read of size 8 at addr ffff888005109e38 by task vu_race/3479
  Call Trace:
   gpio_virtuser_value_get+0x19/0x60
   simple_attr_read+0x109/0x290
   debugfs_attr_read+0x5e/0x80
   full_proxy_read+0xae/0xe0
   vfs_read+0x1bc/0x7a0
  Allocated by task 1:
   devm_kmalloc+0x89/0x1d0
   gpio_virtuser_probe+0x56f/0x910
  Freed by task 1:
   kfree+0x196/0x430
   release_nodes+0x77/0xa0
   devres_release_all+0xf3/0x150
   device_unbind_cleanup+0x18/0x130
   ...
   platform_device_unregister+0x3c/0x50
   gpio_virtuser_device_deactivate+0x3c/0xc0

The same run also reports use-after-free on the freed consumer_lock
from the consumer attribute.

Register the debugfs removal action after the line data has been set
up, so that it runs first on unbind, and remove the directory by hand
on the probe error paths before that point.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Link: https://patch.msgid.link/20261102075707.41742-1-yuz08559@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-virtuser.c |   46 +++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -951,38 +951,50 @@ static int gpio_virtuser_probe(struct pl
 				     "Failed to get the IDs of GPIOs to request\n");
 
 	dbgfs_entry = debugfs_create_dir(dev_name(dev), gpio_virtuser_dbg_root);
-	ret = devm_add_action_or_reset(dev, gpio_virtuser_debugfs_remove,
-				       dbgfs_entry);
-	if (ret)
-		return ret;
 
 	for (i = 0; i < num_ids; i++) {
 		descs = devm_gpiod_get_array(dev, ids[i], GPIOD_ASIS);
-		if (IS_ERR(descs))
-			return dev_err_probe(dev, PTR_ERR(descs),
-					     "Failed to request the '%s' GPIOs\n",
-					     ids[i]);
+		if (IS_ERR(descs)) {
+			ret = dev_err_probe(dev, PTR_ERR(descs),
+					    "Failed to request the '%s' GPIOs\n",
+					    ids[i]);
+			goto err_remove_debugfs;
+		}
 
 		ret = gpio_virtuser_dbgfs_init_line_array_attrs(dev, descs,
 								ids[i],
 								dbgfs_entry);
-		if (ret)
-			return dev_err_probe(dev, ret,
-					     "Failed to setup the debugfs array interface for the '%s' GPIOs\n",
-					     ids[i]);
+		if (ret) {
+			dev_err_probe(dev, ret,
+				      "Failed to setup the debugfs array interface for the '%s' GPIOs\n",
+				      ids[i]);
+			goto err_remove_debugfs;
+		}
 
 		for (j = 0; j < descs->ndescs; j++) {
 			ret = gpio_virtuser_dbgfs_init_line_attrs(dev,
 							descs->desc[j], ids[i],
 							j, dbgfs_entry);
-			if (ret)
-				return dev_err_probe(dev, ret,
-						     "Failed to setup the debugfs line interface for the '%s' GPIOs\n",
-						     ids[i]);
+			if (ret) {
+				dev_err_probe(dev, ret,
+					      "Failed to setup the debugfs line interface for the '%s' GPIOs\n",
+					      ids[i]);
+				goto err_remove_debugfs;
+			}
 		}
 	}
 
-	return 0;
+	/*
+	 * The debugfs files point to the devres-managed line data allocated
+	 * above. Register the removal last so that it runs first on unbind,
+	 * before any of that data is released.
+	 */
+	return devm_add_action_or_reset(dev, gpio_virtuser_debugfs_remove,
+					dbgfs_entry);
+
+err_remove_debugfs:
+	debugfs_remove_recursive(dbgfs_entry);
+	return ret;
 }
 
 static const struct of_device_id gpio_virtuser_of_match[] = {


