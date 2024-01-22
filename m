Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470A77636;
	Tue, 23 Jan 2024 02:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975544; cv=none; b=Lw2h30YVBkGBhONxq2wqYgcF/gssdGnuYZUvYF99Nqr0swr884k+CYFpIpytF/9jnpgHwFu0RNNjKk6bSYbUUf58UG+tfnMyOegP5qo3iu9ohv4mVcqhbY9DXEqo9PNSAzAoqMR7ot/kgVENy4lw2SZTFwV56fMnP0/xmWIAgH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975544; c=relaxed/simple;
	bh=KsC3vpopOTuPfrSyqJ7CpmvsmC5gUerHtI8+QakqFgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1IS22xG1CNqndZGN9KCFNmlK9oAt3f4OG2Q2/sR9OpDh+ZQtBobIJV/jkNcdrX4nNydkadnSJOeo/nxAurOnBwiyy7JSd9V24qJNlLQvh298J2EXWEFnhoQnWSfN1bBJVCXSbuxDI6sXUtA1fak1Pq8h9blP3yB2Y2TwSCrLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqG64PdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqG64PdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271CBC433F1;
	Tue, 23 Jan 2024 02:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975544;
	bh=KsC3vpopOTuPfrSyqJ7CpmvsmC5gUerHtI8+QakqFgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqG64PdAMr5OZScRzVAdZWCHpVKUGAEwB65R9smffowfsidaVfOXRgfMY4FQW+s09
	 UwQD/2hmM6MxhLJfFdUjFBmId5+QtOZXgbLS7rh6TdnE17AGaFFm9//BiXleVvhlwu
	 ziAq3jNDgFsfegKREN3lt0b3uW2OsapDCsNnyBp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 472/583] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Mon, 22 Jan 2024 15:58:43 -0800
Message-ID: <20240122235826.429950810@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 99b4e3355435..4d958a165da0 100644
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



