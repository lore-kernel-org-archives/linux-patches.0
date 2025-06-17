Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E142EE619;
	Tue, 17 Jun 2025 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176882; cv=none; b=hRsSdsvy5egji6MNGROmKSFhLv1jmFSTynlO41RkcXDlhqMXnlF0frQjBBVyYHhqXTgVcpcbNrT4duQFgKWdSvdT0FQY7aoDF007lvYlu2CKlPxE/IRftFQ6LJrZ4pR/qijthg82091/n/Plk5iEj246f3U1MN8oqL3FBJ5HDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176882; c=relaxed/simple;
	bh=17R0wA4qy37mxhQz0+YJfCeaMMOh2VBk7ZGbNEGjqks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYMajnxOVCHFF6ZDqj8OaHVHM2dL+gORE01+oWLbUoy+yTE5dNpdrgUtnMqWViSkJIOSMlZh9izkBr7FCVZUrjzUOXm4ePv4EWbjZmJ7AtzQxUwBYZax6RwEBrCqsk3euDpw+4I+unNresox4J+DFvXmeCnnPNWSzs0Zjwu/F8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dZHzciB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dZHzciB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FE9C4CEE3;
	Tue, 17 Jun 2025 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176881;
	bh=17R0wA4qy37mxhQz0+YJfCeaMMOh2VBk7ZGbNEGjqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dZHzciBeZrYSm276I9I/6BKVVyhL0BupUeB5B+PaIUd3T00AydeZZlLj+vuuJEah
	 EOvYx9DeVt3zNHs71glVUqvu6vwAQmzGWGhCW0BrlSDhx3rDuWRW7tKbVHlPF2Otxk
	 MfXwgXBcQd9AL8Ozas7Fj849lVFVd8F1Sizfb/2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/356] Bluetooth: MGMT: Fix sparse errors
Date: Tue, 17 Jun 2025 17:27:17 +0200
Message-ID: <20250617152351.116370742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44174f59b31e6..853d217cabc91 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5159,11 +5159,11 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
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



