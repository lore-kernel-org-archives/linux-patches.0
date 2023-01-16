Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3574B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF776C433D2;
	Mon, 16 Jan 2023 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885712;
	bh=q6cSyleanLM6Ha2pdjpWcD5mHJTsbAiFel5ViqoQ93A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGHU5MGYyDcjM/yMSJEGpR8ZyGTBHNfI0CaqI9ra2nImtCSSOnqgzIhI0ilkNu+wB
	 yVI9wRC+HFzA8qYoxBOP1kGb3+Zyucg6kNy7yxB0URamjnWTOLsViOUyj77hnlObgI
	 6/BJ75jAvEX//077oIWCR+llL+2SGrpDc73U7Ztk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/658] rxrpc: Fix ack.bufferSize to be 0 when generating an ack
Date: Mon, 16 Jan 2023 16:43:34 +0100
Message-Id: <20230116154915.223452389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 8889a711f9b4dcf4dd1330fa493081beebd118c9 ]

ack.bufferSize should be set to 0 when generating an ack.

Fixes: 8d94aa381dab ("rxrpc: Calls shouldn't hold socket refs")
Reported-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 6202d2e32914..09fcc54245c7 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -93,7 +93,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	*_hard_ack = hard_ack;
 	*_top = top;
 
-	pkt->ack.bufferSpace	= htons(8);
+	pkt->ack.bufferSpace	= htons(0);
 	pkt->ack.maxSkew	= htons(0);
 	pkt->ack.firstPacket	= htonl(hard_ack + 1);
 	pkt->ack.previousPacket	= htonl(call->ackr_highest_seq);
-- 
2.35.1



