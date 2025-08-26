Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B8A350D6A;
	Tue, 26 Aug 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217801; cv=none; b=iLcVU5zsQg5WXnoS3Pbko8irgDWvGyktjGciuC0i9+WX1uHILf3FxRcb2WfCs/xVVb2qLGelr/Bbqbh+TXu6XEjmGOSoANX/INO68QfR/8B3h3l0x6SEvTjn/3wgOX+wwXO4fdKRg4ZpxbFQKq8Joz2f/O9IboQ6tJGkO/kW0Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217801; c=relaxed/simple;
	bh=13NA/SCX+kJD1FqlT/sl3u27lCoPCw5FEr2gSJGnyl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyi4s8BkuesiRY5KBmGW+3eV2NZR9rUC3ESCopg369XY0OEG8P6MZa5ZviMrVFdGqTaPd6Km40dGHgzbYSF3ZQ5Xo9kjqki0USqbTDNpsoKM6w4II/OXRCsIy3dWi8sbPYU1zm09C4q46CxIUvZwWWRANuOb/s/Y7h2k8vnYtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaNSo3xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaNSo3xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A69C4CEF1;
	Tue, 26 Aug 2025 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217800;
	bh=13NA/SCX+kJD1FqlT/sl3u27lCoPCw5FEr2gSJGnyl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaNSo3xy2YIxvd/BJvKNG6gjmH6YW+2cJjhF4emnwuyconDDgP5+AZvuNsQGnHzEG
	 x9GuJfXvXIvouOM1xaapG+to05SXwT8q1oLZcJGxAda3AXOaXgwR5Pfvd1bQ1aZ7tV
	 ND36/xw3cSh4X9yUDYA0bQHuOLFlmieMa5tLI9p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/523] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Tue, 26 Aug 2025 13:08:10 +0200
Message-ID: <20250826110931.342010577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 64cfe7cd292c..3728e3978f83 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -248,19 +248,19 @@ vlan_for_each(struct net_device *dev,
 
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



