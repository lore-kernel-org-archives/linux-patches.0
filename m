Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC1404BF6;
	Tue, 21 Jul 2026 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669789; cv=none; b=KSHmWyX74LbM7W8SQ0+YntCnJgt9b7L3yG5fG4s3RlyycRfGMvsU0cktY0UUi6objN06woWl7VPi5a19BT8va7QESBXeKDdqjWlDhwUwaZVApC+/OfX01rKP2h8QYrsFa8NWJ03av+I/8s3wXzz1T/PgibEAxcR61CdZva9I5D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669789; c=relaxed/simple;
	bh=1opCgE+CyCLPOcPXBnTCQccquNDd6gdnN+IwVwIB97Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSQd2bMHTYIxAk5LPauU81Q0zGvvgY3jQnvAxxH5Mqk4rUwSMDL9h3G97g5iP4t9oB6BEw2MUoU6wHQEltg9EDpty9m3S5qFfXajZiUSAdu3lZ3SAoTDi/jtHHvhHN0tUS5sGX2TYiyyg48j0KTGcLCS+D6tv/A6frHzM3wOiIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbowEgLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbowEgLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B931F000E9;
	Tue, 21 Jul 2026 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669788;
	bh=s0kqsqobDtA46ap07VH1wbHNK2z06S4pSIDUcAxnivU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbowEgLpiIoIulqCU4E6cD61gUtuVIxO5IV/t4/CfdOn4vu9z/HOAxdux8JIvOmoK
	 8tMdueOBkEcXU88PjHUtlsKBpxKdC93dhjx1NvOzxQ3I/0ojINwaApstZXi3A8habm
	 9TXh/qdKe8dv+i7zdROe35WmRaj/YKMyi9xztqD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0686/1067] netfilter: xt_connmark: reject invalid shift parameters
Date: Tue, 21 Jul 2026 17:21:27 +0200
Message-ID: <20260721152439.944115825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wyatt Feng <bronzed_45_vested@icloud.com>

[ Upstream commit 1b47026fb4b35bac850ad6e8a4ad7fc018e09ebc ]

Revision 2 of the CONNMARK target accepts user-controlled shift
parameters and applies them to 32-bit mark values in
connmark_tg_shift().

A shift_bits value of 32 or more triggers an undefined-shift bug when
the rule is evaluated. Invalid shift_dir values are also accepted and
silently fall back to the left-shift path.

Reject invalid revision-2 shift parameters in connmark_tg_check() so
malformed rules fail at installation time, before they can reach the
packet path.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_connmark.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 4277084de2e70c..2cf27f7d59b95f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -112,6 +112,16 @@ static int connmark_tg_check(const struct xt_tgchk_param *par)
 	return ret;
 }
 
+static int connmark_tg_check_v2(const struct xt_tgchk_param *par)
+{
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
+
+	if (info->shift_dir > D_SHIFT_RIGHT || info->shift_bits >= 32)
+		return -EINVAL;
+
+	return connmark_tg_check(par);
+}
+
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_ct_netns_put(par->net, par->family);
@@ -162,7 +172,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV4,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
@@ -183,7 +193,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV6,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
-- 
2.53.0



