Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E79446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A36C433C8;
	Sun, 13 Aug 2023 21:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963268;
	bh=4UYuX4GX9QdnG3CYiBn8vKTr5Kbxaneem42Nc/h7MNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPVlgcK2eQBGcZ+Lh+/HrDwYlFTs4FhKzEoJgF5WvLUR30sp9bX9j9NcQnWT18lZ0
	 bI5TxeBpvyvDY3AeZXF3N5eTyl9+Q85Yw0krBV7gbCDDKEVsm5rUQFwzD7cVXK21Uo
	 5B1J3bGvjiCkGrD2etFWbIlrCu2SOZzygPnp9hc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 24/39] wifi: cfg80211: fix sband iftype data lookup for AP_VLAN
Date: Sun, 13 Aug 2023 23:20:15 +0200
Message-ID: <20230813211705.644534101@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
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
@@ -436,6 +436,9 @@ ieee80211_get_sband_iftype_data(const st
 	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
 		return NULL;
 
+	if (iftype == NL80211_IFTYPE_AP_VLAN)
+		iftype = NL80211_IFTYPE_AP;
+
 	for (i = 0; i < sband->n_iftype_data; i++)  {
 		const struct ieee80211_sband_iftype_data *data =
 			&sband->iftype_data[i];


