Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AC1133435;
	Tue, 23 Jan 2024 01:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971859; cv=none; b=AYa4WkrsBA4q9nl/FldEpBo/AOHTSpqixA0HP8lVGsXHCVOXIdmTZniuPPOsUmJtKFc+1rf/wwLSx4hMzlOK9tHHmu3eoPA2/Knt9WuDCd3BOr+O7PjjxwX3QJlBtD606lLNt1AmeobSCsyM7LXraPD/sn1MspQ4uvqdIrGU+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971859; c=relaxed/simple;
	bh=Rw1G3U4pMk2fFUTIoeOT3DXXQwdhLttm9bksex2HSQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLaqBCS1WB2YgKmSZsy4WeRYcWYULyAoBymkHwjA1YK+tggrxv4MqikapT62iJfC0gsZLwTBkL8GCrexFzDzAf5RhXnUjVtFG/8QiZ7EIs0KzAW2bwkuX0QSjBqD+P9Vn7RU/pyT1slEZCEivPTVltXygRo8U47Zfx7v5/sEaew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9p6MQiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9p6MQiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9CDC433F1;
	Tue, 23 Jan 2024 01:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971859;
	bh=Rw1G3U4pMk2fFUTIoeOT3DXXQwdhLttm9bksex2HSQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9p6MQiUjp7ddampM4nzc1hsOaLhP4wDixOQtt7+zOnhr+no51/B+SEmaGn6p3t0q
	 bh2nCUa4ZR2V/a18eyGsvLUYHNFb4cA7355Atesipz+8X+ekTqu6L6lqu6pq/Dlf/H
	 dhD7H5YyyxIX3fOjvGdJ21mHq1KvuYsyYv0QqAP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/286] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Mon, 22 Jan 2024 15:59:11 -0800
Message-ID: <20240122235741.493358299@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit bef52aa0f3de1b7d8c258c13b16e577361dabf3a ]

fwnode_get_property_reference_args() may not be called with args argument
NULL on ACPI, OF already supports this. Add the missing NULL checks and
document this.

The purpose is to be able to count the references.

Fixes: 977d5ad39f3e ("ACPI: Convert ACPI reference args to generic fwnode reference args")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231109101010.1329587-2-sakari.ailus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 80e92c298055..cf872dc5b07a 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -639,6 +639,7 @@ acpi_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
  * @index: Index of the reference to return
  * @num_args: Maximum number of arguments after each reference
  * @args: Location to store the returned reference with optional arguments
+ *	  (may be NULL)
  *
  * Find property with @name, verifify that it is a package containing at least
  * one object reference and if so, store the ACPI device object pointer to the
@@ -697,6 +698,9 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
 		if (ret)
 			return ret == -ENODEV ? -EINVAL : ret;
 
+		if (!args)
+			return 0;
+
 		args->fwnode = acpi_fwnode_handle(device);
 		args->nargs = 0;
 		return 0;
-- 
2.43.0



