Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9033B6E8;
	Fri,  9 Jan 2026 12:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961882; cv=none; b=kKGZzzIqwqxe3q7cadKRICqRjJLoQP6P7E6N0bXU3YyL57F7KeDZ/f26n0zegAjUb08rS+rIkbbOeg8gTXYuHdKjq7iifrjGJ8yO3vY+Rkk+MD38wiSrHR73whEkdk6LWMp+Mfi1E3xzpzGxXuBOxh3qzdUReKb+GGhn/oON0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961882; c=relaxed/simple;
	bh=RQtRq9I3sJWw1pDKqOtHhNo1/dEGyHNq0gWM6gjWN3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRsDsAi1JzMMgRdrXQ2jsajPA1Cbv6sYilEaXBgQzqMg6zTYXK4qE/GT8Dfu1MZ8J3DUo6gKq01Vn5vPitiMJPgEr8jT3yT0adiEpGD9WYVCOc6CfYjyM9SA7URn/o/O8VS903EKY1gHb5FKaIjGlT+GM+wKjiU+/3OwFaCxOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSNBnfcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSNBnfcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E513C19421;
	Fri,  9 Jan 2026 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961882;
	bh=RQtRq9I3sJWw1pDKqOtHhNo1/dEGyHNq0gWM6gjWN3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSNBnfcRj7xcB78Ug1rNwS8hzwnyekaRuu0sVP5yjXKxuy+lmbWI05ifEKAYRpqyq
	 Kvtws+2UgHfnmwPQxygn9V3FgfZ0AXZf9zxJYhz/DHNUutDh/DGUHX+vxV3+R4p10a
	 vjsCUDljERfqxQdFGUAOhXyw5hWBn8U7ZLBhRNYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/634] resource: Replace printk(KERN_WARNING) by pr_warn(), printk() by pr_info()
Date: Fri,  9 Jan 2026 12:37:26 +0100
Message-ID: <20260109112123.769310027@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2a4e628570d42fcc13a94f1acf25e3cfeaec08f6 ]

Replace printk(KERN_WARNING) by pr_warn() and printk() by pr_info().

While at it, use %pa for the resource_size_t variables. With that,
for the sake of consistency, introduce a temporary variable for
the end address in iomem_map_sanity_check() like it's done in another
function in the same module.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20221109155618.42276-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6fb3acdebf65 ("Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index ca0a59f5bc2bd..eb713a984c749 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -930,7 +930,7 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
 		if (conflict->end > new->end)
 			new->end = conflict->end;
 
-		printk("Expanded resource %s due to conflict with %s\n", new->name, conflict->name);
+		pr_info("Expanded resource %s due to conflict with %s\n", new->name, conflict->name);
 	}
 	write_unlock(&resource_lock);
 }
@@ -1325,9 +1325,7 @@ void __release_region(struct resource *parent, resource_size_t start,
 
 	write_unlock(&resource_lock);
 
-	printk(KERN_WARNING "Trying to free nonexistent resource "
-		"<%016llx-%016llx>\n", (unsigned long long)start,
-		(unsigned long long)end);
+	pr_warn("Trying to free nonexistent resource <%pa-%pa>\n", &start, &end);
 }
 EXPORT_SYMBOL(__release_region);
 
@@ -1686,6 +1684,7 @@ __setup("reserve=", reserve_setup);
 int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 {
 	struct resource *p = &iomem_resource;
+	resource_size_t end = addr + size - 1;
 	int err = 0;
 	loff_t l;
 
@@ -1695,12 +1694,12 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
 		 */
-		if (p->start >= addr + size)
+		if (p->start > end)
 			continue;
 		if (p->end < addr)
 			continue;
 		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
-		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
+		    PFN_DOWN(p->end) >= PFN_DOWN(end))
 			continue;
 		/*
 		 * if a resource is "BUSY", it's not a hardware resource
@@ -1711,10 +1710,8 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 		if (p->flags & IORESOURCE_BUSY)
 			continue;
 
-		printk(KERN_WARNING "resource sanity check: requesting [mem %#010llx-%#010llx], which spans more than %s %pR\n",
-		       (unsigned long long)addr,
-		       (unsigned long long)(addr + size - 1),
-		       p->name, p);
+		pr_warn("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
+			&addr, &end, p->name, p);
 		err = -1;
 		break;
 	}
-- 
2.51.0



