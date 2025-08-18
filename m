Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354E7321448;
	Mon, 18 Aug 2025 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523879; cv=none; b=ZngwC7c7BL229RFquDd+fLTTnT677sATgUFAvxr7PZakYBkwgrXciYRdU3zvBk1VvnDEIlijEDLrJlvGfsWZjvHdH65uS9WDOSGm6F8ikwLVb/NdZ5sDxwIDQWUal/GnVPXnSaBgdIV9IDy5u3vU5ItVSi4TJlBvV0a3eOwGEK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523879; c=relaxed/simple;
	bh=qeitXLSkXM0Gmsbwk2euZtGr69W/vfmRfRqNu3Zs4uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np/m41pt8vC+6B5Z28spFkcHdNTOp42IUfZqMPwIdm5wK+DlmIn40LaM85t9tBNXhkiliagjfdKH9LDo+hsrreYGlIDHCs4HtDWMUZWPraYCGuPokE7WCLE2q2mpf65oxZ2cz0tfdUx5+DnbeV+fVIGy4GYvihM4Ax25kEyxl5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xx1jjE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xx1jjE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4922FC4CEEB;
	Mon, 18 Aug 2025 13:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523878;
	bh=qeitXLSkXM0Gmsbwk2euZtGr69W/vfmRfRqNu3Zs4uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xx1jjE+LE3aPzOm0zBFiHkBYNowqLVgN0VLGHn+X6YuNRtwl0oQIjv7kk6/YdU8d
	 L1NGy9XK5S3CmPOmYoeEVVOZf6ztSRGiawiixx1YLr+RwaewbQ/ng9AKU45lCzhUSl
	 iVptxog3giIaFNw2f+lgVW2jtJJYURklALOoncwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 301/515] net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs
Date: Mon, 18 Aug 2025 14:44:47 +0200
Message-ID: <20250818124510.017330341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



