Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4759A14F9A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="QJV5EScP";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="yFKk8U+c"
ARC-Seal: i=1; a=rsa-sha256; t=1698744597; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FqfrjacrWmSxUAAhvg9EMLSJUdbndlbnKsJQ8JX2yqcT4CEj2mgkYG1wcD0QVaoMtB
    wLc4eC0nioLpVrt3EW+OTQjRe3Zum1DOaRhTC7xesReSdC2rVE2Dqqvzm0nBxdej2CHv
    v5MpNW+fQps6YKOmlHE8J1AaOxTQTaVsGxdRJAU1VlXT2zBcvA2m7o9QSKA44ZWxl5A7
    FoswmqRyc7qIg9/PkEclR6OUPYGsAFtfePinKi2SPeRu4jfYlc29mnko++1jf7h48yyV
    L2yvV+m9lLhbilf6p776JxguvOg6fhcEioSPzj9q69ZRBRmvxRDhhgIOyzzNZGumH1V1
    7EVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744597;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=sOZtvX6fAm3rEME4QaBlcvE5hEKaO1W/hBkfGk6fYKY=;
    b=IMppRmy4itzX5KFCdfxxfwHFbnLQ7IUXMmRb+61tvuF6CHIcf2PH1jlaisIepfK6wN
    QC05cWeqBjYXF+Kwx/bKweZvo0r/6F0l8R29HkNgfCI7X39yCpdCEnQOSCt6Egby8Aa8
    fEj4MFb9OyrAhg4CxgAFufosOv9hjJPd9j+h17fe/ds1B0qk+CGhgGmHN9EThUvEBgeU
    VSTnEo2e02r0pMndiv3f3mdJqqlsXxi1+mAGzqWR5107cloXjbXnIb18wHfbEaBL4IWL
    /YzXoVHyyOM6i1127hjDTqKH5WXBla/WMS/IWh9Yi7PWZVVOeTGTTsZAatjSp5bvBA9R
    XT8w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744597;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=sOZtvX6fAm3rEME4QaBlcvE5hEKaO1W/hBkfGk6fYKY=;
    b=QJV5EScPf9jLbNTQse9lvsh7PbJCA3JSF/dHcbpPoy16ea0t2EGwPS/SBjqjWVHUMk
    UEG1S6U6Y+gdTz606Mmqi89Ivqy+JBEg/VqNrATgF3P99Z0kMcvB2STQQd2vYZJIJ9Tr
    3ml9Yc80tIaOMmCsNkR00igcJE5e4x1UhVlq3z7cbYWzbOQB4X9yZVbPg1qZVTDGF8ml
    nOHatpik2FLrsdteFdE12KUyd3QrsX01D7VVtfqveWA8pHiL+8UmNZaA5S+rPS6upQza
    obQ4KSL/hQK2iLFbs4on5XIDIlPdp/SQfGVlKqipwj4UkCmtWx3w81W+Ude+B75/PmO7
    doLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698744597;
    s=strato-dkim-0003; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=sOZtvX6fAm3rEME4QaBlcvE5hEKaO1W/hBkfGk6fYKY=;
    b=yFKk8U+cx0AVy8qdLLjfmEEm4UbXoBM9u49HfmjtVQl+S357f7Vhrp3C+vR5hlGElD
    umQBYVKrTBw4i6mK2tAQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVITM8sik0"
Received: from lenov17.lan
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9V9TuFhI
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 31 Oct 2023 10:29:56 +0100 (CET)
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
	Oliver Hartkopp <socketcan@hartkopp.net>,
	syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Subject: [PATCH stable 5.10 06/10] can: isotp: check CAN address family in isotp_bind()
Date: Tue, 31 Oct 2023 10:29:14 +0100
Message-Id: <20231031092918.2668-7-socketcan@hartkopp.net>
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

commit c6adf659a8ba85913e16a571d5a9bcd17d3d1234 upstream

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 902cb61b6495..87de9a08cc85 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1127,10 +1127,13 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int do_rx_reg = 1;
 
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx/rx CAN identifiers */
 	tx_id = addr->can_addr.tp.tx_id;
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
 	else
-- 
2.34.1

