Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80B4482C2;
	Wed, 20 Dec 2023 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJhjlhHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5647C433C8;
	Wed, 20 Dec 2023 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088697;
	bh=SZkJeYUPn+dqRpHaCczTTFvhnS4uGIHbvx5pA7uQvVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJhjlhHSr4kTe0JaQgxyIrPRr4V6/u0h4II606ZfFhZFaTGcHqulu26fGjrGPgCy7
	 mKVTIa7noeJTfI0FY1RamWb1fI6s/Rn8XRhWMV8lYCRKoXb+ZLIHosZzWVNXg6IAmS
	 FCw4Pqx167P6/H1tkvREZ8dD4G9PTiFCH83Ypsk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tobias Klauser <tklauser@distanz.ch>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 025/159] ksmbd: use netif_is_bridge_port
Date: Wed, 20 Dec 2023 17:08:10 +0100
Message-ID: <20231220160932.449286845@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit 1b699bf3a8786f7d41eebd9f6ba673185fa5b6bd ]

Use netif_is_bridge_port defined in <linux/netdevice.h> instead of
open-coding it.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -505,7 +505,7 @@ static int ksmbd_netdev_event(struct not
 
 	switch (event) {
 	case NETDEV_UP:
-		if (netdev->priv_flags & IFF_BRIDGE_PORT)
+		if (netif_is_bridge_port(netdev))
 			return NOTIFY_OK;
 
 		list_for_each_entry(iface, &iface_list, entry) {
@@ -614,7 +614,7 @@ int ksmbd_tcp_set_interfaces(char *ifc_l
 
 		rtnl_lock();
 		for_each_netdev(&init_net, netdev) {
-			if (netdev->priv_flags & IFF_BRIDGE_PORT)
+			if (netif_is_bridge_port(netdev))
 				continue;
 			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL)))
 				return -ENOMEM;


