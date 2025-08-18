Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4625A12DDA1;
	Mon, 18 Aug 2025 13:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522203; cv=none; b=EH+QqWSGA+Doth9W9p1kcb4sfyoqQfGRzqVmdqOxk8HGz8XcQwcX/18X6lUaXh/mCucpke9sxY//Vd8nD089SiRzrOByZ50AGuaierW9sne5l9/+1wvYFZ5ccQpOjHvzJOr1QDgX932+BUp02Jld81+Jxr99z0gx8FfRDHSZKAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522203; c=relaxed/simple;
	bh=zfVkHlX24kQHYBm1IvE6p26OBGFEAqmJedXN9A/XdM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWBXTy33Dic9tJ54W5HPyUzqFZO0rIrephg6O57Sr3r8iRu8nvEy4snVzvPPxo5nGGUT5GXDPMKrbEKdMI9RO7LzuDLaaI/I6QHYuLJeBX4BuN4oxJiuaC+y9kijW88w7Ac9I9COhf6acTiZMYWOWBrDOuS1brfjaX4Qj5aZfsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc6VZ4MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc6VZ4MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB15FC4CEEB;
	Mon, 18 Aug 2025 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522203;
	bh=zfVkHlX24kQHYBm1IvE6p26OBGFEAqmJedXN9A/XdM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nc6VZ4MIOX1IayYPYtYU6923AU6fFxaPHSREsJ75rhENMsh6YtBJPiTMdyfRSBIjx
	 Aloe3OE9roT7DM9LFKfwfL7TybP1dlzv/879TcYcOANpQDj4iX5VS7qRB80ZmEKrJ7
	 lbWkRNnLzn/5DFNwbGiVcuwstL9hvClRqmQbE+Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/444] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Mon, 18 Aug 2025 14:44:32 +0200
Message-ID: <20250818124458.052180340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4354f6ad8887..9551dba15cc2 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -258,19 +258,19 @@ vlan_for_each(struct net_device *dev,
 
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



