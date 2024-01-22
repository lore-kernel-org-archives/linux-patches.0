Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2C456B60;
	Tue, 23 Jan 2024 00:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969915; cv=none; b=n/dXM/17w7/DeIRChrm70f9fBc2MvEJht3vWGxobqeGIabIjxAJFCCH1iAB4QNW01ZoX/n8TBbv0wne9YHvH7LZFA5t4dF6Mc5ny5X6Ok7jEO93c8MdFe5T3sx8gow7B6IlevOk17KCOLR5pntrzjfTMhulzJgxQbERbtVzCA9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969915; c=relaxed/simple;
	bh=7tv+QAAyNhVciqPxjQDgMxxLjJLduUqlNI9KIhfTAJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9wqGZlbqdcxispx/A1wcMNugfrNlD8/dYSRTmY6RYcA0zNw0eO/PCoKm980LqUM13mS4+XA4sTIlyXWZL8+Sz2C4xloSChFIxv1yvKTq+FEyH/sFOCJs2muec1L4bnAxnBz3xOyWeu6XXH63OkRy3Y/yNOV7YhjdaJUICQaowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1w3JhQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1w3JhQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EA2C43390;
	Tue, 23 Jan 2024 00:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969914;
	bh=7tv+QAAyNhVciqPxjQDgMxxLjJLduUqlNI9KIhfTAJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1w3JhQwUYruijKpiKn1TH4oE4tLf8xPJ5KoXPHQJ8L93UioX4JBrhtAz6PFF3xWg
	 MjgGJDxl6/khDPBm7v0tuZ6lpcjoH49L0DgN0z/BB/EPoexh49UiIHcNavPSgdeXGx
	 a0RhR0b6VC0vlA4QzS+C/MQE+RyROhynDkzRquHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 522/641] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:57:06 -0800
Message-ID: <20240122235834.427221183@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1886995a0b3a..079bd14bdedc 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -541,6 +541,9 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (nargs > NR_FWNODE_REFERENCE_ARGS)
 		return -EINVAL;
 
+	if (!args)
+		return 0;
+
 	args->fwnode = software_node_get(refnode);
 	args->nargs = nargs;
 
-- 
2.43.0



