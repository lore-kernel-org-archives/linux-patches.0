Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C3D294
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="JY++M8E+";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="BxFgbx7I"
ARC-Seal: i=1; a=rsa-sha256; t=1698744595; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FU1mdTQStvFPgUh+LrvTyMEzbzYe9Kq9T3RBZzLtZBS3dYGlgkL2tbLppwrQ+Dg0XF
    WwPj1Ul+a34g4zqyTcg4aI2AejJLZgqEgGoG8PU7Iw5c38garRRKoM/RL7DYK3aSErfQ
    gYZo4maPAaclJTaZ5jnwJ3lhACUkaca/hIHaDgQD06hCwZutNIFy1J1mV8dOgl4oepe1
    I5U8IBICD95PmnBXBdHRHeBuEuGVJYoz9mekVTmDd6rFaFyRxaRz3FvT9fVF5Vf19miC
    YJSTNnVGQIIRkMxcSpdasvO9XaQhf+3Y/7LGpFHkkPN/lVxOhS8dCbqWKqkMXkhykkDZ
    XGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744595;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=+3+3fl8Dw9igqgWyPi9LuZfPNwP8R5zOZwXySk4OGfw=;
    b=kixMJ16m1kheVIJhSzbpwBXQxRzlCKfO9msenXs4KpuKfHo0pzEmXTdvKBGm26/bxk
    /zJ4Nv/XgKexCSbRhHIOjcT4VmMjCqQehu0UarwfFlmpemnlf2G76krKAh6ZGO0GzeqV
    phC1U8B1yS5yPTBpZ17I4jjStPRWysZ+vXawwiyuxTzTswx+2lR3Q8MjjD8JlQoVMWwb
    ojCiuqxRmD3u/CNAgmMJWcfbrBQ6OedHGA8Zh3uM+33l2i0H5DM8pdxgGA7Rc7MbX1oT
    SpgQk56tIdG9UcVs7EIv5IiFYxPAe0AlIfwTuz/iTlDUy93MZsZXylAfCldUZevMQbel
    A7RQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744595;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=+3+3fl8Dw9igqgWyPi9LuZfPNwP8R5zOZwXySk4OGfw=;
    b=JY++M8E+TFVKJ5AzLCKmP4iWmiign8Kmfs2gYrKj/kDXS26AAyr53ojp7L1r7gutQo
    CKCPhf9QbRpTYuUknn7jdj/BEsABfYbEbFox8pK4WHngpG3NoUpzO3Lyg5jQAqnVeHbV
    DVl4DkVysEz8L/EEksjwg2mrEmsok33brRYiq9CLk1g40BVKBcEI5LK4ev6VKSP3Su0k
    plqbWWuASb0ttWDQI0QAJHu3VuIhy8Zc1LSJwunWb5PCOlH/jcnERVe7psfV+DPH9k0p
    TEyNAy65rQLL5WoZ8qgN96ZU7HvXYi//xU177sL7VRsoRA4Hmj46UVjewlg9uhJbjHt0
    ijOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698744595;
    s=strato-dkim-0003; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=+3+3fl8Dw9igqgWyPi9LuZfPNwP8R5zOZwXySk4OGfw=;
    b=BxFgbx7IkBGkI0WHCOy+ssBiDG1ra2KjILG6qSenWzuQ269cjHRKgc7U5rSsEqP7FV
    29yAqCy3tmgBkU7CAqBw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVITM8sik0"
Received: from lenov17.lan
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9V9TtFhD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 31 Oct 2023 10:29:55 +0100 (CET)
From: Oliver Hartkopp <socketcan@hartkopp.net>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	sashal@kernel.org
Cc: linux-can@vger.kernel.org,
	lukas.magel@posteo.net,
	patches@lists.linux.dev,
	maxime.jayat@mobile-devices.fr,
	mkl@pengutronix.de,
	michal.sojka@cvut.cz,
	Patrick Menschel <menschel.p@posteo.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH stable 5.10 02/10] can: isotp: add symbolic error message to isotp_module_init()
Date: Tue, 31 Oct 2023 10:29:10 +0100
Message-Id: <20231031092918.2668-3-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031092918.2668-1-socketcan@hartkopp.net>
References: <20231031092918.2668-1-socketcan@hartkopp.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Patrick Menschel <menschel.p@posteo.de>

commit 6a5ddae578842652719fb926b22f1d510fe50bee upstream

This patch adds the value of err with format %pe to the already
existing error message.

Link: https://lore.kernel.org/r/20210427052150.2308-3-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d34f9ab2eb62..009d5216f3ea 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1548,11 +1548,11 @@ static __init int isotp_module_init(void)
 
 	pr_info("can: isotp protocol\n");
 
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
-		pr_err("can: registration of isotp protocol failed\n");
+		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err));
 	else
 		register_netdevice_notifier(&canisotp_notifier);
 
 	return err;
 }
-- 
2.34.1

