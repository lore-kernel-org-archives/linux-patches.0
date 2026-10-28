Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208257;
	b=xCsRXAkSVTZBSfZcoxZ1V8iphnlnijMRfNrcuwsX5mH/Ao8dFstI741YkLGnCPaWmafB
	 47zeuo0KDKOWtEDT7GIzdVW+uoazKENyymX6Lr33K25CptCVGuO/O6Dv8IVVuqgmHlK16
	 c5h2WIl+Er3B4dnG0/6DL0quNhctXhdGiyDY9F3p0i0VX9mo+IivMg77ddGC4lVU3vZ1v
	 u/tmDTjN4NLSLE4DUmft52FaXOxakdB7fi1Q2b8oL3VCpmIvpVYHCvBYTq1CX+XM/TBsT
	 sH2ZwkqaiSOCC31JC0bMLb+fLeH2+4cfpxSGkdSUrgfnrW+lgbGn0Chs4GQ+SyaQ5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cv5QfOSlUwjO3hcv/+ronWyy+6qQfi2DgwtgI2JJKoI=;
	b=46CbXDt23ow16pZWTzHRKyOftRMRl5ToBp9R8RlM19yfvuzZ1TSBgrymOOHb4+H1rA55
	 TnTb/9zcc+ijrh5ApUpx+9zAlJyXQFUmMEVk1nWbtfH2f4sifCYSOq3ftBPkYIr+uW/4x
	 Roo8SmYY7BKTn8UeYihsOenu5z+tWgAiuWG3fckXAcDoBIRm/E7Imh1iVDJMi2DHIky6g
	 hA3v4gydv0ySkBTFXxAbIMtOdSHTqgaz1uA1YFALX0TsNvry3PAL5b5GwJ5y2HWjdzqOh
	 KdyrPW34iF//2O8Ow2df/hjZu0tQr/K8TXeMYCKaZ1fZJY+/XbTsHE9uSIZcQRM/buw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlezOwJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903DF606A31A;
	Wed, 28 Oct 2026 17:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlezOwJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06521F01825;
	Wed, 28 Oct 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208257;
	bh=Cv5QfOSlUwjO3hcv/+ronWyy+6qQfi2DgwtgI2JJKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlezOwJx01iTxsODRaQ2W02KUVcNrb/HaHLu++bHE8IcteQgfysiprzdPrDcC2jO2
	 foOXo5NHC5VDzlGXTlJoMccr124dOPxciLoMn7L2CKLTFX+BPWLWemFGB/abXZZvXB
	 mzPFC9EosVnP0gx7t/YDGrE0dst5dQh/7XXgDqxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/516] device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.
Date: Wed, 28 Oct 2026 17:52:35 +0100
Message-ID: <20261028170003.608768465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 59ed5e2d505bf5f9b4af64d0021cd0c96aec1f7c ]

Useful where the fwnode_handle was obtained from a call such as
fwnode_find_reference() as it will safely do nothing if IS_ERR() is true
and will automatically release the reference on the variable leaving
scope.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20240217164249.921878-3-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 190069255582 ("device property: fix infinite loop in fwnode_for_each_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/property.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index 98227dbac9538..b6135176cfdc5 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -11,6 +11,7 @@
 #define _LINUX_PROPERTY_H_
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/fwnode.h>
 #include <linux/types.h>
 
@@ -119,6 +120,8 @@ struct fwnode_handle *device_get_named_child_node(struct device *dev,
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
+DEFINE_FREE(fwnode_handle, struct fwnode_handle *, fwnode_handle_put(_T))
+
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
-- 
2.53.0



