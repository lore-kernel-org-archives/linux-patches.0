Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8431FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB2EC433C8;
	Tue,  1 Aug 2023 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882949;
	bh=F1WrGyYnUd+dIx7oT4jukzFMuyAnQaXgIUgqDL5Vfkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1ORy2XQayL0k1VP5+hGQL3OCVqofuy6su7E4Irmt1fmNEA6bX5i9hItlZrBN8l0F
	 /DphqAsBYmWVMrHLakwf2IIjNgqN3S473714mUQdWsR88kQnPguzlWhcuh4Ipr48hZ
	 +eIAaoALDL1paW7F8QSofM8CAk1ImAdMf9ClYaEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 059/239] media: staging: atomisp: select V4L2_FWNODE
Date: Tue,  1 Aug 2023 11:18:43 +0200
Message-ID: <20230801091927.775011593@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit bf4c985707d3168ebb7d87d15830de66949d979c ]

Select V4L2_FWNODE as the driver depends on it.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: aa31f6514047 ("media: atomisp: allow building the driver again")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index c9bff98e5309a..e9b168ba97bf1 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -13,6 +13,7 @@ config VIDEO_ATOMISP
 	tristate "Intel Atom Image Signal Processor Driver"
 	depends on VIDEO_DEV && INTEL_ATOMISP
 	depends on PMIC_OPREGION
+	select V4L2_FWNODE
 	select IOSF_MBI
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.39.2



