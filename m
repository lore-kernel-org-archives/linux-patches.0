Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5EE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B53C433EF;
	Wed, 28 Dec 2022 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241012;
	bh=oDdBjHRqDV6DkjrLZrQCVMNACC27WqlqIX2ZOprd9AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxyr8f4J7UZcrjYuMVvBXjptwpsHYe9jb1q5zA8GbNXmdWg0N3KwLxb2RpLg3OQEc
	 Pn3eG+V9HLrMgNc1wgQh5/zcoPhkqxghFzGaQNPt/VxDkrpkwp3a05mllI6vPSJXUH
	 yygn7PlYBGoWbZG6VAWfJCiVJGcY28KxJvm+ui+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0195/1146] wifi: fix multi-link element subelement iteration
Date: Wed, 28 Dec 2022 15:28:54 +0100
Message-Id: <20221228144335.442737586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1177aaa7fe9373c762cd5bf5f5de8517bac989d5 ]

The subelements obviously start after the common data, including
the common multi-link element structure definition itself. This
bug was possibly just hidden by the higher bits of the control
being set to 0, so the iteration just found one bogus element
and most of the code could continue anyway.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 79690938d9a2..d3088666f3f4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4594,7 +4594,7 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 		return 0;
 	}
 
-	return common + mle->variable[0];
+	return sizeof(*mle) + common + mle->variable[0];
 }
 
 /**
-- 
2.35.1



