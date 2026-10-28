Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209880;
	b=nVtzU0ZxDhli01XFt0+KUO1R1Dcfl6Xq2cpbwBwgcSuLj1uizvwIJaM8Gm3oZYTalymP
	 fsmPX+Pgb+pBUSl+obSwjXxyFczP7oQ3wbLOOkULadoJMA5BbihwfL2UbSo5IxCzpxiDo
	 i7/rQBHuwEbWPqAMS/J9N5kEOu8aIR3cw+/3fMKEVYxCAFr88xaiODAxFwC7Mf8KbAA67
	 EVcDQ1xYN6WvoiQHa815q6E9TmNyWFf+jxAYE2Womr7FTNAdlNDvBiO7LpX4rhKA6al0K
	 ir1F43CLaP1X04/UNxAMHuns0fa/2O8BNUlxNOeUs4cgX/PthpkpaYBdUH9piBeqNNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zezn/f1/dspscY3K1FP3SNMuo8c4x9TN5la1Yz4Lzy4=;
	b=sQA347R/sEs7Rmm/jDydSlmQ9Fc1BHdknEholjHuCWsKcHQyUwggtq7ULuK6jnuZuevu
	 jauukUJOSj4oDXf+fweWv2dJk7jNFVMyltSL+J4WZIrsPB6NzgoMrGwBZL2rndolX4hl7
	 hlspUZNS7Yjd+3VrVpu1OhuWp2D8wulXD5UswC+oouYq1iAePo1AYeYGujkkvIhGOcJNh
	 itUZgbFu/C+fv92/3GMZL1dHbf1/1AsLv5tgXTOiJMw3XXd23sfnU+vYHj+XtY5kJflBd
	 LEBNUkUsPuqkrod+jmq+YLvPthuIv0bN2ehWddE8bWBQMS0xidxObSdHVQwi9rTL1WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7nmkoeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DEB606A31D;
	Wed, 28 Oct 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7nmkoeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFCF1F01828;
	Wed, 28 Oct 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209879;
	bh=Zezn/f1/dspscY3K1FP3SNMuo8c4x9TN5la1Yz4Lzy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7nmkoeMjSOv3qtL5UnHF+v4bqPZP9m1KR00p/J+N6Xp5qEAvSZpMC3xzKEVPCy5J
	 kDpcqkvAfVH1KxwVA9Ghs/LXANOYbzEPZ8wnRzWaFvJ27nRe7zgyC0Scp0Ztt/SOaS
	 4YuB53bm71+RJmtXrMgRlyft/bntVLsby8STFuPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien <julien82453@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 109/109] ACPI: scan: Avoid registering platform devices with resource overlaps
Date: Wed, 28 Oct 2026 18:01:33 +0100
Message-ID: <20261028165944.920350092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f234fdaae1cad8c39265e7ca0a14633076ec7154 upstream.

If acpi_dev_get_resources() returns overlapping I/O or memory resources,
the subsequent registration of a platform device will fail with -EBUSY
due to a resource conflict.  This is reported to happen on Acer Aspire
ES1-572 [1].

Avoid that by adjusting resources returned by acpi_dev_get_resources()
to eliminate partial overlaps between them.

This has not been regarded as necessary before because putting
overlapping resources into the _CRS of one device is really pointless,
but now that the issue has been reported to actually happen in the
field, it needs to be done.

Fixes: ab06eb920401 ("ACPI: scan: Register platform devices for fixed event buttons")
Fixes: 48fe2cddc85c ("tpm_crb: Convert ACPI driver to a platform one")
Reported-by: Julien <julien82453@gmail.com>
Tested-by: Julien <julien82453@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/linux-integrity/CAJOGg3z6LJPDsdPNBxajgy8_wQxfhYBRxe4EiurZf3kPU5A5Bw@mail.gmail.com/ [1]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: Tweaked the new message ]
Link: https://patch.msgid.link/12955541.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_platform.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
@@ -71,6 +72,36 @@ static struct notifier_block acpi_platfo
 	.notifier_call = acpi_platform_device_remove_notify,
 };
 
+static unsigned int acpi_platform_adjust_resources(struct acpi_device *adev,
+						   struct resource *new_res,
+						   struct resource *resources,
+						   unsigned int count)
+{
+	unsigned int i;
+
+	if (!(new_res->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+		return count;
+
+	for (i = 0; i < count; ) {
+		struct resource *res = &resources[i];
+
+		if (resource_type(new_res) != resource_type(res) ||
+		    !resource_union(new_res, res, new_res)) {
+			i++;
+			continue;
+		}
+
+		dev_info(&adev->dev, "%pR expanded due to overlap\n", new_res);
+		/*
+		 * Eliminate the previously processed resource that overlapped
+		 * with the new one because it is not necessary any more.
+		 */
+		memmove(res, res + 1, (--count - i) * sizeof(*res));
+	}
+
+	return count;
+}
+
 static void acpi_platform_fill_resource(struct acpi_device *adev,
 	const struct resource *src, struct resource *dest)
 {
@@ -151,10 +182,14 @@ struct platform_device *acpi_create_plat
 				return ERR_PTR(-ENOMEM);
 			}
 			count = 0;
-			list_for_each_entry(rentry, &resource_list, node)
+			list_for_each_entry(rentry, &resource_list, node) {
+				count = acpi_platform_adjust_resources(adev,
+								       rentry->res,
+								       resources,
+								       count);
 				acpi_platform_fill_resource(adev, rentry->res,
 							    &resources[count++]);
-
+			}
 			acpi_dev_free_resource_list(&resource_list);
 		}
 	}


