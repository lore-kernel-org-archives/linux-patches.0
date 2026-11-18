Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021631;
	b=Xln/bmGJKZP7w6XMb5BWVoDTRgJcesjhizrXRR84yol9d8dyausKkLhJIq7HB46DRsbc
	 5d1lMMVs8QvmhJ9St9gROvuAFJnWwK0VCsCNk4wFK3kwCYjFusRamaY1VoUbwi5fdiqbz
	 2yTC6+0J6YDtkFxU0nvxkWEt1VVCxyLgyJUpJ06qHtIGKEAeh7YaMF0u1GvIT1ChWMJNq
	 +X29K1H1/gHYynzhYVs53MlSHQE+b0BEgu8fa4+mRRhtls6ZrHqfbbdidLh+ss6jPLCHF
	 70mCl7YRwer1rqKIieb+3YSwLX3IzQ83lhOamr4w9xU73T0UzmQ/zjZMQ0AAdykid8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yz+KQdXZpUBTZ4aDwixfpyxtAMtr1lpxYDAHfHmWN0Q=;
	b=SjUwpynf6swXeccRhOVpTfe7WQSijpCsI3J1Y7HGyA0gdOnzwjp8GGV/74HftAMG6SVy
	 S5C8nFCsTozglJASYwdLR9a/z7PVH8fKkZoz4lhxZZ5J03rd0bz7U1kywmaFvl0ZThFq4
	 4BMv819WxBTkx9VUHlORZIxcEGeUJHuuKIBpxP7gKfPhc82fnAcYmKcmoJVOmiyQIYIVd
	 7fUdx2u6ZuP2WoiqIdRfOgj2UG5pZ5XdCHM8VoEM9xjcLQdPhb698MJCQJe/IpPMtqNGT
	 JBG/9I7KTFjne9dZekUb4SsT45GnOaJR+xvyVn2PvQHKZz7SUkL+uxR7b2KYknoW6gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MUhhIQG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9C1606A32A;
	Wed, 18 Nov 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MUhhIQG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA591F000C4;
	Wed, 18 Nov 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021631;
	bh=yz+KQdXZpUBTZ4aDwixfpyxtAMtr1lpxYDAHfHmWN0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUhhIQG9JUbNtz5cx4AOex6V0t2pIhRDkve51iPlhEBE/f0IwllHp3yTZkshVzOO8
	 ou32JAYwdnAXqxB6NfDsO6q8cHxiO8oxjK07BtbtXTEJABCwOniyVZU+nEFz0oRpRn
	 Uzo7tCAlaqfNi/FvQc9EEF+0HMzwG4THcZ2pRAxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2377/2651] selftests: gro: remove unused variable total_data
Date: Wed, 18 Nov 2026 16:00:17 +0100
Message-ID: <20261118150411.051359704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@kylinos.cn>

[ Upstream commit 86537a8fb24750fc25a96a27ff29400054d052b5 ]

I hit a build warning when building the net selftests.

  gro.c: In function 'check_capacity_pkts':                                                                                                                                                                                     gro.c:1249:13: warning: variable 'total_data' set but not used [-Wunused-but-set-variable=]
   1249 |         int total_data = 0;
        |             ^~~~~~~~~~

Remove the total_data variable, as it is no longer used.

Fixes: d97348474708 ("selftests: drv-net: gro: always wait for FIN in the capacity test")
Signed-off-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261022-self_unused_var-v1-1-8ab10a6b7f44@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib/gro.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib/gro.c b/tools/testing/selftests/net/lib/gro.c
index 7a333155de1ab..1bc92e7a625f3 100644
--- a/tools/testing/selftests/net/lib/gro.c
+++ b/tools/testing/selftests/net/lib/gro.c
@@ -1246,7 +1246,6 @@ static void check_capacity_pkts(int fd)
 	int coalesced[num_flows];
 	struct tcphdr *tcph;
 	int ip_ext_len = 0;
-	int total_data = 0;
 	int pkt_size = -1;
 	int data_len = 0;
 	int flow_id;
@@ -1309,7 +1308,6 @@ static void check_capacity_pkts(int fd)
 		}
 
 		num_pkt++;
-		total_data += data_len;
 	}
 
 	/* Check flow ordering. We expect to see all non-coalesced first segs
-- 
2.53.0



