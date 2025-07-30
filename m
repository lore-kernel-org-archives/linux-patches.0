Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC961F09B6;
	Wed, 30 Jul 2025 09:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869002; cv=none; b=YNCY1lEY602qwf9p92zh6MDKC1OkqQ65AOxeHIivHNCdUxG+Ry2QfSAtHdBObjcPBaCixT16qrmAaX2dmaUU2uv+BHUKjMKRAxhKFmPYrAswwqVTlsGxxLmU2ITzmZpHabPJx2UzWLJ+yQmBpAdF96h9+OdCRzdT2tPmvNnDagw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869002; c=relaxed/simple;
	bh=xZg/pNGiGtRzLu5oEKiQqx3FmWYF7fNmtIoq1DJjcas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PveeEKmjN1WNRGVLVZwxu3KSaIOWF7KLR++6Ia6V9/ZV27u146mV2MSBf4ctfRmMcCumfdi6Zlc8Ff2ntBA45vNZrrXwOODArfhD/hUacAn7txBpTv8ApDIaui+TUOSaUs/DWupSG5wJWT4VpyekbrVuPWeuztSOHIDhIeBWq+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDv8winq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDv8winq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16710C4CEF5;
	Wed, 30 Jul 2025 09:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869002;
	bh=xZg/pNGiGtRzLu5oEKiQqx3FmWYF7fNmtIoq1DJjcas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDv8winqGylFoEE/C4ZdhgKk6qdb7gqAzoxjU72S9D1CNuCeahEXHqKdyFCgZiEsO
	 33w7jfFaJsJzqefxOvHFvx7d1SPiWuwgj1ctQs1RYFI6QFvpPqnFGvNmMplfNjduG+
	 Lg+FxDOf4XucmoU2mDG6iyTO3pN4MxFXMLtb166w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 13/92] platform/mellanox: mlxbf-pmc: Remove newline char from event name input
Date: Wed, 30 Jul 2025 11:35:21 +0200
Message-ID: <20250730093231.134499249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit 44e6ca8faeeed12206f3e7189c5ac618b810bb9c ]

Since the input string passed via the command line appends a newline char,
it needs to be removed before comparison with the event_list.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/4978c18e33313b48fa2ae7f3aa6dbcfce40877e4.1751380187.git.shravankr@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 771a24c397c12..b8fe51e6d4d3f 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -15,6 +15,7 @@
 #include <linux/hwmon.h>
 #include <linux/platform_device.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <uapi/linux/psci.h>
 
 #define MLXBF_PMC_WRITE_REG_32 0x82000009
@@ -1666,6 +1667,7 @@ static ssize_t mlxbf_pmc_event_store(struct device *dev,
 		attr, struct mlxbf_pmc_attribute, dev_attr);
 	unsigned int blk_num, cnt_num;
 	bool is_l3 = false;
+	char *evt_name;
 	int evt_num;
 	int err;
 
@@ -1673,8 +1675,14 @@ static ssize_t mlxbf_pmc_event_store(struct device *dev,
 	cnt_num = attr_event->index;
 
 	if (isalpha(buf[0])) {
+		/* Remove the trailing newline character if present */
+		evt_name = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
+		if (!evt_name)
+			return -ENOMEM;
+
 		evt_num = mlxbf_pmc_get_event_num(pmc->block_name[blk_num],
-						  buf);
+						  evt_name);
+		kfree(evt_name);
 		if (evt_num < 0)
 			return -EINVAL;
 	} else {
-- 
2.39.5



