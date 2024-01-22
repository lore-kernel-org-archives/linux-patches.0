Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B727456;
	Tue, 23 Jan 2024 00:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968705; cv=none; b=m8h6iohstJ4RMX7oNn2YHlxmlBiTS9sWYBWAStjbLtHITxBA3Mev/uik2M1dRZ+qJFhVpQWptWM84SsqDLNP1IGTJo52OY3/Qy8Yx5LUQsumN87PK0MjHTJmPRglmMX5NQGtzB0w3xUBEta1rrgttEJBTscQ3uAIxC1FP9SuWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968705; c=relaxed/simple;
	bh=IA3QQaB3WxWIb1aiQDw5mA3Y8zh/GId6J+wsO9ZMMQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4SpoCef+qcowMVoI4kpufoHpu2T9T/g4nsdIlMEN6HxrSXMWHLufFh4j20Eo5T32DL9bIDh9cNOOfXhnGjfRUSDduSU6zz9FlctDIycFYnKLOkh2Dsl4HXdR+LPjSok7rkUoV2wH6cEQhoTlAJA8KTE+bAt1x3yTj8qsZqPpuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2a0aI42O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2a0aI42O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB21C433C7;
	Tue, 23 Jan 2024 00:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968704;
	bh=IA3QQaB3WxWIb1aiQDw5mA3Y8zh/GId6J+wsO9ZMMQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2a0aI42OrtVbh9Et4ZDR2VxrLE0JqzAheZ/JFD92eD+F8oWKl3q+TM/w+Ah2TAyO0
	 ojGttgWmB8y3YqoAyqKHUhIcVejf8ksR9Rhas3UnyqpmqsB73rXOjJp0IlGJxPPCW0
	 /MKsAHlc3kbIfC9ErrE/rZ2Hvr9EuflmnxRly/48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/148] acpi: property: Let args be NULL in __acpi_node_get_property_reference
Date: Mon, 22 Jan 2024 15:58:11 -0800
Message-ID: <20240122235718.024199921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c59235038bf2..cfee286ee5c5 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -566,6 +566,7 @@ acpi_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
  * @index: Index of the reference to return
  * @num_args: Maximum number of arguments after each reference
  * @args: Location to store the returned reference with optional arguments
+ *	  (may be NULL)
  *
  * Find property with @name, verifify that it is a package containing at least
  * one object reference and if so, store the ACPI device object pointer to the
@@ -624,6 +625,9 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
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



