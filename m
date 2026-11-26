Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704181;
	b=FiEKlI15LilyerWGi6VeSnMuUSIbQ/qwM0kLv4pBFbjj82ImEjJuKe4Y+BT8cPIAKzVl
	 ovSlX+kH51hb8b5+OpSkFk/151QzGPquxgUBKMcjPx3xNWb2+5azRiXwRRqP9P5HZ4vTq
	 G9liIabG/UcEPcmOlA7Ph3KPpawJoWpesudHegR9TJy1j3dT2hnGbp1XFXzbsdOR28yYq
	 ixblNimSs3vxPHOsl0VdOG21om1nISWeX7K9W1A3I7IMnPMBycmGhyIrT1sYOR4OR3xlR
	 jW90+13n+FnBJyTfcEAR+OIGqnuIScU2IQdtxn+Fo9ZQ61pyQzL5+BDAWPzG6+/StIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eup4fnElZtV/Sli8vKdD5q7me0YgU+JO7vq4bcGJy8Q=;
	b=vtmEX/NMrveKtTnAuq807G14gsMMJY+lUpzTev/9pf5K2rNNgQzriTYx2BZnJcisKaFq
	 s1KhT8F20gUtTTrQRWGm2+QJF2YERtRH4aN+JxxurnuN2i/TzALUsZrqOFkUBkR9yH5n+
	 9EdvrBNlHxRpg6TLGsRKhBxAwvVTgf3OZh84xyuk+NGuqM7MBYooUrROzil0B2MKa9dBo
	 RZBOqcpG7hQ/HWbG/CKYpjycSSUCZLbUZZZCj/h0n1StBEzK3DkVS45hRe/xgRTmPcJLM
	 BvVEY5u6WpL2TnDszuhSNrcbuFor2HBgWEbh2uGHyiq0AK+uEaupd4ff5jGJzWjQ+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RL3emZtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B77606A31E;
	Thu, 26 Nov 2026 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RL3emZtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6CA1F000CA;
	Thu, 26 Nov 2026 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704180;
	bh=Eup4fnElZtV/Sli8vKdD5q7me0YgU+JO7vq4bcGJy8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RL3emZtkaVvzeQ28DI3PTI74sLwmRvK/MYKCj82i7eDpPUPtXKS8o3ZhQp4nIiaaJ
	 vlLuX/O6PlByX/AP9RtYAQrD+DVQgCI/NTv758wKFnbG6Sx6TsKGhUlFl5NdwWdv1B
	 azAMF2XZLxANtYWS2wPufzephuMRW83ILFjG/77c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/265] tipc: reject attaching bearer of different media to the same occupied device
Date: Thu, 26 Nov 2026 15:36:03 +0100
Message-ID: <20261126143607.421638803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit 0a0257228be902ff09608bcaf19ae7c6d58b028f ]

Currently, two bearers of different media types can be added to the
same device (e.g., "eth:eth0" and "ib:eth0") via tipc command:

tipc bearer enable media eth dev eth0
tipc bearer enable media ib dev eth0

For each command execution, tipc_enable_l2_media() is called:

tipc_enable_l2_media()
 dev_get_by_name()
  dev_hold()

As a result, device->dev_refcnt is incremented twice, but the second
bearer replaces the first one. This causes a leak in device->dev_refcnt.

Fix this by rejecting a bearer with a different media type when the
device is already occupied.

Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
Reported-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Closes: http://lore.kernel.org/netdev/20260918013509.1853952-1-xujiakai24@mails.ucas.ac.cn/
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20261029030522.8306-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index fe56328d4ff43..76fbb3b8f8c65 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -277,17 +277,50 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	bearer_id = MAX_BEARERS;
 	i = MAX_BEARERS;
 	while (i-- != 0) {
+		struct net_device *dev;
+
 		b = rtnl_dereference(tn->bearer_list[i]);
 		if (!b) {
 			bearer_id = i;
 			continue;
 		}
 		if (!strcmp(name, b->name)) {
+duplicate:
 			errstr = "already enabled";
 			NL_SET_ERR_MSG(extack, "Already enabled");
 			goto rejected;
 		}
 
+		/* udp media can be used together with any media */
+		if (b->media->type_id == TIPC_MEDIA_TYPE_UDP ||
+		    m->type_id == TIPC_MEDIA_TYPE_UDP)
+			goto priority;
+
+		dev = __dev_get_by_name(net, b_names.if_name);
+
+		if (!dev) {
+			res = -ENODEV;
+			errstr = "no device for the media";
+			NL_SET_ERR_MSG(extack, "No device for the media");
+			goto rejected;
+		}
+
+		if (rtnl_dereference(b->media_ptr) == dev) {
+			char *dev_name = strchr((const char *)b->name, ':') + 1;
+
+			/* Not allow altname of occupied device */
+			if (strcmp(dev_name, b_names.if_name) &&
+			    b->media->type_id == m->type_id)
+				goto duplicate;
+
+			/* Not allow eth and ib to attach to the same device */
+			errstr = "same dev for different media";
+			NL_SET_ERR_MSG(extack,
+				       "Same dev for different media");
+			goto rejected;
+		}
+
+priority:
 		if (b->priority == prio &&
 		    (++with_this_prio > 2)) {
 			pr_warn("Bearer <%s>: already 2 bearers with priority %u\n",
-- 
2.53.0



