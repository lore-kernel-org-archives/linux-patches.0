Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A32F23FC41;
	Tue, 26 Aug 2025 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214567; cv=none; b=nKsWpjhzkW8RDXDncKQ3xui37tZSBaf4EQxUWEK4gThWQkFbmSYUUYU5aPjAZJBhz4USX0ixEty67Q+TdTv//XO2EvLTaI/iCoDiHRDLOmJInK3dKLjgBzR450RcQnOgGKEVoLYMSz34h6GPRktM6jKZUqKZ8uxnLatOjjrP4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214567; c=relaxed/simple;
	bh=cgNWnGYeNOsvMpzayROKu1PR43kTSzq7MvX0k5+tDzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVei4QwU30py99ZMXISeDJAYsr3iQMXUf+uunXkJ1vVU1ABmtnRaxUvWnJeAbYCSOUq5fSgjV5eRFAPT2TL77PA7Z7OfWPQcO6TS/ct4oHIo0XjCxbzqrYUo2i3Zio9AxUDeIbzHjCTDaIcGL9E8a4QOv+jUprhm4iVDjfOszhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIFoKV55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIFoKV55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8DAC4CEF1;
	Tue, 26 Aug 2025 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214567;
	bh=cgNWnGYeNOsvMpzayROKu1PR43kTSzq7MvX0k5+tDzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIFoKV55PdtT2u/InYRSJEOwdM3EWlmxClvwFHcZHc9v3Nn9os6R6sIdJmrETWkcn
	 xk9YJ0RbTHyGk4rg2XMTHl9qkuYzmY/Szj0JEXlw6RQ4xdao0Iv1Rf72oaoo77es7Y
	 eIn9YsMXC5wjjoJjoPVx79rqkNNRPEEutk04A/D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/482] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Tue, 26 Aug 2025 13:06:49 +0200
Message-ID: <20250826110934.667627222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 60a8b1a5d0824afda869f18dc0ecfe72f8dfda42 ]

When CONFIG_VLAN_8021Q=n, a set of stub helpers are used, three of these
helpers use BUG() unconditionally.

This code should not be reached, as callers of these functions should
always check for is_vlan_dev() first, but the usage of BUG() is not
recommended, replace it with WARN_ON() instead.

Reviewed-by: Alex Lazar <alazar@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20250616132626.1749331-3-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 9f7dbbb34094..f4eb8dd7308a 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -253,19 +253,19 @@ vlan_for_each(struct net_device *dev,
 
 static inline struct net_device *vlan_dev_real_dev(const struct net_device *dev)
 {
-	BUG();
+	WARN_ON_ONCE(1);
 	return NULL;
 }
 
 static inline u16 vlan_dev_vlan_id(const struct net_device *dev)
 {
-	BUG();
+	WARN_ON_ONCE(1);
 	return 0;
 }
 
 static inline __be16 vlan_dev_vlan_proto(const struct net_device *dev)
 {
-	BUG();
+	WARN_ON_ONCE(1);
 	return 0;
 }
 
-- 
2.39.5



