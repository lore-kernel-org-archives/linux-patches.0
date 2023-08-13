Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229A9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCFBC433C8;
	Sun, 13 Aug 2023 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961801;
	bh=o6c5ZIai3Aqu2yqf2U2cQwE1JwdDooFF1LMhUGR8b30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpvceQ/YyldrwQ9GbkoM8h3gjrmi1GKBEG/3yiqSDAqN1QmIvePC7eOl3oCo2B0SW
	 ocAfyC4T6fcK5t0svi8CmThPbcEIYARrmnkOif2ooLrx9a9TBi5r2e0ERBaiDJmjXF
	 AH9J5Tb8TnbRHOLfWE8XPlatlQ2YzkEQADa/wJwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 22/33] wifi: cfg80211: fix sband iftype data lookup for AP_VLAN
Date: Sun, 13 Aug 2023 23:19:16 +0200
Message-ID: <20230813211704.740396047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>
References: <20230813211703.915807095@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

commit 5fb9a9fb71a33be61d7d8e8ba4597bfb18d604d0 upstream.

AP_VLAN interfaces are virtual, so doesn't really exist as a type for
capabilities. When passed in as a type, AP is the one that's really intended.

Fixes: c4cbaf7973a7 ("cfg80211: Add support for HE")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230622165919.46841-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -370,6 +370,9 @@ ieee80211_get_sband_iftype_data(const st
 	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
 		return NULL;
 
+	if (iftype == NL80211_IFTYPE_AP_VLAN)
+		iftype = NL80211_IFTYPE_AP;
+
 	for (i = 0; i < sband->n_iftype_data; i++)  {
 		const struct ieee80211_sband_iftype_data *data =
 			&sband->iftype_data[i];


