Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060951;
	b=PNL1e6l1bLqfC7a4OWMCsgNfcowKONyGeLv2zQ72/Y9hLt6WFdtKZUF35tCHABc9QLus
	 Rd16oP4ykwPd72hMNJEokiODWUdN1lneDqxtJDXC/gHWaaRZZYhHCCs3WvLuxbYIuFQZN
	 sqHQrguB7H413VrGss0jHtP+13MODtsJ+XlWGNQL2yS5cs8IAbgijs0/DIPpa0w4bpCXH
	 +/ZeK9MOOY60lSN9nDZ4oYULVWdDgKDAJ4QEw/UOYxk8PivjlDeeZeNK5ah7OC+ysEQkw
	 B8S6RwD10DNnMz9SJbG7HQxSxqsUoOYDBUyfzrhSuV3gtxFisac3Fbf86iHkppPLOTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ToYt3vr3B/YvY1+GhZuPlVD0Tbao6ZGvDJQX7hiRT6U=;
	b=evkhCm4KcVTZG/LR3lD+MniLg+dBPUDG1hyO4tjx67WWH/7PDaRLrAHPyjkANRp+0wf3
	 5Nmk2GAGEukNc2rkt3bR6ihzmLmUA+XgPCIJSRDYRUUj25TgLJ7a1j4kUQm8zLWZH9py6
	 73RJfiPNrJeyKEti6xDcBRilbp7oUZUn2tZNa6oeg+HbgPrj2lLVt3KfZGvVsYaLVGb/N
	 KIJh9EtfgqwgL+EQ9/UgvLEq9RA8vTSOI74xQHNG8v2Ne9xlbYBTL2ZIgf5G0unmAFzMw
	 gMhzF+1nmrPt5g2sK8ss6kODo4WYwUsMTadQtp8t3t6rDtmJBeD83QxD4x/xEqrvE8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF2CmV5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E5D606A33B;
	Sat,  7 Nov 2026 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF2CmV5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B491F0089F;
	Sat,  7 Nov 2026 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060951;
	bh=ToYt3vr3B/YvY1+GhZuPlVD0Tbao6ZGvDJQX7hiRT6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EF2CmV5RckjlmWORld/y8nR7yvecqei4dqAn2rsbbbCkSjGS6SAKhwIMhGghkPtE6
	 6UtKRGTRo4vZujTrCex0FV5HBRFNGr6T7y8SIxTKXY9U998HDqyAvkgjK42Bs6+P9J
	 XFokY85vdeWcyPEOAvrw53cahTQvv8AA4kP6UifA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0310/1536] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Sat,  7 Nov 2026 08:38:46 -0500
Message-ID: <20261107135006.426760275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



