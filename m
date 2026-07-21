Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41283B8407;
	Tue, 21 Jul 2026 20:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666892; cv=none; b=TG/dhaKJYGLhkCd0IVY3YM0hedVL6iqjxIjB1G+B5ai+vpqbp+wrzENsHXz3yCuW3FEDyih8G0me5w/rVsh5B9tLhZI3/SVibG91rpRh0l/7YXwlhxPo1poHTBGWOXImzEukCUPFInPFt73IaIMxXpbPxPx9tWtEPwM6fF1D3qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666892; c=relaxed/simple;
	bh=Sc46aIsv5dGeCFipN5p0bxhvnPka/7IQ2SgrdifvOPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRqJjsJpHJhBmAaOHSl8ziCddiB7Wuw9WqM1h+oy+7L1QpHjM4TBr43hdMtttCp8xVvM5uNqy70qEKNqYL5XEcJ4rKBE6iRTh3VfONaPX7Ks46TL9K5taF8f7TOO0OtWSumSWoQlIziYb4f5FWHZ6EvrKhR2s/ZPq2IjaKQ52nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2icrzOTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2icrzOTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B381F00A3A;
	Tue, 21 Jul 2026 20:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666887;
	bh=+6N5EStLrlKGM979jESRifm+ia+22OUw5ZludxHrgKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2icrzOTc7MLKpt4PnyXx7UST2HUJgujImAIzNrQ+nKGLNTkxrJasXbXSGOLAw0q0r
	 MPtkTi9LhP3jUxLIF8SbtWTpfbvrlsgTQFjqbFZtdDMAOVHy9JFNqnQjkpS4G9bkCq
	 TdszfIIxFP2NWFVnhvf5Qe6q+hrzu+Qy4UUrMHPQ=
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
Subject: [PATCH 6.6 0853/1266] netfilter: xt_connmark: reject invalid shift parameters
Date: Tue, 21 Jul 2026 17:21:30 +0200
Message-ID: <20260721152500.940919335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



