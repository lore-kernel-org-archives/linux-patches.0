Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFF079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B1FC433C1;
	Wed, 30 Nov 2022 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833557;
	bh=FhQqqWuJ6F8EHCReW61RTMLhlKsnEk/WF1GTOixciRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv1nH4vicOOIxwYDjQTfvP6wAm8VGpFEtZkXkj5h0ZiTuNlBnjQdyevOQiqmkRykB
	 6ir7z/MFQEUEVSqmY00m35t2jEvevQP/uQy9oLRoA17r4sxZ+cJT7vkYgs/icavCIO
	 2A+HB9whQLz5GjTyv5h32ddvQ/uwU52UGpfB6CSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/206] net: sched: allow act_ct to be built without NF_NAT
Date: Wed, 30 Nov 2022 19:22:44 +0100
Message-Id: <20221130180535.893850799@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8427fd100c7b7793650e212a81e42f1cf124613d ]

In commit f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT"),
it fixed the build failure when NF_NAT is m and NET_ACT_CT is y by
adding depends on NF_NAT for NET_ACT_CT. However, it would also cause
NET_ACT_CT cannot be built without NF_NAT, which is not expected. This
patch fixes it by changing to use "(!NF_NAT || NF_NAT)" as the depend.

Fixes: f11fe1dae1c4 ("net/sched: Make NET_ACT_CT depends on NF_NAT")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/b6386f28d1ba34721795fb776a91cbdabb203447.1668807183.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..4662a6ce8a7e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -976,7 +976,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
 	tristate "connection tracking tc action"
-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
+	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
-- 
2.35.1



