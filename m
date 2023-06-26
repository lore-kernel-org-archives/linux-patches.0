Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E89134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3799CC433CA;
	Mon, 26 Jun 2023 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803800;
	bh=7GvhKF1iSDbHO+OCyxzAUWOgKaaTaZ+MHS1+Pk9HtO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al4xpExS0lMuDW8VM7wUZoGrAZyR1Wp3EwerqKwujQsJV+3x6KTLuvh2EqGGx2Jxq
	 7JmLMpvVEbuZNCGpR5a8C+VUuSUQxB6K+JHMXgGnnOHSfhp14ACslr0xGaHjH+pbbS
	 9lbjQrg5h0yNzmgIm0lSUpJCKaM2g/rc9SXB6tXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 180/199] net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE
Date: Mon, 26 Jun 2023 20:11:26 +0200
Message-ID: <20230626180813.655617170@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 8cde87b007dad2e461015ff70352af56ceb02c75 ]

This patch fixes the following sparse warning:

net/sched/sch_api.c:2305:1: sparse: warning: symbol 'tc_skip_wrapper' was not declared. Should it be static?

No functional change intended.

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Acked-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 3f7311529cc00..34c90c9c2fcad 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2324,7 +2324,9 @@ static struct pernet_operations psched_net_ops = {
 	.exit = psched_net_exit,
 };
 
+#if IS_ENABLED(CONFIG_RETPOLINE)
 DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
+#endif
 
 static int __init pktsched_init(void)
 {
-- 
2.39.2



