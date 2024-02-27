Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C7C13A26F;
	Tue, 27 Feb 2024 14:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042825; cv=none; b=RuHLsdgFOmc/LuIAi0etEht2ObUdfzmihTwkoafh2Hx27htzh3pQ7Bx21XiF/+J5SLB9giw4MrtXG/pEG1af73rsyIWrGN1qAXsHOvdTOwwO76pNJWlkL+edJ6W8wRztN5Pnrkdu+pW7xSSx+NQOxmkqpBQEtHL2sZfVktstdvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042825; c=relaxed/simple;
	bh=i3gnM6hDC24XQkyb0C/jSdLUK+g5kxYea98dwIROdnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULhZMedTYClXVltpViD5YBdvWkl1WIrOZN1jfgZ6A5/OeqWaSqdSl/KqtJKwRjeBncJH2xcwHxKp394aElK0S79sMNHXW43lrsO4hhgvpkLsKg2Q+8NcYol6Yp4zsMPfyWue7voMJul0BOgZsUsg9pZWcOr5dLil8kmhHa+o16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj9qOeYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj9qOeYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620C8C433C7;
	Tue, 27 Feb 2024 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042825;
	bh=i3gnM6hDC24XQkyb0C/jSdLUK+g5kxYea98dwIROdnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj9qOeYLPwtlHZFgO9nTcL79x/g4M6/W73em6u/ByfQckSuHX7falrkA5lS3Imp7v
	 KZhQZrzCv/iKfOrL43F0vLAF8Vcm5h9zNYIUiSJw2WAHli5xKd7KBGmAwkMFrHq1Fo
	 mCUC3xnJVwYEnTxmER+UZR9sxzYZF6rSGyjO5ygs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/245] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Tue, 27 Feb 2024 14:25:23 +0100
Message-ID: <20240227131619.599114576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 488915328646e..9ab7f7184343a 100644
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



