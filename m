Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057540;
	b=kFEhoegtfE3O5t7YZJ7Nmx5K/8LYjI/qbQYaLdybqS2biqakUUeemOxPbJme5tDSDkJ0
	 igfSFDcvHi9vgUtTVCEMDDPfvfpaPuoXaaxiYuwyOLHZ3yw7UpUaUgUMT/oTchrr6jfI7
	 YPs07ZILDcEwBGoiO7hswYEAoj1stzsAqkilqACB+KUyxgog0qLge1ev0tv4aCsC+qapi
	 a0CzNaEsp6pS1nhnEi5f/xMZRHupiJBTkhQ4UyBVMhVjlAybDiMPMz3fpYJmSONoJYipG
	 u0dxeKhUAwvWa20ULE+noGWnF0PafVtY6uj+CIaumNcuRT/uZ9Opl2IN99qorNuoWBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZgJNqWE+A+/M/GJ6YTNZqNdRTT9GVdg5usCr/cWaFs=;
	b=oE00Ea9bx9WjdqLe0H1V1vHBAWyq8fCDfPTHEWThnQM8DOX0YyXRpbhGlu/CWUlsMqGN
	 BloIEgEzvwtNzdgIJ/fBImWnAjk7K+bns/91dqsMwu+DpvRjOuDDZ8QQT5TrW0tYNnl1n
	 dxw9dd4E3i92X3CB40Q75sosaP1Lh7wrpLqW4D5ALVA8LTqd4st9ytdrkHLx1aCB/dwuW
	 WmLpsNtk8JaCASHbfn6TNXBJTl6RHS+tZiLfdPPXCBgf7lwh+cGXmRdtFV2q9/AyZ4suR
	 a5oMMrG5bRKQmqvy1EDUAbGVmb6xiw6WccZJvEmYBBx72fNqPuGjduhxD0xPFzjKCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJfuSTa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFAD60A2603;
	Thu, 19 Nov 2026 03:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJfuSTa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273761F000C4;
	Thu, 19 Nov 2026 03:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057540;
	bh=qZgJNqWE+A+/M/GJ6YTNZqNdRTT9GVdg5usCr/cWaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJfuSTa2HOHPRF5zYqA+sgamRZHFHCKWsD8GEEEpBSa9vni9O9/LGMl9x51M9lUtc
	 F9Oba7/RmWSBofb4x7LnK7AwDBYMT4eNh8gYLIdF6l5uFlby6r/BP7dKWiGhtsycJ6
	 +VKcqSvyKME6cxPp7ZmjAMQoisZPsQa6pyNEVGG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0166/1848] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Wed, 18 Nov 2026 15:36:44 +0100
Message-ID: <20261118145918.595551831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



