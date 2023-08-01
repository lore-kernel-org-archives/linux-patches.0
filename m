Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07F71F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D37C433CA;
	Tue,  1 Aug 2023 09:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881939;
	bh=IlKoMXAx8zR8fIYAxyXlgt688RTBBU3wcISHUv+L2cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moMi97eidHVpjWc5cBNlsCvZ/R1y6TDgzLtie2zmhGxiqnJz1RVwcAlpGywWmfIDE
	 ag7lyK+Jm3+qmAa6ZJp2URgPc+kRJKACCnpwAunU7xFP0cGfdS3rw5JsAh8eFTsH7I
	 LRhUmcg+KnPKnUu2p9vtNzViYm/nyKORyCCslzbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/155] media: staging: atomisp: select V4L2_FWNODE
Date: Tue,  1 Aug 2023 11:19:26 +0200
Message-ID: <20230801091912.124320070@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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
index aeed5803dfb1e..0031d76356c1c 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -13,6 +13,7 @@ config VIDEO_ATOMISP
 	tristate "Intel Atom Image Signal Processor Driver"
 	depends on VIDEO_V4L2 && INTEL_ATOMISP
 	depends on PMIC_OPREGION
+	select V4L2_FWNODE
 	select IOSF_MBI
 	select VIDEOBUF_VMALLOC
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.39.2



