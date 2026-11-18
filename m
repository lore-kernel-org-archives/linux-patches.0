Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027593;
	b=g7WRvNn+xXtrI2iUHZsDJFKX4JRGnMT9HMqXPiMJH5XMHWWWn6fxjNRRqQ3lb3v1G6oJ
	 TQhQ/jcsr9PyQLMmjOEEiEBlmm1985SjkdjU+WNTsAbaKtjO4nxjtBPt4bV1xKJYH3JkU
	 lSuiKymXl+/MFtLwDZmFl4mIYVVon/tT++Kdq/36QceuiA7qIY+ZrBpByNYekSldEGg61
	 aWfSNRRuc6KpZltr11xAqOAAzE+KVOcvjdDyIcuszgVLqjDlgP1nO4/7dgrUBTVZ7GwgQ
	 052W9Ej+BXJjWjM8NqO/35a2ligxpB7Uyv2J67o695EoCKbc1PqdniSib7TmPi1LjoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lpqy6Jmgi6PH/N4tRAFII+6+k9rW2AmHtYMK6WBIqBE=;
	b=46Z+w7z6C7CZxtp9+5qlxeVpzNhVCr0llNiovttL5y4+M1c5ayY1M2pLVBod3jTmz14i
	 9McBt7LFRZh5kxzO95XY/8pEdmfLQuQxNzWIguN3GEZZOpyjEOx0TaPXTpwujHoGSpkb1
	 emw3jlwoop1VvjaTERDCZFUYgKBSPaYyENBzYf8eBdoa+fwWwwBjy8cY6spvP5UCoIpSp
	 gmnCZ8w7Uku/5Iwkuy3lPe7guSfQLvqW4X10qg0TCuUZKwR9qld8BKDkAM1F/1ZFv3XL7
	 M3zyPFy3HY+OV0iKulnFN+djI/yypeBM8DT9+azq0HLVpU2HG8porO1SVvYU+qbvPaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCnMdZUr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F9160A260D;
	Wed, 18 Nov 2026 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCnMdZUr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591681F000C4;
	Wed, 18 Nov 2026 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027592;
	bh=Lpqy6Jmgi6PH/N4tRAFII+6+k9rW2AmHtYMK6WBIqBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCnMdZUrd24zC7ODTXJhjxB8U2l4uOEoTEAzhXoHbWPNM+raGynbmCasiXTtGh8/z
	 Bz5cqXRHg7cuu6L/r3RCWpHeh4mh6SjopePrvy2hMXoReaIhYdBMOE/XctxvfazEtd
	 sd1kY9ZSdQG0E5nzX6XO9vhzQwBFjwukicM6thBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1844/2151] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150228.969594428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit a63bb4d91c784f63ad7c063717dff7920d8445be ]

fsctl_query_iface_info_ioctl() walks idev6->addr_list with a plain
list_for_each_entry() while holding only rtnl_lock(). rtnl does not
serialize all writers of this list: the DAD-failure path
(addrconf_dad_failure -> ipv6_add_addr) can insert addresses without
holding RTNL. It updates idev->addr_list with list_add_tail_rcu() under
write_lock_bh(&idev->lock), so it can race with the unlocked walk.

addr_list is RCU managed, so walk it with list_for_each_entry_rcu()
under rcu_read_lock(), matching the other lockless readers of the list.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Co-developed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b871003341e7c..51218b3c7e8f5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8321,13 +8321,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			if (!idev6)
 				continue;
 
-			list_for_each_entry(ifa, &idev6->addr_list, if_list) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
 				if (ifa->flags & (IFA_F_TENTATIVE |
 							IFA_F_DEPRECATED))
 					continue;
 				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
 				break;
 			}
+			rcu_read_unlock();
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-- 
2.53.0



