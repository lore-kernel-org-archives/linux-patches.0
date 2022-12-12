Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60D28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED3BC433EF;
	Mon, 12 Dec 2022 13:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852947;
	bh=R0qKGljzn4Qgb7oMrILuRWSoS93ytflK04KcgXieFG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZDDTYpfx63Tb1jBHDbAI7yLD8P4qPsa3citJgP6adh8VcfEPQYGadUC5BhbNEcYo
	 RRVPteH7dbp386x3kA0P9DMV/FnfGjr/HzmxPDvsiFSzV22bRppmo+TNHw2ugyjjSs
	 Sg6RM5NcdrLy0/Ah+Q0rYiSvhUF2vmNftvFqvx7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/49] Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
Date: Mon, 12 Dec 2022 14:19:05 +0100
Message-Id: <20221212130915.017328531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 747da1308bdd5021409974f9180f0d8ece53d142 ]

hci_get_route() takes reference, we should use hci_dev_put() to release
it when not need anymore.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 9a75f9b00b51..4530ffb2481a 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1014,6 +1014,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
-- 
2.35.1



