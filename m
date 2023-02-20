Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472FC63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1259C433D2;
	Mon, 20 Feb 2023 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901020;
	bh=Lo9K4Oj/uKQmnA9GNGvASbRgCynWGiaDXIZ8tmik8ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHPGU765N7Qi7sOPP8KF87+ME8tl/O//2pfU58RtMe3Dynq30soqGO7LYumX/94CP
	 b1ZxJwVuu5ORIU/A35D0qhY7s/lc4ceXu9Z3c/e7T73TG+EPSr9GdwT6BYrdYvfHIy
	 MfdDtxqaGULvjyuTBiTq5Bc7ff6CcRzUWKRpbCW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 155/156] net: sched: sch: Fix off by one in htb_activate_prios()
Date: Mon, 20 Feb 2023 14:36:39 +0100
Message-Id: <20230220133609.140985189@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475 upstream.

The > needs be >= to prevent an out of bounds access.

Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/Y+D+KN18FQI2DKLq@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -407,7 +407,7 @@ static void htb_activate_prios(struct ht
 		while (m) {
 			unsigned int prio = ffz(~m);
 
-			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
+			if (WARN_ON_ONCE(prio >= ARRAY_SIZE(p->inner.clprio)))
 				break;
 			m &= ~(1 << prio);
 


