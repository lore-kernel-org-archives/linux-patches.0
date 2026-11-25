Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621055;
	b=Z1zhoSK3Maa9WoZAboPdp7tJ3vo49EOfcMdfzXwUhaVrKabcQmaTeIf0x0EdysQPcg9k
	 +LGES+faT1bsO9+TdSIzep3OD8rUnSBBavOOCKyGJAEEGhhxzoMkDTaFTAJIG58xkP+uE
	 JAGxsZ0zM1mYK7Uhpf31EAs8a4UkSmI+s9A5J1+wBtgPHDX+E6N731K10UVKLtSVJXPjY
	 c225P0dUEayVC0NkN86w4Mkyl37pEgsrjUj0S1OPFCbmIbCETeYCocezJWmu7vzWN4QRu
	 LDymWHZE2+2YhdOaBcKPEvs6Tk/32kNFHFDvp9Rybh8nZGUNfCnYy0Cffg9P6ZtGsdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NK07AabU1HqglQiNAAr67HJiADxWxGEo2/MSRavjdUs=;
	b=HvE+HZ0S/NWu8NY3/Qs6UpIov3F5aJ0de8GmViJJ1TtDA3rGTG2pCancC8LNmks/8VTg
	 GM9OSD8JxbX2pdaQCQwD/u5JwQrxlunU6lKhk1JjId2XOFI7JnNoJVJPdSzprsPMJSaaz
	 WfIYVUT8fs8by50ARqj1MgTXy5t0Jd2mrFfjoNI/fDqi9WFitDM4c0CoW0xCiHamduOG7
	 oWbM6iwIWG+8Ji41eiRkuB1CgAqXdgdtTgTykeGjFx53DOzy5b/5+Zo0MPl3oO9ER2SM9
	 LfJCbyaz/3kq/cyDwquu2cHpwZdMCVr25sXOtKlJSf/qhuktnlJ/NZdmWQ/dp30bqZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2qEMaHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA8606A32C;
	Wed, 25 Nov 2026 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2qEMaHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A81F000C6;
	Wed, 25 Nov 2026 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621054;
	bh=NK07AabU1HqglQiNAAr67HJiADxWxGEo2/MSRavjdUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2qEMaHWyKNJ3c6GKTDwreq44bTahw8OGcalkMb5kqiHy8q7UuSm4P1+ndIbwN1A8
	 AoAxX34yzF9GnRlQ9aXANqg/prD9o4Pb6xSc3TDccTuv9n8aRHTqR9DkgOGhIsdGoi
	 QZpFIoEjoWCTtTsfINHCqIO1lsNIKQ/vIOROXPqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/990] tipc: reject attaching bearer of different media to the same occupied device
Date: Wed, 25 Nov 2026 15:24:31 +0100
Message-ID: <20261125143824.524373416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 24dcb8aa32330..e057d0c6786c4 100644
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



