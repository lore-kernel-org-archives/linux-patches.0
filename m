Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885712F5A7;
	Tue, 23 Jan 2024 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969028; cv=none; b=QCNMMHspuo9u7EfKgjUUBcihT332XG0R0a57MDeM9YAu6pemX/m3J0ckWSzaXOiWDmyPmfYsRtFHeNron7OIanhqjOo1auOY4ZrwjsTjfDvbIY01tfhogwAkX5CZeg0FYdm8JPKExxGYVrMmyoYmemxv4HRnWnXqNfU054GsDXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969028; c=relaxed/simple;
	bh=zWsVDbQ+Cy8uiMzruxed2ifcRodh1MPboaIdpwc2tKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlGNE0eqieA6X/AJAeCmkGYxVhM3G063WqfJ2NeD3eJatWsJdmYrVIVIysnZHQe9ptOL1fHaIhIrHinh0a6HOOaFFaYg/iJ2duxpSJlPWY0iE9J6qbUtPu0cZ1Pjg5zIfnLoq0lfxu3Ym8sMGQ7bs4gv7b5XlmK7tCCbBBcJsJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyMaugGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyMaugGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8BC433F1;
	Tue, 23 Jan 2024 00:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969028;
	bh=zWsVDbQ+Cy8uiMzruxed2ifcRodh1MPboaIdpwc2tKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyMaugGqQes05yn0B6rHiq4pbFeFaBYHRBPA4nDTwzYRLss9HuwVlncOmDeDkTC3A
	 9vDLapfWkVha36HjlwuW7wRG5zfseX3ojiT4d51TwhfnP4zj+BnHxqemVOaI/qgnFO
	 HyXOMSoGgIqYHetzyMq2BGJvI1hZ3XNtKMXiZf7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/194] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:58:19 -0800
Message-ID: <20240122235726.453889657@linuxfoundation.org>
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
index 4c3b9813b284..636d52d1a1b8 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -604,6 +604,9 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (nargs > NR_FWNODE_REFERENCE_ARGS)
 		return -EINVAL;
 
+	if (!args)
+		return 0;
+
 	args->fwnode = software_node_get(refnode);
 	args->nargs = nargs;
 
-- 
2.43.0



