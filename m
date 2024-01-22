Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023A112F5A7;
	Tue, 23 Jan 2024 00:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969027; cv=none; b=Mx9ggML5aUTTlvZKbjxlUlH4Dl2oAdCGsKqZkDF60O/6cH83wpHpA1zpxkbeAenf0FOoNWW/5y3ugbJ00jDlGMgO0/IlgMpl4pPHMu96jLkw/+HCXatrdYNn/D8rzCFZnU9s9dttssX5a3BlCeHZePD0sNliSpTB7x7exbPb5a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969027; c=relaxed/simple;
	bh=9c4JCoxqxdgeJV1PrfJu90FhJOlOgqQqFxCk1m8OvLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D58IPlbL5tcaZBhJDu8wwWh9MVWStRSdrbrqugfA68QFo4J2U7S46ZaT7iSBkbetUaQIc2mmuhFGxRQ0nq3Nvyg/UABsfiKVawJdmQ5goSy8u+CRXrydsK+4K3okBWKkAK/d3t419DKqyHFHmedhJHEg7shAHubpDLsUUrgtq4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7SYRESG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7SYRESG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90931C433C7;
	Tue, 23 Jan 2024 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969026;
	bh=9c4JCoxqxdgeJV1PrfJu90FhJOlOgqQqFxCk1m8OvLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7SYRESG1TFN/xZK0e4c/RcX7rgasFmVb0Fl+gFO1nIBu0hWV4AC+O77D0P3xzxUF
	 8jbetGBWRFR4Q6VdvdaklbiDDlCUrdk/HYB5ivRparzNnD4BaXSeXksHcULCfq1fYe
	 of23S73Zo3svQx0B8IteqUIZ6IJdIhMsI0twFORk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/194] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Mon, 22 Jan 2024 15:58:18 -0800
Message-ID: <20240122235726.417627908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 479856ceda9f..5906e247b9fa 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -646,6 +646,7 @@ acpi_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
  * @index: Index of the reference to return
  * @num_args: Maximum number of arguments after each reference
  * @args: Location to store the returned reference with optional arguments
+ *	  (may be NULL)
  *
  * Find property with @name, verifify that it is a package containing at least
  * one object reference and if so, store the ACPI device object pointer to the
@@ -704,6 +705,9 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
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



