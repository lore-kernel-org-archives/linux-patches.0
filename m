Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CFDC433D2;
	Mon, 12 Dec 2022 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853379;
	bh=s8UTlsTHL+spmWejxSsGUWv+45uvXAz/KIpq6sKLYCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jm7/I1I0ItMtwZHrgzYzqeWbdun8zTy3VsnJ1ExLZ5iiPuKQq5e8Hto5aLa2Cs8RL
	 NwFygEKE77Qg7Ztc3ZfzxUaTDGjyxtP3APhaxVxKNEK/KHupNbsJJ1ZL0tl6YB0eiG
	 nNqpx34mYsxrqQ8sAIiOUMKxXZLxZtjCy9rzDxj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/31] Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
Date: Mon, 12 Dec 2022 14:19:37 +0100
Message-Id: <20221212130911.054924945@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
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
index 3bfd747aa515..4a29410f5abc 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1119,6 +1119,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
-- 
2.35.1



