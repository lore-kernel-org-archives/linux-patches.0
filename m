Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BF833769A;
	Mon, 18 Aug 2025 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525659; cv=none; b=Jdf5+nDvs5PQR8foY6lBhi2QI/W8WWnYZhrwl8YxGNcd25HzYbwShbfdJM5LBSAI0BLDWIT8a+T6n0vooEy99PWe7ypAkTrA6XKs+/dO2WtSuN58YAddKlvgzRpwBgAcKzxPMhsbW3VLE73ZaAlbEFuhGCf2zenKC19fieJVgGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525659; c=relaxed/simple;
	bh=Rf7ftmioZr45pvG5x0AJOIDdeqIebCeGBcYNfywsJoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI8s2Zb9Ia+rjwCwL62nB1HNx5cw1E0ERoablAgBf4qsFRnc/bz7SWtoNrpLhlIOXfxGOG+zUago7c5TYL+HYII6Evure7htDYssO1QAs0OvgER9ypF60qYUV3t48/3AlsGvY7IZqcJRvUMBc/MKObMJXjXqoWiEmQanAglgNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ab5LAfnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ab5LAfnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55116C4CEEB;
	Mon, 18 Aug 2025 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525659;
	bh=Rf7ftmioZr45pvG5x0AJOIDdeqIebCeGBcYNfywsJoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ab5LAfnFRyb9opQR6oniSwqL5ENZVSl6va5gnIyvnIJz1/xRzpnjU+JthpcJ/uvFd
	 GE1mAsdQ9myUEC+H+WyvtKkIj+g/skidqxP5C4Z9m8QMdLypteADXvv10Sk1tl26dA
	 Kf2jNGybi1IGWlZR80TkNnCGG3fSXgHomSKVSADg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 328/570] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Mon, 18 Aug 2025 14:45:15 +0200
Message-ID: <20250818124518.491319147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 618a973ff8ee..b9f699799cf6 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -259,19 +259,19 @@ vlan_for_each(struct net_device *dev,
 
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



