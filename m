Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7BEC433EF;
	Wed, 28 Dec 2022 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239975;
	bh=cPiucVB+lQ5BIgLNGhp1LWwg126blwaS1B5Ekx4K8kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDSU+ABFmvTyPOlu7oF0ufdKaY/4U6a6Goacrpo8OW40umY8AQ0YDBvpT2KFwvKNX
	 fw1LkID5q0STNwizEikGZY8WCi6h5mnJ/tBgheNcmEKuc+fIYjTlxggHYpwb92H3DI
	 j59n25ozRNH9wgAiIsaoGOkjzfJgigtgXfq7f3DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0103/1073] alpha: fix TIF_NOTIFY_SIGNAL handling
Date: Wed, 28 Dec 2022 15:28:11 +0100
Message-Id: <20221228144330.844611248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e2c7554cc6d85f95e3c6635f270ec839ab9fe05e ]

it needs to be added to _TIF_WORK_MASK, or we might not reach
do_work_pending() in the first place...

Fixes: 5a9a8897c253a "alpha: add support for TIF_NOTIFY_SIGNAL"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/thread_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index fdc485d7787a..084c27cb0c70 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -75,7 +75,7 @@ register struct thread_info *__current_thread_info __asm__("$8");
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
-				 _TIF_NOTIFY_RESUME)
+				 _TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL)
 
 /* Work to do on any return to userspace.  */
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
-- 
2.35.1



