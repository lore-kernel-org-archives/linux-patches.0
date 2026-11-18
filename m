Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058426;
	b=BI7RvXsHY/xdqjYeXUVA/EThrtlHYJygfSWELGiICV1aNKJyYNVWQam1HeNg/Is2SA+P
	 3KDn6nSl37nkS/xCf3xUjfH+2rfXMok9nCwjqjKYoE91n32cviUe6ldY12uAb6Rzn2ppu
	 4YxrrbYyjZ6154F4T1uei2rBoFePhZuiERUj8lFXCy4UEh5l0yyN4POXTfMKKRpuGxJIk
	 /4dwe9S/JwY/JL6mXj7Kx5o8JvHVC1veqNmUg7Cu9XRtfX2biLAsY1lJzPyfypg/kwhsi
	 KXDCt5qO8S0qw2lpmbGL1+FqtWNtZaIz3MUM13e4CD8Zv3ELlf4RIpA9ozonEE6+x0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0oaStnU9alF5tdtoWGQBdF/Rs5d938aDaf9KxiTsxqQ=;
	b=P8+4Sr5KRVcEk5HCmUT94jehBu+IxmfiOR4Pyg05FzcQkxYWNBHcH2rHwJ0jdqixgyIW
	 EcUsn4/vT+hOJ1iG1LuT7b1NtEppKDapwiOseFdbNc+2PEROy9PlPNQg459y89faMeHZe
	 SCfbySVmhEY0bxsQE+aWj2b1ljS3+fZ8Tvj7PIv5F7200NPF2dGq25ckH4XML2SS0LZ/A
	 atfWgoUFC39BQjUL18x9fWc/AFu5+meHrtfdNxXTD/IQHBeqGY1rExnMuflnqtF3Z3GTm
	 BsK3PRBdBwW36e8mKzmzr2R+jeKYZAl93GqZ2DNppsFryRy/89MPpOJZnwURMserlFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMmjE2nN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF178606A325;
	Thu, 19 Nov 2026 03:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMmjE2nN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428531F000C4;
	Thu, 19 Nov 2026 03:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058425;
	bh=0oaStnU9alF5tdtoWGQBdF/Rs5d938aDaf9KxiTsxqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMmjE2nNNiToir+rG3BY7N2E5mdvpwO83j6X+LmhTaRJ2S5uIOeFvc4oCe/gRQxut
	 2Wi09ncEbZiwSg+N85P4W7GG6cDfqyJYVableWEqZzYncf2xLNAkNQbC39/wPFjwL7
	 AZWX65ehoCSqvCc4/iSgaAOKw5UYwtoZxVZsl5Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0444/1848] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118145932.867431223@linuxfoundation.org>
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

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 1ae2d094b0200f687923298c0e42579273558988 ]

ctnetlink_filter_match_tuple() rejects an entry when
!ipv6_addr_cmp(filter, entry) is true. ipv6_addr_cmp() is a memcmp() and
returns 0 for equal addresses, so the condition is true exactly when the
addresses match: a CTA_FILTER dump with an IPv6 CTA_IP_SRC or CTA_IP_DST
skips every entry that matches the requested address and returns all the
others. The IPv4 branch compares with != and behaves correctly.

Observed with libnetfilter_conntrack NFCT_FILTER_DUMP_TUPLE: a dump
filtered on src 2001:db8::10 returned only the unrelated entries, and a
dump filtered on ::1 returned every entry except the ::1 ones.
conntrack-tools does not use the tuple filter for -L, which is why this
went unnoticed.

Use ipv6_addr_equal() so the IPv6 branch mirrors the IPv4 one.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ae8d13ec8599b..535b371c86a91 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1010,13 +1010,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->src.u3.in6,
+				     &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->dst.u3.in6,
+				     &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.53.0



