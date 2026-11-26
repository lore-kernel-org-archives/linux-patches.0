Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705093;
	b=dHUrKRE4ug9dqcXHMyS2ACNKl9rjKy6OKzHsm3W2siSJFZmrSctfTpSVQ92pDAROohAM
	 We7q8djzBAZ+bMNDIPAIHoEOlES5ZSEdMIRP+32HAebbmEOYOnFNEMgfX8XDrK7mmBoNW
	 ZOLkICTQ4kB6pyiquJgnBdQWM6D2i2zLTJzJzBiyeIca6NQ5mishxSgQk9ta0Y5e3jp6v
	 hL89RnbOhugzAMCidISJ01UPw0EwIqmX3dBdi+LP45W+APcLngtT3vxBgYgOhvRcYm5hU
	 5QoR7S+Nh0w62bfv0P9C1N8TpB6mcc9fwYkC/D2ZipHdLpQLp0INk2RaDf5kUxpzAtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wngRPpLb1dQEneINKb0qoHLrT+MDlMOAWWBQVVoZ+R4=;
	b=VxCqRc13ZuWj+MFVB81lvedTknnBiQgQNG6z58J4wUo4Izfd5/YGHGYKN4Cmtl19HSAo
	 k48Tp5kgaryBhV7Hg8/U5Rpqy+QPMveR0WkTGgfhqm73ClTRXQdmGteY6BqlYH+FNp+LD
	 c5MzLQx8Oe2occjFylcTmSkAk/pxyntnyI/xbrSIICQJyTGqCKG3PbiwB7urQ5quTLvqe
	 2M0yjo+3Lv0+fjPnO2KQv79PuSUufJ551Jb8L0CD3e047qa3BNB3f3S1dn4WA/YcQelrl
	 42nsmUAA8p1jREZLnCtlTfR49dk1FZ9TJuzW85GxmG3AgxZl0rUt9QesFoD6yLNZQDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qG3C4Qbf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A2606A31E;
	Thu, 26 Nov 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qG3C4Qbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD8C1F000C4;
	Thu, 26 Nov 2026 14:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705092;
	bh=wngRPpLb1dQEneINKb0qoHLrT+MDlMOAWWBQVVoZ+R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qG3C4QbfqlBfmIhhc4VtUh7fU+cXBP4m9LyN+kKMN7ql+9BKF4QdRIvLOoVH96UlW
	 W8DCGEOg6f7FRgfWJQXf+zV9Z8Vn6POtdDZRNb1I89NwkqqBwrT412/4O6MVXs1xRZ
	 XWnVxWNN45Y6DNPOZzzbZ494je14/5UmwP3vNsxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/319] tipc: reject attaching bearer of different media to the same occupied device
Date: Thu, 26 Nov 2026 15:36:43 +0100
Message-ID: <20261126144007.532250974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e72318f1a4183..58544cc62fef5 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -287,17 +287,50 @@ static int tipc_enable_bearer(struct net *net, const char *name,
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



