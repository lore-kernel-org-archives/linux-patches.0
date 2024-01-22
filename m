Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024941339B4;
	Tue, 23 Jan 2024 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971894; cv=none; b=LBnA+xs7RWdmi/P3zx3+IvJIUjx4di58jewlVvUu9t2hija0uVQaZYABOQ498GSe+DK3lDwKEPpu88naHWWHHIOq1d6pPHM+ScyzXyX2QMhkPZvmFoF1Tdg0sZRZ8tc4Q7gVQdkTl1pm3FOw4Gyo1hMW6CakLuaJ9TcATmctrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971894; c=relaxed/simple;
	bh=9WAaShs0zB7YOEv1wn77yxF3V09uDwYRMqWq0bu/0Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvo+X4Nre+OlNQWjdAdmwAjdXCpMaO8ofC5JYbHzrLZX70odznjrKTH4kDNZktrDNPbv/F1krHPAXXoAnXQ3PHqfjMeiZeL87XcW1y9Lg91uqSdVff84hwoLeRBVPJlaeJfgWARbidPbJvHvibC4RrTEKT7bsnLpNuYtgItJswo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdmxGk0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdmxGk0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E64C433F1;
	Tue, 23 Jan 2024 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971893;
	bh=9WAaShs0zB7YOEv1wn77yxF3V09uDwYRMqWq0bu/0Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdmxGk0k2nQRL5W/AaM0g/Y4R5QIi6uIdLD3rnoDlhsGML2M6Toif/3rxS+cO9lr1
	 kiny5JL3RjQdYShGNPgF8+FTUbWQ1sCvaR0Cy2qjdshMxb5WmBXhkSoTgjELgnIh2N
	 /U4nqzL2t5vAVP+mSHQDudjg2ipqdpAFBOuBtCmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 344/417] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:58:32 -0800
Message-ID: <20240122235803.710193708@linuxfoundation.org>
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
index 0a482212c7e8..44153caa893a 100644
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



