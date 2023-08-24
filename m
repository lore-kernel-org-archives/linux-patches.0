Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619D11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04138C433C7;
	Thu, 24 Aug 2023 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889095;
	bh=RxXPSJ/DvefTdCj/8s3JmsgJ7kLz5AbjwBuhBz256oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRu8a6xk49XBnQnbAHkuY5IKYxgWyVEC2gMlX5lHufpNeXyK26Y5iJdN2Rwo1204F
	 MFpo2vIiu5C7MNUNkRpxtxNRGYkeZfGa5wsDmTQewGsurwg9Z8bDfRiydnNG+z+i7/
	 xwjvNT51rf3St48AZApo7nRPiq8dG+/2muH6e+8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Yong Zhi <yong.zhi@intel.com>,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/135] ASoC: Intel: sof_sdw: Add support for Rex soundwire
Date: Thu, 24 Aug 2023 16:49:16 +0200
Message-ID: <20230824145027.551917993@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uday M Bhat <uday.m.bhat@intel.com>

[ Upstream commit 164e5dc17525181c05563f0a06796f1a363801d5 ]

Add rex entry in the soundwire quirk table

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230602202225.249209-28-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 30cc8bbceb79b..cbbb50ddc7954 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -207,6 +207,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(RT711_JD2_100K),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Rex"),
+		},
+		.driver_data = (void *)(SOF_SDW_PCH_DMIC),
+	},
 	/* LunarLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.40.1



