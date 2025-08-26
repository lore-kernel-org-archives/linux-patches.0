Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31359350857;
	Tue, 26 Aug 2025 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219110; cv=none; b=Tm1ZKZLR9m4m7x0O0JgH0TBGhvJ7pVouZmk375CZ6ut7zq6gxFpeq5hkSITRY0g2BLVGVZgmQOExZvxfsrKn8BWA7tW6ve0vw/y4EbZiIE/1G4awiSpCO2KfBmnFmXFEm1JJcAT7XaDe7DBYx6dNEboT8UHmN/XUPbxWPEP/sKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219110; c=relaxed/simple;
	bh=td8k8FgYoalC6gFM1G2qRWVYGmPj4Zp8Nk/MZcRDwOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HldXc+Dtnk3YHOl5zOgf1/aKzmGHxW7TsfttOJcnPsewtprHadYqMRyW8jg1BOB4073PsWJeSgm7jb90/tROXCBmjtpHyml7NNnXwk2tFtR8X6o9WV7zRjmK/zqXcgOmboAXEpj88BXRRQamM457DDOrRVCIV5RqBny+CAxnF+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8E6eI21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8E6eI21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E8DC4CEF1;
	Tue, 26 Aug 2025 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219110;
	bh=td8k8FgYoalC6gFM1G2qRWVYGmPj4Zp8Nk/MZcRDwOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8E6eI21c0cTyk6rsV1VI3kgtN6NtCJR1elsopqhkHWy7AKsOb/QgCAQYSWxGR5tT
	 oQm2IW00aHxuMhyb4gsZK/x8aHB43ujltu1y6y5JyhLrD1mTtOT940D8tMlSDw8WS7
	 LA7/bgebSHb+11Oy6akxVJ1CXJvN2mdi4VxO6HEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/403] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Tue, 26 Aug 2025 13:09:11 +0200
Message-ID: <20250826110913.045200810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b3dae069bcd9..52ce74226ba2 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -240,19 +240,19 @@ vlan_for_each(struct net_device *dev,
 
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



