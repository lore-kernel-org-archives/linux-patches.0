Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210449;
	b=VQYoC0b/aUTpE7EIO2SNMZtH2yarXKXmbrRurGof+mfzBGdzIN7Yh47GiL08DHqKySih
	 rX8CC0OiL/vFJEDsGYRsoFA2YmRThP4qe7UwUNFIj/Gig47raqlOgXqSQE8UtwoubUhy0
	 CnOfI9w2+5GHsoh2ZaQRlwnEK5g1K0BGKY/b/VoTFJhWAoLpNTTJ4CzBZE0pLGK9BebNy
	 7P2rMiJrayI+9NO07WxpQ8MNA27WUY+YtHnaINAHPm2MQ0T2kQj0WnJkdwFQk2C2q4W1t
	 41ufjNF02jhvgVsm75wfj6hqF67Us+/qgPfHjeVkTnELuUiGq3P0BnAQoHI5gOGKLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaO5cwY/19qEXR0rYkT5DYJIrD5uyq296t8XT8X3TaM=;
	b=LkByCNXeYS1PktVhy15B/Br7fWtINJMkMviDN3RNn8r35DhDLEFD1Hke92cXS8E8zkaA
	 /+p4XofSznnTlX8lttH6MRWbYQ7VMkR2WGQeQKYEIjQse4qTqSQ7K5/30EnDChep3Zzmt
	 BnC7wLuot9cwLMsTzwl/KwNDiVQyElZDr/vfx4UrFjuZRB95txWngEoIfMQw0DiKgrQrY
	 AGTtiY+MTHeHIB6aYOCCCZqqjJ0SqzVjgFS9DYNsKGAMA3EbBpndrCn2niPiDBzCRtg87
	 M/mk7Te1ytyXeYG9L8DGnSG155RgAi0i2wZkFHY8xA7WapveqiyFCIaJI0FPupOrwFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEMioHcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32D606A31C;
	Wed, 28 Oct 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEMioHcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D117F1F01825;
	Wed, 28 Oct 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210449;
	bh=IaO5cwY/19qEXR0rYkT5DYJIrD5uyq296t8XT8X3TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEMioHcWGgi6AwJbOj5/6v4YEb3vV/VAkDueEzEUWteJlhKATwF9K6UJlmhn6j1LA
	 lIJslRvyE0YD3dFbbneZCZuPdldJnxJ6vhL2Z+UGwR00S84D8Jyhb/a/FhqMn8NPjk
	 PIzN1/PPU0qvcL1emRNlu5k+WksNu3pN7E79VWFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/571] device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.
Date: Wed, 28 Oct 2026 17:52:30 +0100
Message-ID: <20261028170008.097034283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 840f0545d4f9d..180d4a027ab38 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -11,6 +11,7 @@
 #define _LINUX_PROPERTY_H_
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/fwnode.h>
 #include <linux/types.h>
 
@@ -124,6 +125,8 @@ struct fwnode_handle *device_get_named_child_node(struct device *dev,
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
+DEFINE_FREE(fwnode_handle, struct fwnode_handle *, fwnode_handle_put(_T))
+
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
-- 
2.53.0



