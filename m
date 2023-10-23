Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261412B9E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2MZFNMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBA5C433C8;
	Mon, 23 Oct 2023 11:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059357;
	bh=KQGIXsSlZCYxfse2TDgubtirV3RkgeR5KB7wtaDpHME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2MZFNMzyoPsnC4jfxW8WNRVR28ICTb/z9hd2OYFW+fA29KCG4R6effoKr/yQxvkv
	 KsWQIH7ayyfbA30KqFeNz1d2nSnpijs6VngB8nXxGMgNFLpY5XrEmZeg4FkndCH5oG
	 HFsQfzUDh//FiXCnMdIMczgfkvJyIOGwUngqRjMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 124/241] wifi: cfg80211: avoid leaking stack data into trace
Date: Mon, 23 Oct 2023 12:55:10 +0200
Message-ID: <20231023104836.897116571@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 334bf33eec5701a1e4e967bcb7cc8611a998334b ]

If the structure is not initialized then boolean types might be copied
into the tracing data without being initialised. This causes data from
the stack to leak into the trace and also triggers a UBSAN failure which
can easily be avoided here.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20230925171855.a9271ef53b05.I8180bae663984c91a3e036b87f36a640ba409817@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3d286f3a60e60..bf968cdbfbb51 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8502,7 +8502,7 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct mesh_config cfg;
+	struct mesh_config cfg = {};
 	u32 mask;
 	int err;
 
-- 
2.40.1



