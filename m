Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC65677F2F;
	Tue, 23 Jan 2024 02:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975545; cv=none; b=naKxoOJ/P+JcLz9TfFYc2/cf9IZhM9B+CyK9HKvioLF0lWxIyx73JwfLAsKy4bNNwt9d6KJLNmzdUkmGAzGQ6lJmtonrENfI/CuorGWb8QET1BIOOd1IITSsdkEyIdQ857BnhbCBZ+iCCev0O51cOxgJPXM46S+ek951C7eIyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975545; c=relaxed/simple;
	bh=YZUYCJ3iC90OBJldgIAVmxMVRH1b6q2phmnvkEf7H78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDQfo2+LjFDMoMdGhLE6MRIOHNBfk074rhfymKGk1/1G3JpbmSusY9+4z416D2Oh9lgBwEHBEaO2M+muvj+Qmh3qDX/3D4fxWRpgB3IIo6UbRxXDcU1DWseKLpE/bkPbIIK4qVzjWuvfa7mc+abWixww3J+O9U/YicPcpBBaDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX68/MGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX68/MGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA3C43390;
	Tue, 23 Jan 2024 02:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975545;
	bh=YZUYCJ3iC90OBJldgIAVmxMVRH1b6q2phmnvkEf7H78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX68/MGrV3aTrnDka6PKYlNDOtZBQT5Q80Gi53gu4fR2cEKOQLvHztntJdfBzvxTb
	 sHmWxFRpFK9fs+NYGdI2TiiJPefG/sG0l3wRYr825qs+1W1OcF/qBiYlObGDhyY2UF
	 0nTvoiJOeAupAeghK1J/5IH5dYC2SBxIh72hM58Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 473/583] software node: Let args be NULL in software_node_get_reference_args
Date: Mon, 22 Jan 2024 15:58:44 -0800
Message-ID: <20240122235826.463788614@linuxfoundation.org>
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



