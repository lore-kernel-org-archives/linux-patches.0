Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B81459FA;
	Thu, 13 Jun 2024 12:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281189; cv=none; b=N+dSqzocwRQxX+1YQ6MSDbxbr088RCwnksHwLnUZeRVp+pwqJP8YoHynnV+iJCoxQXAWj9sJxNADdFxG+EWionUqLA9cU1IUE0Ms1n+7Vw8i6ClR8NDNseAQvxYWekYTxEctgPspwsbYiXFxrNXlFnSYQ+V9li2ryE0j96plxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281189; c=relaxed/simple;
	bh=97xPibskSST2folviux5kU2G1wRp7sV8PIRAYe0dve8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS16dpXKIVWl1a+vsMXjz6cDYs1KVZwEXD5qzyRK9knZ0e1pcgeqJwi/5L3HKvvPEscQbqoQfLvR/A9uiy8tqtUvLvwbCje8YdnvdgX5VLYHlNa37Kjv2SvxgbMmOdkDKtn98K07q+afJ4Mqi0zS+81M12VxlYPCzunQ875SC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDFC3NZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDFC3NZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D1DC2BBFC;
	Thu, 13 Jun 2024 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281189;
	bh=97xPibskSST2folviux5kU2G1wRp7sV8PIRAYe0dve8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDFC3NZb8gG/OIcVb0j4FM5/RNtlEBgwgrQblqD+lxZJWlTBA28h4OCIUSHYBGizi
	 8mmZLZC2bgYwg3y4N3TEOwU/G/qnqky+m+uyXVP2Z0lHI9O1jkObPZ7E7uWVgubA5q
	 5M+oKNzC1Y2uXVLuFULp9AVS7fdypI+zeT2HAD1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/317] fpga: region: change FPGA indirect article to an
Date: Thu, 13 Jun 2024 13:33:01 +0200
Message-ID: <20240613113253.870220789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

[ Upstream commit 011c49e3703854e52c0fb88f22cf38aca1d4d514 ]

Change use of 'a fpga' to 'an fpga'

Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20210608212350.3029742-10-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b7c0e1ecee40 ("fpga: region: add owner module and take its refcount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-region.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
index c3134b89c3fe5..c5c55d2f20b92 100644
--- a/drivers/fpga/fpga-region.c
+++ b/drivers/fpga/fpga-region.c
@@ -33,14 +33,14 @@ struct fpga_region *fpga_region_class_find(
 EXPORT_SYMBOL_GPL(fpga_region_class_find);
 
 /**
- * fpga_region_get - get an exclusive reference to a fpga region
+ * fpga_region_get - get an exclusive reference to an fpga region
  * @region: FPGA Region struct
  *
  * Caller should call fpga_region_put() when done with region.
  *
  * Return fpga_region struct if successful.
  * Return -EBUSY if someone already has a reference to the region.
- * Return -ENODEV if @np is not a FPGA Region.
+ * Return -ENODEV if @np is not an FPGA Region.
  */
 static struct fpga_region *fpga_region_get(struct fpga_region *region)
 {
@@ -234,7 +234,7 @@ struct fpga_region
 EXPORT_SYMBOL_GPL(fpga_region_create);
 
 /**
- * fpga_region_free - free a FPGA region created by fpga_region_create()
+ * fpga_region_free - free an FPGA region created by fpga_region_create()
  * @region: FPGA region
  */
 void fpga_region_free(struct fpga_region *region)
@@ -257,7 +257,7 @@ static void devm_fpga_region_release(struct device *dev, void *res)
  * @mgr: manager that programs this region
  * @get_bridges: optional function to get bridges to a list
  *
- * This function is intended for use in a FPGA region driver's probe function.
+ * This function is intended for use in an FPGA region driver's probe function.
  * After the region driver creates the region struct with
  * devm_fpga_region_create(), it should register it with fpga_region_register().
  * The region driver's remove function should call fpga_region_unregister().
@@ -291,7 +291,7 @@ struct fpga_region
 EXPORT_SYMBOL_GPL(devm_fpga_region_create);
 
 /**
- * fpga_region_register - register a FPGA region
+ * fpga_region_register - register an FPGA region
  * @region: FPGA region
  *
  * Return: 0 or -errno
@@ -303,10 +303,10 @@ int fpga_region_register(struct fpga_region *region)
 EXPORT_SYMBOL_GPL(fpga_region_register);
 
 /**
- * fpga_region_unregister - unregister a FPGA region
+ * fpga_region_unregister - unregister an FPGA region
  * @region: FPGA region
  *
- * This function is intended for use in a FPGA region driver's remove function.
+ * This function is intended for use in an FPGA region driver's remove function.
  */
 void fpga_region_unregister(struct fpga_region *region)
 {
-- 
2.43.0



