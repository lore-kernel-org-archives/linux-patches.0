Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031C79DD;
	Sat, 30 Dec 2023 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8Q84klg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78455C433C8;
	Sat, 30 Dec 2023 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937681;
	bh=VpyEVfwUeF3FjymCcOuIIwGokVBl0NYUnVNsPEBin+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8Q84klgokabNO/pEnYzP1C9KPRgm1nq2wHQqayz0cbOdiCGUr5gPZtwgpHRQee9d
	 LSbydotaugg1d/++yAV8xN6+BHG9DHaSYQjWRjNnsbHB2XS/S8fCu0u4AIAmUQN+AD
	 AVFBVTcjtqK5py6mcdcCmQ04yeyjvqSMow8+ErWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/156] wifi: ieee80211: dont require protected vendor action frames
Date: Sat, 30 Dec 2023 11:57:55 +0000
Message-ID: <20231230115813.063775600@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 98fb9b9680c9f3895ced02d6a73e27f5d7b5892b ]

For vendor action frames, whether a protected one should be
used or not is clearly up to the individual vendor and frame,
so even though a protected dual is defined, it may not get
used. Thus, don't require protection for vendor action frames
when they're used in a connection.

Since we obviously don't process frames unknown to the kernel
in the kernel, it may makes sense to invert this list to have
all the ones the kernel processes and knows to be requiring
protection, but that'd be a different change.

Fixes: 91535613b609 ("wifi: mac80211: don't drop all unprotected public action frames")
Reported-by: Jouni Malinen <j@w1.fi>
Link: https://msgid.link/20231206223801.f6a2cf4e67ec.Ifa6acc774bd67801d3dafb405278f297683187aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b24fb80782c5a..2b0a73cb7cbb0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4381,7 +4381,8 @@ ieee80211_is_protected_dual_of_public_action(struct sk_buff *skb)
 		action != WLAN_PUB_ACTION_LOC_TRACK_NOTI &&
 		action != WLAN_PUB_ACTION_FTM_REQUEST &&
 		action != WLAN_PUB_ACTION_FTM_RESPONSE &&
-		action != WLAN_PUB_ACTION_FILS_DISCOVERY;
+		action != WLAN_PUB_ACTION_FILS_DISCOVERY &&
+		action != WLAN_PUB_ACTION_VENDOR_SPECIFIC;
 }
 
 /**
-- 
2.43.0



