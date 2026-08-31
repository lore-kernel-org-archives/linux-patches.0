Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2A648382C;
	Mon, 31 Aug 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184842; cv=none; b=sxi/D8XbGjTI08sf59xSIaMDJIDXi7BbEYx/uJDNUjFQg7PQRmTrIrdJxYtq0+OllgZq1QPIOLKXTbV696RLc1aKFpjTTyfQaPezANRPXUKQHqrSHk5VAG8X6QMT+wRgtnksHcEmow8L6HKWZgcF2fCstxeH9ENKU0Gd/GxQQKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184842; c=relaxed/simple;
	bh=Ec6lvPN1XIpXtkvYGpx6/+oEFu+ZJuyNCpOzy9MPKJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7CkOZmnTGL607vQ2lF9wqeNoDp5OKl88UNtM4GviFEcXGMStAJo2sqyRDlb1meuZUn4itvgZtvP6sC/0XxeVNIxmVCpJXU3gXZ02DLAjFoAZaocWCeOwpgYhGOwQQl3MGdDFFI1CXN/ZhoeFHGcWNyVeXDqQWb3t5WpKKzplyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAJjXPnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAJjXPnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AAC1F00A3D;
	Mon, 31 Aug 2026 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184840;
	bh=HdapKoxAuIWKT9SewrQdswibN72Tx8qx1XIYO6gr2l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAJjXPnR0w2XPLgzMxBDrCk0dt13qz1Jo4rabah7h7FzgM/h1j047nwOzs4DU2gT5
	 yYF6P0cUL6oGOEKCtqvLA6jGOzXwbsXC1UPL0T7rMiGYvOWgVKOw0uHsfCH+bMLo9X
	 Ba089QJDxh2k0jxu6nlN984bRK6LJK/i3RHHMhIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/92] Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()
Date: Mon, 31 Aug 2026 15:34:53 +0200
Message-ID: <20260831133402.577118497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit da0186f19a7433d3d5607b0f61e9a3de17d1f721 ]

Use bt_dev_err() instead of bt_dev_dbg() to log error message in
hci_update_event_filter_sync().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: f57b399c4fa1 ("Bluetooth: hci_sync: Fix accept list UAF during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6038,7 +6038,7 @@ static int hci_update_event_filter_sync(
 						 &b->bdaddr,
 						 HCI_CONN_SETUP_AUTO_ON);
 		if (err)
-			bt_dev_dbg(hdev, "Failed to set event filter for %pMR",
+			bt_dev_err(hdev, "Failed to set event filter for %pMR",
 				   &b->bdaddr);
 		else
 			scan = SCAN_PAGE;


