Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E925A133435;
	Tue, 23 Jan 2024 01:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971891; cv=none; b=qmDJcK8kG5XxkydvO3yL9FfmIue5q8f3keXQrN3DIAJls600SJWINzd3+ZNJrbAbD8wsLdlbWbj2km0qo9lPNhHTYhpPJf+ICmwE5/shItq4uv3WL/IatybNEw9Cjakja5ufZBpSd8wTsuY+3GeBPZqSC2Lh93cAB0khM3H2C3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971891; c=relaxed/simple;
	bh=ipH2dBz8ESGoXGai6r17zMzq8fEmv7U5X7McE3zEZ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPwrQ/qn4QenlSgCSEQmAGLmq+VSX5bWThfIGEannCgEFGy2xRYkHS0h+BpD6SCkqC+oVzy7o7LcTBj5tJV1ot0EOChiT529clQdZr1h+Fohj9kg04zOiVdhUPW6tqdz/Zfw/p4fQ1oQWQNp5+lI9rGJ5iEsxjoKxoXptaqPQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysQpUN7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysQpUN7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB4C433F1;
	Tue, 23 Jan 2024 01:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971890;
	bh=ipH2dBz8ESGoXGai6r17zMzq8fEmv7U5X7McE3zEZ2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysQpUN7qfZF2SzgQcdysTXsc5dTpL0IlkQRSa+qgWkHPGpyt1bLKKzHZAbLz05Qzp
	 NY5LfBvvdl9HzSCt5j8sfYIjAeA+TiNolPGfthAqx7tWxdTgyEFQ2+gJsCkmGJxxum
	 8naOWIRnjY9soPLwjU9EU4J1lxRmMpkr95NoUFBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/417] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Mon, 22 Jan 2024 15:58:31 -0800
Message-ID: <20240122235803.675128221@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0565c18c2ee3..62aee900af3d 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -851,6 +851,7 @@ static int acpi_get_ref_args(struct fwnode_reference_args *args,
  * @index: Index of the reference to return
  * @num_args: Maximum number of arguments after each reference
  * @args: Location to store the returned reference with optional arguments
+ *	  (may be NULL)
  *
  * Find property with @name, verifify that it is a package containing at least
  * one object reference and if so, store the ACPI device object pointer to the
@@ -907,6 +908,9 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
 		if (!device)
 			return -EINVAL;
 
+		if (!args)
+			return 0;
+
 		args->fwnode = acpi_fwnode_handle(device);
 		args->nargs = 0;
 		return 0;
-- 
2.43.0



