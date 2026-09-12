Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104FD2F531B;
	Sat, 12 Sep 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225885; cv=none; b=V5X+9n8SjhReBBwl6eGxlARaEP0W+TvCZN4nbfBORm8153SAze1/PrHD05R2a/JDCzLkqCcRmEFaJkSoqcUPpgU2LsvdWPsI9id7tENL3OYHoJv57KQXBC1cP2sPAdon6g4lLDldn9IWpXvEmjzfGhKx35EyzrMYildiqMUemhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225885; c=relaxed/simple;
	bh=OcXRTZYOuCXlBSPptvHkcQqYfOT9T9se6WBMkMyIfYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsVLNfbludlNr7d0U2dPBJyd5RQQ1ZV270TwKtQKi6/ggJxR+DwilS5peeEkvhvz1BdofWuaC6V4TJE27799Bre26BYDtX7WJgq4F5wGCT3PUHct63HyHoSdaj+80dN5QO76DDB4DNpstdvqklEEf5IYHA3gEwGWMvNv67sutX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSTQ/qgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSTQ/qgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15261F000FF;
	Sat, 12 Sep 2026 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225884;
	bh=r3O1Jztr4Dj8g5Hl4TaCNS1PIAXkPYPokqc9Xv3s1oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSTQ/qgpYfFl3M523c/BhdvlCoOemd94ypxRrGI9BL6tpR3lBKcS7PfJ+hHovStfy
	 Snpud+SYsieeUlIqMFdID4HtJgIcBKHOgulxRsNeA7XuqIUkIFZdLCmgaBaw8SitUR
	 If5BXpT/pVvq8ynSu2zM0n0AIYgEicinliaGPVrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1290/1424] bridge: add MDB state mask uAPI attribute
Date: Sat, 12 Sep 2026 09:02:02 +0200
Message-ID: <20260912065636.159556398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit e37a11fca41864c9f652ff81296b82e6f65a4242 ]

Currently, the 'state' field in 'struct br_port_msg' can be set to 1 if
the MDB entry is permanent or 0 if it is temporary. Additional states
might be added in the future.

In a similar fashion to 'NDA_NDM_STATE_MASK', add an MDB state mask uAPI
attribute that will allow the upcoming bulk deletion API to bulk delete
MDB entries with a certain state or any state.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_bridge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2e23f99dc0f15..a5b743a2f7750 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -757,6 +757,7 @@ enum {
 	MDBE_ATTR_VNI,
 	MDBE_ATTR_IFINDEX,
 	MDBE_ATTR_SRC_VNI,
+	MDBE_ATTR_STATE_MASK,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
-- 
2.53.0



