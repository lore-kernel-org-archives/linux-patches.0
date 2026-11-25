Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619113;
	b=l0X/l4uTVosvI6hfx+UMcyi0+qm3OJqslak5hXV6cpBxCxBC9hXanaEfduR2jDXRMX7b
	 hMKKLZOK7tR1GomwUPaZ3N15uZyHAxMxiTQ0fLo/951VEWGjVrvCRbGZlluc5hlWcx7DV
	 S94vQDGH+EabG6OxWcXwVP5413VYcQhuCKa8fHDvYnqVI32eS1tuSuLKvOlzDoe8Pfwxe
	 601HSC+l4LuY0jqnr/vfgn+4nM4JCiKaQazK4A9gguX2YDMpmZQLN3B09TFcPa2qX8VXe
	 CXctGOdZ8mWF8h2V2Jhq+QGW2vpBUw7diuHjiteU0YEVN9kkQjhlMAGWCMHWmmobq/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bg7Ub4JShGHFk9tmeUIsk+N2Yaf+HYyEAGs65YR949I=;
	b=a3tKmLKw5VB1tfWioB1HsPYhwpJ350ieBpfgHgBoFh70ILxHn3CyAE6wHypssm4UsQ9u
	 YD+aKtIs1Uq0u1Xz00vQ4oKREnnfXXyzU5GUsTPrhxJSBZQnw7op3sZCX4GNDmjxNh9vy
	 R/WHM6+CLLM4bVo21LxZOjE7nXGBkbcH9an8R1iy0RWIxqDdZ7ezdUhsPIN00EQFUEc1E
	 vDaVZpa9MzMAvPQk+ic46WImreXWChl6LUDNFJhF2g6SXHXOLhl6Dx3pl5XTxOtCT9VT2
	 OUoB+Ekb3wdD9uaKfY4Jsr9hLWZVF67T2S1ABil3FwtEyF9xYkv1mCFM8A6nmIwyONg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhSPUW5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CE2606A31E;
	Wed, 25 Nov 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhSPUW5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9111F000CA;
	Wed, 25 Nov 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619113;
	bh=bg7Ub4JShGHFk9tmeUIsk+N2Yaf+HYyEAGs65YR949I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhSPUW5JewjHOZcBCqgRWpS2iCT64cbv+KaTf9YjRSi20IohQ2KNgDuFaPtUE1MMU
	 CshatQxhzRTeiFTB9CQ+LriOgZ9u0THKbx7gsh2L8PUYVixfq3iekJI3Jh0Sqlf3zK
	 vuCKyJimOaOXn6GzZ95B8UVyXUzWJutJ1zw4ukRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0457/1005] team: fix promisc/allmulti leak in team_port_add error path
Date: Wed, 25 Nov 2026 15:29:55 +0100
Message-ID: <20261125143832.453385512@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit ff618cb00a645f1e3f89068c5fbda3f3a7f4ae63 ]

team_port_add() increments the port's promiscuity and allmulti
counts before calling team_dev_type_check_change(). If the latter
fails, the error path does not undo these increments, leaving the
port in promiscuous and allmulti mode even though it was not
successfully added to the team.

Undo the promiscuity increment under err_set_slave_allmulti and the
allmulti increment under err_set_dev_type, so each error label only
reverts what was successfully applied, matching the cleanup performed
by team_port_del().

With the promiscuity rollback now living under err_set_slave_allmulti,
the inline dev_set_promiscuity(port_dev, -1) in the dev_set_allmulti()
failure branch becomes redundant: that branch already jumps to
err_set_slave_allmulti, which undoes the promiscuity increment. Drop
the inline call to avoid doing it twice.

Found by source code audit.

Fixes: 0ae9cfc454ea ("team: Move team device type change at the end of team_port_add")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261104015217.2222-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 957cc7885d2fb..cfb833c307c14 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1365,11 +1365,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	/* set allmulti level to new slave */
 	if (dev->flags & IFF_ALLMULTI) {
 		err = dev_set_allmulti(port_dev, 1);
-		if (err) {
-			if (dev->flags & IFF_PROMISC)
-				dev_set_promiscuity(port_dev, -1);
+		if (err)
 			goto err_set_slave_allmulti;
-		}
 	}
 
 	err = team_dev_type_check_change(dev, port_dev);
@@ -1397,7 +1394,11 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+	if (dev->flags & IFF_ALLMULTI)
+		dev_set_allmulti(port_dev, -1);
 err_set_slave_allmulti:
+	if (dev->flags & IFF_PROMISC)
+		dev_set_promiscuity(port_dev, -1);
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



