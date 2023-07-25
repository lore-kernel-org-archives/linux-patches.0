Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A7E14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BB5C433C7;
	Tue, 25 Jul 2023 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282412;
	bh=wKXr/dlvuwhoqG7NTqfII2N83LeUQF7/ue+SLfqzCUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B8a3ZErK4DlgXbnNLMH6aECF/tDOeDrkN0lv1hfhGBdTGJ28mhUxUm6s/CFzC6XZ
	 +E8ioq9VrtuTtrSecIsIGAjsI/lwD0Jz0qAhHFu09IWavmnwLi5QbeMRskxrzaR4Ix
	 N0M1qkDhGDAUqext987WKJgVCfd8S9pCj46kSLM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 120/227] wifi: mac80211_hwsim: Fix possible NULL dereference
Date: Tue, 25 Jul 2023 12:44:47 +0200
Message-ID: <20230725104519.772935768@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 0cc80943ef518a1c51a1111e9346d1daf11dd545 ]

In a call to mac80211_hwsim_select_tx_link() the sta pointer might
be NULL, thus need to check that it is not NULL before accessing it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230604120651.f4d889fc98c4.Iae85f527ed245a37637a874bb8b8c83d79812512@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 89c7a1420381d..ed5af63025979 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
  * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2022 Intel Corporation
+ * Copyright (C) 2018 - 2023 Intel Corporation
  */
 
 /*
@@ -1864,7 +1864,7 @@ mac80211_hwsim_select_tx_link(struct mac80211_hwsim_data *data,
 
 	WARN_ON(is_multicast_ether_addr(hdr->addr1));
 
-	if (WARN_ON_ONCE(!sta->valid_links))
+	if (WARN_ON_ONCE(!sta || !sta->valid_links))
 		return &vif->bss_conf;
 
 	for (i = 0; i < ARRAY_SIZE(vif->link_conf); i++) {
-- 
2.39.2



