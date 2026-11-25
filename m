Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617834;
	b=SymH/BJwUk3E81p1KAKn0RATW3c1h3bitwxdSf6FsGWk+L6Zx5Lnbn9VYQNwBF5quTOO
	 r0j+qvNrYzsPIFZcMp9T4icO/N279FKvd0xQ5dXrkycd7CgdgqEbXnWxlwlF+ieAG3qyu
	 vNruzFfONMjrBEGMHCYuO1NuAaNmfEhQVNdfDdp+ohXVx4MjVBiE1NLCNxZm3mwlmZOTf
	 twrAQrbo1cSYOssRk8gQB2bwQFaz2k2PPlj5sSQY/nyQeuWVVEVii8FRPVxCCIJvRepOf
	 aiOnHJxGsZDGGIYkFkYfuxgb7WKIZDUz5tyHKZh8u0TdOFeF+UkU/HGWsfZVeWAwi3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uD0knY5KOQyd22rMVXDkQLk3ruFHLQJ6K2Skdq9tEcw=;
	b=HrEg51xvnFUqH+qkR/zxNENkq8MvOpvcVUmS0KoQk0A1I8TF+uYicyrqqQF03wmtP8sZ
	 aD7y+K/NB/kIiApSkfb7JU+kAbTKIUII9dISybiYaqfG3UIkW4jdbaTCsWZS/2xjTvGQ6
	 NWwi+QDcMpLQjgRDfWd0ooWwdoWLzEZZSp6iZlVnkqb0wqOSnCn8SoBL/g3wleH2V6H7W
	 UPiNObCSoL+2R1y0dBIVH3X/K8/LE6+XBRXfJ1xOb4yF+yzQAyHyM6paXXi7WtYqt59kq
	 c+EYGPED8QJN3t7ueAYP4QGpT2T6mV0Y1rX4yoDA56N3mt6q3JgJEMz1HXVbGO9tjPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrFNdmRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D06606A329;
	Wed, 25 Nov 2026 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrFNdmRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2241F000CA;
	Wed, 25 Nov 2026 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617833;
	bh=uD0knY5KOQyd22rMVXDkQLk3ruFHLQJ6K2Skdq9tEcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrFNdmRaklvoPfo8jks+G6hsvq5qramwWDr85KSRtd1Y9qo+dpQaZSDAGszywE/N/
	 yy+bvX10LKy1lZlzM1HcelfGmjFh1xrNnTvpSrGcFVT5PimkG7vgp0fWrwPHFqOFUl
	 T/yt7DDLhhsqcWD3r/bXmSZH5QDImugoHpFSBmVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0089/1005] tipc: reject attaching bearer of different media to the same occupied device
Date: Wed, 25 Nov 2026 15:23:47 +0100
Message-ID: <20261125143823.825719182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5e7e220fa7f5a..d041a1a7c6dc4 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -285,17 +285,50 @@ static int tipc_enable_bearer(struct net *net, const char *name,
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



