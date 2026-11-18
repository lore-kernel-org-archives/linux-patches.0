Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043485;
	b=MXfXcYavPcq5AKA3vGkF02eK0PGvVAekmfNAA72g63T0jIHzUBs/ArT67CgIeZMeyA20
	 bP4BXs8fa8lD+LtV7iIu7tJb0I0MJjEJ5LqJ3JuMuAe11oF2BM/qnD0XannFKa9BWr23S
	 8pkZc80lDtIB2vvleWbfRcXCc5QhBS+gxfhDI6S8YuhKVu+Dk3DnDW+bvqiyZRwwY5FeE
	 QhRkr1/FqEF0z7mxwQMRxGk042UvJJwYct1zsYpSL/yvVLW6LCN1pELgkBkFzeAHcIHAp
	 1ALncB21uIFJo9ljaXdNxGOJ2z8bQPTSZM7jGKiI9fA2rDy1+I+1JPeLg1TEP3i/f7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EoIimJqd+mr3c7CHhAeHMyHCDuN0EynF8qOa3pPpIY4=;
	b=t3ZHO1Sy+9keMaUdC1AIS4gH8NM7Lmr+SSijaf5rqZp+zUygylyNUgy/GvMPBfwE7Vaq
	 tVVwQ8w9MKbuTY0c3ppG359Vl/A+QnnmCR51CCpQau2NRERv6sInKHdngzeB3houwnGdV
	 auWEBbKfq82BTEdzAessbu5RCpspOFvWcRHlGNi1JOkgCh7kJhhzJuPzEbOy7AG/p8vDX
	 Cpykn9PArMnQzLeqadbw6pY5twu9qokSpWwKktDcA0zRt72+UAP7BbEkk8S2JwJWyuyFY
	 aHJQTH/1rdgcROU+cMV6ZWG3sPayxPeWmOrP08RmH/fFRd+2okxm3O98c+ZHpMXeTJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HO5XQVUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12309606A338;
	Wed, 18 Nov 2026 23:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HO5XQVUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6901A1F000C4;
	Wed, 18 Nov 2026 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043484;
	bh=EoIimJqd+mr3c7CHhAeHMyHCDuN0EynF8qOa3pPpIY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HO5XQVUCqp/ZoA/jdVOvzyrWmpK8do9VNGv6+gGHH/EgSQ/8LzYviNQJ35GYEyufc
	 ZP8mrNOBGud2fM9r+1qIZ/bPktTrlU2DvyIZCb7tMsyeLI7PXDxqIU9VN2yX05R6jM
	 UHig/qp1obWO7ytVGTvBp5B+1K+Ehhp2Mf85RAas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0226/2857] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Wed, 18 Nov 2026 15:21:00 +0100
Message-ID: <20261118150209.595999597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Grech <bgrech@redhat.com>

[ Upstream commit 2373107782a98ba15931a37bbd9dd46d7213e5aa ]

The commit message for af8c8a450bf4 ("selftests: net: Add FIN_ACK
processing order related latency spike test") states: "if the latency
is larger than 1 second (spike), print a message". However the code
uses a threshold of 100000 us (100 ms), not 1000000 us (1 s).

The lower threshold causes false positives on slower hardware where
normal connection latency occasionally exceeds 100 ms but never
approaches the 1 s spike that indicates the actual FIN/ACK race bug.

Fix the threshold to match the documented intent.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Brian Grech <bgrech@redhat.com>
Link: https://patch.msgid.link/20260806151645.4172900-1-bgrech@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fin_ack_lat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fin_ack_lat.c b/tools/testing/selftests/net/fin_ack_lat.c
index 70187494b57af..4117332eb1a9c 100644
--- a/tools/testing/selftests/net/fin_ack_lat.c
+++ b/tools/testing/selftests/net/fin_ack_lat.c
@@ -69,7 +69,7 @@ static void client(int port)
 		lat = timediff(start, end);
 		sum_lat += lat;
 		nr_lat++;
-		if (lat < 100000)
+		if (lat < 1000000)
 			goto close;
 
 		if (getsockname(sock, (struct sockaddr *)&laddr, &len) == -1)
-- 
2.53.0



