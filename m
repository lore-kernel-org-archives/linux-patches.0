Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC5E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E4C433D2;
	Mon, 22 May 2023 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784043;
	bh=f/B95GWl0V89cK7SWyr8lHVD5SuLpvXDoOEZ6S7HRCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROpwKEmm6oxmOI1PfMTNA2IylDmAzsjQdt5CDOmJF0soEKDhl/UkmjjSQY3jJqZD4
	 J2gQYf9+pJFaLK7L6quLzkcVDLlo40tEwaEXhbvGT3dAy79OeuuU/Q3JipkVwNW416
	 B8wtqdVcUqQoJnvayXEXnsfSnBgI4WIbTcSoO/58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 6.1 245/292] can: j1939: recvmsg(): allow MSG_CMSG_COMPAT flag
Date: Mon, 22 May 2023 20:10:02 +0100
Message-Id: <20230522190412.074206580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 1db080cbdbab28752bbb1c86d64daf96253a5da1 upstream.

The control message provided by J1939 support MSG_CMSG_COMPAT but
blocked recvmsg() syscalls that have set this flag, i.e. on 32bit user
space on 64 bit kernels.

Link: https://github.com/hartkopp/can-isotp/issues/59
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/20230505110308.81087-3-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -798,7 +798,7 @@ static int j1939_sk_recvmsg(struct socke
 	struct j1939_sk_buff_cb *skcb;
 	int ret = 0;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_ERRQUEUE))
+	if (flags & ~(MSG_DONTWAIT | MSG_ERRQUEUE | MSG_CMSG_COMPAT))
 		return -EINVAL;
 
 	if (flags & MSG_ERRQUEUE)


