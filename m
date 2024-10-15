Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346731EABCC;
	Tue, 15 Oct 2024 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994400; cv=none; b=PogRqOIfA+rvXnx668ygnHs1AO3fByw0302irpK7SwIa6CiE6EOhujBo31gcH0qfVLpw2NgDaA514BVc+4Uty5OME6G3apuVmvZmxgofyotApnacillcd8qkzxTus6QHSRn9wwgEUx8lBIwkmgNasxLGVrateDjmHC02CYTEhJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994400; c=relaxed/simple;
	bh=mqsOVb0QbKYhUPa2ZsKo5XROwq407AOupFyhWJEMLOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXgOChU7X2x0U+FIz5IA51U9qdJbVSV/JGB5SKU2Kl4Bmcq+b4waquQaTYuTT9+rcxj0Q/4BRHjqG2xC4g+ly5C2SkbRpeCABnNmJVjqU1usmcM7DLELpPY7u1LsXMi0DojY+eSHIRulPxMoCSgsDGyTz/bB98OKlHn8n1yNI2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBAssxHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBAssxHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F0C4CEC6;
	Tue, 15 Oct 2024 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994399;
	bh=mqsOVb0QbKYhUPa2ZsKo5XROwq407AOupFyhWJEMLOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBAssxHvnvh/QsiGIyY0usXuuWfZb6dXxZTkqab6HOVfVVfvDWeg3qKBqr/oGKwBx
	 hAmm4Msf2lgI7QIJ9N4KOYHwlNMnu0EJKqi9YReFSTIoVAQGjbFegcV1q6/bbrqcpP
	 wAfAC/vrIl/BRqcT++nD6K3u/BojGMqSAkKeetk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eyal Birger <eyal.birger@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 682/691] net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT
Date: Tue, 15 Oct 2024 13:30:30 +0200
Message-ID: <20241015112507.390835796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

commit 36c2e31ad25bd087756b8db9584994d1d80c236b upstream.

Add missing netlink attribute policy and size calculation.
Also enable strict validation from this new attribute onwards.

Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20220322043954.3042468-1-eyal.birger@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1280,6 +1280,7 @@ static void geneve_setup(struct net_devi
 }
 
 static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
+	[IFLA_GENEVE_UNSPEC]		= { .strict_start_type = IFLA_GENEVE_INNER_PROTO_INHERIT },
 	[IFLA_GENEVE_ID]		= { .type = NLA_U32 },
 	[IFLA_GENEVE_REMOTE]		= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_GENEVE_REMOTE6]		= { .len = sizeof(struct in6_addr) },
@@ -1293,6 +1294,7 @@ static const struct nla_policy geneve_po
 	[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_TTL_INHERIT]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_DF]		= { .type = NLA_U8 },
+	[IFLA_GENEVE_INNER_PROTO_INHERIT]	= { .type = NLA_FLAG },
 };
 
 static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -1798,6 +1800,7 @@ static size_t geneve_get_size(const stru
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_GENEVE_TTL_INHERIT */
+		nla_total_size(0) +	 /* IFLA_GENEVE_INNER_PROTO_INHERIT */
 		0;
 }
 


