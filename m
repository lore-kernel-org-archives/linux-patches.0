Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA8211CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E4C433C9;
	Mon, 26 Jun 2023 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804918;
	bh=Girculq8WNjdGq0XvLOlu4PytQvEU9ZgR4wgY9fPMog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1Ek5ATKREbYx3z0gvg4RvZWpKXfLpuDLgYrrsCvmSOPc1gfNv7XNDK3xBe1i7Ble
	 2bEHrsrwfnVizZluk8VuIwEgHhhBYhlSIMa7BLH7uWHrt3AQ133Z7b7mcLQVltQu8+
	 3FW9lutR4h3FB8PQOZIRpIoHEDaxpobpDvkVV330=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/96] netfilter: nfnetlink_osf: fix module autoload
Date: Mon, 26 Jun 2023 20:12:23 +0200
Message-ID: <20230626180749.782614223@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 62f9a68a36d4441a6c412b81faed102594bc6670 ]

Move the alias from xt_osf to nfnetlink_osf.

Fixes: f9324952088f ("netfilter: nfnetlink_osf: extract nfnetlink_subsystem code from xt_osf.c")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 1 +
 net/netfilter/xt_osf.c        | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index ee6840bd59337..8f1bfa6ccc2d9 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -439,3 +439,4 @@ module_init(nfnl_osf_init);
 module_exit(nfnl_osf_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_OSF);
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index e1990baf3a3b7..dc9485854002a 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -71,4 +71,3 @@ MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Passive OS fingerprint matching.");
 MODULE_ALIAS("ipt_osf");
 MODULE_ALIAS("ip6t_osf");
-MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_OSF);
-- 
2.39.2



