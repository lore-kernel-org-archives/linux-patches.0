Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23D563114;
	Tue, 23 Jan 2024 01:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974982; cv=none; b=iieovcdOZnipwRKywxvs3AWBO4UIyoXGIQFmnt3y1UyDo1TVnVX7YxA+vWX07WFykj6bfMwGEE2jifbaTF90kr8HH0JYV8qxlVPdTvRksE4OngUT3cI6zyocwkmJFcwZsCoWyvg49tpuStSWaXDkHoHJJ4WMenNINiMqmP4G2as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974982; c=relaxed/simple;
	bh=lk/m5v2uDFRILsfzD2K4MV+TKvES+F15+a+aDZUdRSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlSNX2ggMtOv8z0UCw+1sJdLEuRhjwjZ8ra1uV2lxQHGw5NDarl36obcHfZ9OGII0fr+p5ajDfxR13sgB3UM52DY1C7AV9vejmT+K7euQo76ktyxRWyVgqf5rxdHpj1ce/OOAAPqUwewL6KFD3ilbAqzax3/60T8ZdOFI0NRR88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkrXKR/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkrXKR/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845ADC433C7;
	Tue, 23 Jan 2024 01:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974982;
	bh=lk/m5v2uDFRILsfzD2K4MV+TKvES+F15+a+aDZUdRSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkrXKR/prL3tARfOKMamlX6xCd0+udHd339IZdY7LWaAXurFEWtkm/eAWeDe5mYYI
	 bBh5gJ+W69bXYZh+Wi8dTb3tbRF6iG3VRNp+c3EaHsPtT0GAMhXNyol5b5ioScpt8Y
	 QJTd5KRRNCjiX48mYqDvU8B9EXPGHfF8CoKIMMnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/374] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:59:23 -0800
Message-ID: <20240122235755.532463177@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 3ba1232ce845..15f149fc1940 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -547,6 +547,9 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (nargs > NR_FWNODE_REFERENCE_ARGS)
 		return -EINVAL;
 
+	if (!args)
+		return 0;
+
 	args->fwnode = software_node_get(refnode);
 	args->nargs = nargs;
 
-- 
2.43.0



