Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590A19049B;
	Mon, 23 Jun 2025 21:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715663; cv=none; b=NzIFOn3JnpxRNVHDSro/mw2t0XVgzijR0qHKEyGK4dtFoHVLhp3ECHp2/pOvHn7E4C/zTW7zByatIMcff9pjv+OS5IY21aSeGaWXM44LgLCdTGMDbQK2rHUxvqFjyFZKdYqglbEYMn1YmkkaRkOpcLNNIDiZWhTr2qpXSOfQXRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715663; c=relaxed/simple;
	bh=ZRB/zp/sEPMPwxoHIsEtQ44HdAGo1TAb1bDs/hafttk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USSLHsAD7a3sLucFxbdRvjws1/LZwB+Omgwf3wqfQzAfD0W4txWk4y5jk9QJb4wB4SS/gyCueb710asdOVz1aGiDZKDNv8rNYREj+54XRmV44XrzMp/BE6y0N31mDDBBL40+jf9RlHV6Nrcf1sWTWKRfGa7GmzpsDQL9Edp10c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpWeJmNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpWeJmNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA819C4CEEA;
	Mon, 23 Jun 2025 21:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715663;
	bh=ZRB/zp/sEPMPwxoHIsEtQ44HdAGo1TAb1bDs/hafttk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpWeJmNwWpze4KKFFsZbg8Ht6CZIl5wPUCUixF6+OTC9dpKB5LsVLI0L99Qok1Q7A
	 /OEZFCBBfVGnNxAJl/dLGLL/V4irjftH8mE+wWgw0F3Tjrg2nqpSrQylPcDYndI39k
	 iskBRQqscd66nN8jCXIHC/lWq0JCGQH/B9N4ICnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/508] Bluetooth: MGMT: Fix sparse errors
Date: Mon, 23 Jun 2025 15:04:59 +0200
Message-ID: <20250623130651.502798009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7dd38ba4acbea9875b4ee061e20a26413e39d9f4 ]

This fixes the following errors:

net/bluetooth/mgmt.c:5400:59: sparse: sparse: incorrect type in argument 3
(different base types) @@     expected unsigned short [usertype] handle @@
got restricted __le16 [usertype] monitor_handle @@
net/bluetooth/mgmt.c:5400:59: sparse:     expected unsigned short [usertype] handle
net/bluetooth/mgmt.c:5400:59: sparse:     got restricted __le16 [usertype] monitor_handle

Fixes: e6ed54e86aae ("Bluetooth: MGMT: Fix UAF on mgmt_remove_adv_monitor_complete")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506060347.ux2O1p7L-lkp@intel.com/
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 123cf62e3c000..08bb78ba988d8 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5237,11 +5237,11 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
 }
 
 static void mgmt_adv_monitor_removed(struct sock *sk, struct hci_dev *hdev,
-				     u16 handle)
+				     __le16 handle)
 {
 	struct mgmt_ev_adv_monitor_removed ev;
 
-	ev.monitor_handle = cpu_to_le16(handle);
+	ev.monitor_handle = handle;
 
 	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk);
 }
-- 
2.39.5



