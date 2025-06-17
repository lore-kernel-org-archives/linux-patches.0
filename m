Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA721E1C22;
	Tue, 17 Jun 2025 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178192; cv=none; b=sGXLcOMOEZQttwz8kNYR5j62MocyVHly7Ous3cew27LSn7M+fCSAtHltZ5KomsUyQnVnhUbwJXvRvbJ2pSfYA3kMcSlGUEsYLWxNsAun9vBbMOTrrm0QGZ6P0uuO5rq4YLuT5MWKLeeGFf/ivJbjZVvywPTVcEZPcXRjgc7Pvoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178192; c=relaxed/simple;
	bh=Tl/aydMS4sPc9pvGBza4i9R/ow6k9ZAFIh66RX3QQl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj55UDRR9W7Rh4PCgwprSBRvRsvqYXfLpEBmekJnD/RxAaV+xUWsfXQTcXqZfnqQ3L94VOWhpjrOlHm+sNsYMyhU+ds4DUvfDnOYsQkmPghUoIXx59rZ/VyqNPZhfUXS4utzeo0LhLt/A0TA762hoApMm7L2y1WEEY3cU7eHPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o65BFwO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o65BFwO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1FFC4CEE3;
	Tue, 17 Jun 2025 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178192;
	bh=Tl/aydMS4sPc9pvGBza4i9R/ow6k9ZAFIh66RX3QQl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o65BFwO5MokfDNDRLC7X6flHLf3BCdk8LZNQXtuODs3UmysI7iXqoovYPvrkARgua
	 hZNF/DiPpu4zJONgu0qszKOfEYpMkoixFM5cvvqKlgCA8uPFz1NGkfCiEo0V3+Ix6M
	 y1bQkpS49ywXcAT+GMwpMWnzkH90YSbmBk3IJEFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/512] Bluetooth: MGMT: Fix sparse errors
Date: Tue, 17 Jun 2025 17:27:05 +0200
Message-ID: <20250617152438.170431326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 70a26c895512f..7664e7ba372ce 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5166,11 +5166,11 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
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



