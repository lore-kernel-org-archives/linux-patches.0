Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034129;
	b=xHrfI2W8iBerbK0Qh7ciafvjsh030bW5zzZcYMMM5X0UET/nxwUW5egTUAehYa6L8aVY
	 Cx8Dke+RJZFLIMBuIkmH4KhSguUHH8SPNFiQ5mDXiIElCWKMMB489r9ZdpUCjK91Qa940
	 CJWDOms6XXno65cGCY3esk8QlvBmTA7GfrUCK3F9g+HuxVHTt3MdM/Rwdq+JMvXdFXEXo
	 8Iaf2M1+ycgIJzjhLB2gGH8bMzH4PkxTKnSQLWm50egDinDqTNFYc7ToLHlxoqM49S8Fq
	 cagE0H4TjvlnlMCGqJZIbDt2ETcMUlurQ4JFSKxRoznBUmXvuXQdT4M5OjIkI5sdAGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4O0c3vQVXBi6Cp09sZLffLN/PLQcty6Axt6SGudRS9k=;
	b=UR2yuTf3npT1+vEH+yTSNU4jt3lnlDPW/HBVlmENINc/eLnadLORtCdKTFYRNKMDlrET
	 GB0h0IHa23AAcNQhsG9a4E8i8EfPscbyP8PDwwgjcACNRC472nWNkli5Af35pp5QZpUSs
	 ohVswphmSyGV+f9GU8V8S/w4fDGhKo4UN9egl9nHHTEJ3W2nFOqBFkGG2KEyQ/AVmcbSz
	 GxzydFoNbNEfFox3q8Ft9HeFOMxr8XpxLbrmScRghfmS3zEruT6g/+gvKe28aJ9+GzJtj
	 uAGifihfyEsglxgMsqPrrJctmfsCf6d2sXJAK53O/eNG34XfvHl1eNfGdtl3xE6gjLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+dal4it;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1683606A33D;
	Wed, 18 Nov 2026 20:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+dal4it
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B031F000C4;
	Wed, 18 Nov 2026 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034129;
	bh=4O0c3vQVXBi6Cp09sZLffLN/PLQcty6Axt6SGudRS9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+dal4itD0juDJySU+H6cWqDj/6YN+Msx0a088quwXFijeyE/sc98xs2BgLwRfHpB
	 82HHXqnFGKW/MM1PW4Bs4HiWMOB3Dxy9EVHGjEIrmD8c423AD2/aWq7/ptjLIjYPU4
	 HCVnPgCmI2E6CnBsjz690db7wpa5LDe0nmZAYsgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0261/3318] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Wed, 18 Nov 2026 15:14:43 +0100
Message-ID: <20261118150323.207450327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



