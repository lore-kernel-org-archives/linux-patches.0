Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620134;
	b=PldjklFkUJS34DK08aCQeT4ZPbyOF958id8SAit4w8xb/Gj/OAvmkG9cYdKXhd3omuj0
	 /R1CBsVGvyQMhfIiXRvLrbsr3/xcIDILL3f0vqvdSI6EHgw8CFnhb00Ux912OaaZMbccV
	 rKMo28rVAUj6hbJlIBQ63Eze17n6+DgKtL3cKRf4btYvUVqujeApcSv9hjAPs5nayKIY6
	 d51j5BXdfKAg8qk95UJkmwV1dZiftth4ilo/YWFchjyhKmt1DQ79h7r64RCD6kNdscJtx
	 9NBawBnCr13kyGV1tPBHxtTjZOnh4WwdhBs941PayHmarO7dV6Zj46UbsRpalxyT7+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9I9x3bzkgFzFEmrV5emlK3T7tTxSEF3uJlFI4xpOJw8=;
	b=fkyaS4MG7cM8EsXxFsJjp18bSh8PsBfrOA58HSTjDSQgUM+Kz4bhhwwMon1UHFZwEinH
	 7q7kd4wVsjL3RBAmhar9vsjkSgD90ia+YjQnEn3tqFtt4ycryq7sdbZA1yx3Evk44woAh
	 FvN+TVE8Op95HbZsgQM+k6eqKdKAuy+UnhusQDqnbsCvo4EPvJ1S1qFdns+dGqDZAZ/ZI
	 jhFj7DokrqOzjinmLk52dktn8APSUEQzgTjbQMCtpP6Uas+ZoDVYZFWuH/yB9vVu6KTGq
	 vlKmfXJX09YWSwR+R3A1p3cVyFqSQVFU/KdTRjatWDmWJnJAb+Rk4leLK71Twk3T6/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmSErqus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37147606A321;
	Wed, 25 Nov 2026 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmSErqus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882D31F000C0;
	Wed, 25 Nov 2026 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620134;
	bh=9I9x3bzkgFzFEmrV5emlK3T7tTxSEF3uJlFI4xpOJw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmSErqusb1sY+xOKqGNjOKPOTouRCeGjK3PpstxMFFSw9Hz9LvosLQK66zEVbQxob
	 BE4frQjjzb7hWZ0Bts0k9Wyr2IbNuYfO6TJoZHRM/VFvqb2bmnkd86IUtP4HOAsamJ
	 P+LZON2zuiRj7D3vSIGl776CV6mbwACAKQZOPh8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0819/1005] gpio: virtuser: remove the debugfs files before freeing the line data
Date: Wed, 25 Nov 2026 15:35:57 +0100
Message-ID: <20261125143840.912256823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -946,38 +946,50 @@ static int gpio_virtuser_probe(struct pl
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


