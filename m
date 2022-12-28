Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655F4C433EF;
	Wed, 28 Dec 2022 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240817;
	bh=DaTVzkMLITirh9+cuKYTn3zonT7QupSNy4dL1ilEick=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaeY0K1QFhTyi+JlP1C4NZ+RDKzY6Vm6a+ps8Iu4StbP5j0jFU/FpT/E0VxaABOhE
	 Axq9YFuee9E8gztc85QTCyFHXx8x0gWMVogt0SncjCV2xIW5T885GAurMGgKUgz0f3
	 qpL46uLjX7S7dbnP5837zxuc+OFkPL2oouC5UzHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0188/1073] wifi: fix multi-link element subelement iteration
Date: Wed, 28 Dec 2022 15:29:36 +0100
Message-Id: <20221228144333.117577755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index b6e6d5b40774..181e758c70c1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4588,7 +4588,7 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 		return 0;
 	}
 
-	return common + mle->variable[0];
+	return sizeof(*mle) + common + mle->variable[0];
 }
 
 /**
-- 
2.35.1



