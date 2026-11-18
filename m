Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051402;
	b=sPc45EXTV4cLMTYlZfAEnx18StS2CWly5OybGKnMi5wqQC8rvmECu8dq13POsxANeQk8
	 /suilCf1SUsGNpKxsKVGG2YiykSzOPQr+m1CKm8/wRvCIl8w5W8S6SbIc0WhPPG6zO/kR
	 dEZDR9MW0OhoI5X4d/zyG8X+B98RrBiPLccL08NOdN62Zd7bf6pt/Ep3RSVauPZbtOjeT
	 7T9FaXfRUY2IJ9/KxUC3XWAu6vr4g8eOm7AE5UXiyRmJBmpgtk6NjKcQ5ic65ba2GsGda
	 gezViTuOVNbKRm4edxWVqzDoMKUuO7rDp7GdWS1e2w6kHTKjMPxgV406THuT/CLXapQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bLnb+VZ/+CvklQqQHvYh0YDkknM+uNEu4AL3ATBVvM=;
	b=BL7XfH/VieHRqJZWL7wGhNdvEzPssB6uHMOkWrOa8vvM9Jxv8Hp4Ajtj6hzdCudD0duI
	 PCyptEL9l45ARVMfUMK4IgBbI7D/SSH0O6tNmR4X6o0ZEVaJLiGWRgn/3UhtERBkA4NNg
	 DvkmVDzU34lQotk8XmA2O//YgwSHKuE5W5QEQ23KFl/NdchGqVe1ESFzenW4eM6zEo0ap
	 kUqa0A44WJ0EOuWTIMw8ezV635O6hb9rmH+uOIrPblmV0I3LP/zaaQ1vGGW3/jYIfliZJ
	 p+6z2YtxJMa/6dCl4sLAxxThGmVE8kJ0DbdST5efJcnMSVJ1cbdj8cCw3cQd8/HioQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7WLJh2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB89606A325;
	Thu, 19 Nov 2026 01:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7WLJh2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690FD1F000C5;
	Thu, 19 Nov 2026 01:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051402;
	bh=4bLnb+VZ/+CvklQqQHvYh0YDkknM+uNEu4AL3ATBVvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7WLJh2BHtz46WsPZtpf5b50n91hThBGsaR9ByzFGMs+teD8TdA1HrWbt9L5zE6pA
	 CS8LBzW//oiUIDVxaA4F+CGReqT9HImDhsZOPvg1lsLQ1/LZZt60Izca7PdSJPiytW
	 eWzPwSVJ4k6gYTABU0W52yIq4FU9KmDHXl6P0hVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Brian Grech <bgrech@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0195/2214] selftests/net: fin_ack_lat: fix latency threshold typo
Date: Wed, 18 Nov 2026 15:31:11 +0100
Message-ID: <20261118150017.991411764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



