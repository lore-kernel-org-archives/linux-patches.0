Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429861350CA;
	Tue, 23 Jan 2024 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971965; cv=none; b=ILi/vwe8OZYZEPIB9pdBTVkf+7UQvcOE8TCCeWu9p+DqJRXZ8PqDOlCBdCI7kkqx+hCEbrRQpOsGcxrB8zyCZg6sc7uMA783pvJEzbOo+9XmV3MxmV4DGmCMHQxVXOfkm/WrvdjyF8mNh8pgLdUFjc7C/mfxqmhnTOr+8Rz63Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971965; c=relaxed/simple;
	bh=LW7l1vK+jkH+uViXMkVxG1vglDlSkHKPHy3nanluptY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMoHIPzZllAxplhFETg/p3/lvWOYBTmhgEciOQHV5/e1uNmNQMxy+0JGlz7M8iGI00Pi8CgDuc4jmGG774ZFVovwk+159ZIZTFnIMO2WJU1Ku58U+7gXh8bFKdqPNSqGZJr+ZiS4/N2H0EJOlkIQDlulxpvZNFPJ9aQqMqtadqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkeMJJ4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkeMJJ4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B394BC433F1;
	Tue, 23 Jan 2024 01:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971965;
	bh=LW7l1vK+jkH+uViXMkVxG1vglDlSkHKPHy3nanluptY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkeMJJ4G8Z7wDKkS+475gumrc2+o+c4xmbmS9ZA6fFlXMrYO0a04UdlVPKoxWHSPN
	 wy6ieEkK/ZQHU/qc2BEtCs6AABW1ZlAOwKcTZ3wwZyhI0vXoRCT3CjVS7Q+zd9EehS
	 +tMkzWXFf6SD+kOBammfBuNGvVTjQvzMyFgdIebU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/286] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:59:12 -0800
Message-ID: <20240122235741.534867479@linuxfoundation.org>
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

[ Upstream commit 1eaea4b3604eb9ca7d9a1e73d88fc121bb4061f5 ]

fwnode_get_property_reference_args() may not be called with args argument
NULL and while OF already supports this. Add the missing NULL check.

The purpose is to be able to count the references.

Fixes: b06184acf751 ("software node: Add software_node_get_reference_args()")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231109101010.1329587-3-sakari.ailus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index d2fb3eb5816c..b664c36388e2 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -531,6 +531,9 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (nargs > NR_FWNODE_REFERENCE_ARGS)
 		return -EINVAL;
 
+	if (!args)
+		return 0;
+
 	args->fwnode = software_node_get(refnode);
 	args->nargs = nargs;
 
-- 
2.43.0



