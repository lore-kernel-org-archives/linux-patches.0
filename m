Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949A524D9;
	Mon,  8 Jan 2024 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDUccF61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE8FC433C9;
	Mon,  8 Jan 2024 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728380;
	bh=rewcayY9gslmMKSJaLJyekTEzxzX2CGiQKDW4sK8vtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDUccF61ROUl6V4zOGdfwIyrzl2qZl3UEnK4miDrwQITFV1OnFhMp9R5dtFuXo1IX
	 Sn5f1N//kCkoh7KIOOOSVgTLUZ8PQtbUrL5N+aZlA/qApNFsa7KFSqiZbY4GCowmSQ
	 sxzp59LiMy0ppJWD6w3KublYHZtYj37scPbb/q8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/150] can: raw: add support for SO_MARK
Date: Mon,  8 Jan 2024 16:34:41 +0100
Message-ID: <20240108153512.652089567@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 0826e82b8a32e646b7b32ba8b68ba30812028e47 ]

Add support for SO_MARK to the CAN_RAW protocol. This makes it
possible to add traffic control filters based on the fwmark.

Link: https://lore.kernel.org/all/20221210113653.170346-1-mkl@pengutronix.de
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 7f6ca95d16b9 ("net: Implement missing getsockopt(SO_TIMESTAMPING_NEW)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/raw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/raw.c b/net/can/raw.c
index 8c104339d538d..488320738e319 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -881,6 +881,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	skb->dev = dev;
 	skb->priority = sk->sk_priority;
+	skb->mark = sk->sk_mark;
 	skb->tstamp = sockc.transmit_time;
 
 	skb_setup_tx_timestamp(skb, sockc.tsflags);
-- 
2.43.0



