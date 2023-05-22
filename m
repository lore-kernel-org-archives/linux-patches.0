Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510DF171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0301C433D2;
	Mon, 22 May 2023 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784998;
	bh=oJyuUdW7yh/xDdfYftEhwWGaVkIMXDlfmho1Q5jTw0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piX5Q2RXMjf7hQjvVmH9a7Y9VBjxEXBnhfJEelmFCDGqg4jB03EHFzkJ09fk3gTsE
	 HkUR5GMZ0+3uqgZmwHnPkgq8oRInVeGDNi2/sHN85ORFhp484xOk3ftPgAVcCM2Wgq
	 V1tPNtpCeBiukTr/t8CIIInSNqZkJaB2IUc7pMwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Giladi <alon.giladi@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 274/364] wifi: iwlwifi: mvm: fix OEMs name in the tas approved list
Date: Mon, 22 May 2023 20:09:39 +0100
Message-Id: <20230522190419.566437923@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alon Giladi <alon.giladi@intel.com>

[ Upstream commit d0246a0e49efee0f8649d0e4f2350614cdfe6565 ]

Fix a spelling mistake.

Fixes: 2856f623ce48 ("iwlwifi: mvm: Add list of OEMs allowed to use TAS")
Signed-off-by: Alon Giladi <alon.giladi@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230514120631.4090de6d1878.If9391ef6da78f1b2cc5eb6cb8f6965816bb7a7f5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0c6b49fcb00d4..0ce0f228c9bdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1076,7 +1076,7 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 	},
 		{ .ident = "LENOVO",
 	  .matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Lenovo"),
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		},
 	},
 	{ .ident = "DELL",
-- 
2.39.2



