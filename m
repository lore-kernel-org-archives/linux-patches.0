Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FE21F76C2;
	Tue,  3 Dec 2024 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241142; cv=none; b=itzIeqNttmh3Gzf2270i5wiJUobuvm2sjJFXMeLeEVdtfI8ndrTiZn2nIeVD5xG9hoZgXZ2sx5QwopYxqdCJMnVVX1XcR+jS69bwH6enQ95g/3BhgH7Y1kaN/Zsc8QGNLv+e6RJZJf5p4OEaUTbUgMwkhmMTLejFFcovqoI0izY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241142; c=relaxed/simple;
	bh=Z4mhN5+hk8+XK6+LztgItsFr7nvNzqb35mWvrzn1DIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMDjoFWqEjN8dJMb3vm1Am6oGsOwhNDqybyu+gjrADxIBpOzt2qnzRYfJGeAFJQB3Kk3Ni6iyPhWWOUfdycNpzYgPZ6UDlL+wP2xpgrjcKKGd5DdsuuEDyckmX9CVteQYSSNFSEDeQyb8E8rRPLCvQOY/AfvFwJcisBOdeG9mgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQkqQjvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQkqQjvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2382C4CEDF;
	Tue,  3 Dec 2024 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241142;
	bh=Z4mhN5+hk8+XK6+LztgItsFr7nvNzqb35mWvrzn1DIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQkqQjvZk7wWBokMZMX583LVYAOEXaerRwsm8AyEwR5uTd2PbNogjEpYFFHNhGEkK
	 bVuEMS5fQr3KnKTUO1G5k9J0xcooMewd5zFUyuLj7hrEWCKMtrUd2VaZ+hv/VaKZZL
	 3l9usjnY2hC4O6tz3SLkaKRLOJjELlsX8/dublRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guan Jing <guanjing@cmss.chinamobile.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/826] selftests: netfilter: Fix missing return values in conntrack_dump_flush
Date: Tue,  3 Dec 2024 15:41:03 +0100
Message-ID: <20241203144756.867383667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guanjing <guanjing@cmss.chinamobile.com>

[ Upstream commit 041bd1e4f2d82859690cd8b41c35f0f9404c3770 ]

Fix the bug of some functions were missing return values.

Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
Signed-off-by: Guan Jing <guanjing@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/netfilter/conntrack_dump_flush.c  | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index 254ff03297f06..5f827e10717d1 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -43,6 +43,8 @@ static int build_cta_tuple_v4(struct nlmsghdr *nlh, int type,
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int build_cta_tuple_v6(struct nlmsghdr *nlh, int type,
@@ -71,6 +73,8 @@ static int build_cta_tuple_v6(struct nlmsghdr *nlh, int type,
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int build_cta_proto(struct nlmsghdr *nlh)
@@ -90,6 +94,8 @@ static int build_cta_proto(struct nlmsghdr *nlh)
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int conntrack_data_insert(struct mnl_socket *sock, struct nlmsghdr *nlh,
-- 
2.43.0



