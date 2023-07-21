Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318E91ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E43C433CC;
	Fri, 21 Jul 2023 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965579;
	bh=3reMpJCmXi7Tx5AeKzTIW3Pbo1CiFaY9ja0+oU0Bxts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ijnWYhV414pPXhk/Uz+EDbPOSUjoRNTj6GfwNTQE9a4uLTyqDIFr33CSXSwiFUYQ
	 JbcKBKCHhUYE2NwIK0AO94QnODSBzd5lHTEjlqzD6adnavRRCQgTvGYAkHVD9smvpc
	 3MbxpyQOBRmZMvoQPxKzpGdGirSbgLa/d348EoZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/532] tracing/timer: Add missing hrtimer modes to decode_hrtimer_mode().
Date: Fri, 21 Jul 2023 17:58:37 +0200
Message-ID: <20230721160615.390353694@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2951580ba6adb082bb6b7154a5ecb24e7c1f7569 ]

The trace output for the HRTIMER_MODE_.*_HARD modes is seen as a number
since these modes are not decoded. The author was not aware of the fancy
decoding function which makes the life easier.

Extend decode_hrtimer_mode() with the additional HRTIMER_MODE_.*_HARD
modes.

Fixes: ae6683d815895 ("hrtimer: Introduce HARD expiry mode")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20230418143854.8vHWQKLM@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/timer.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 1cf012de6442e..d49e44fcc10f2 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -156,7 +156,11 @@ DEFINE_EVENT(timer_class, timer_cancel,
 		{ HRTIMER_MODE_ABS_SOFT,	"ABS|SOFT"	},	\
 		{ HRTIMER_MODE_REL_SOFT,	"REL|SOFT"	},	\
 		{ HRTIMER_MODE_ABS_PINNED_SOFT,	"ABS|PINNED|SOFT" },	\
-		{ HRTIMER_MODE_REL_PINNED_SOFT,	"REL|PINNED|SOFT" })
+		{ HRTIMER_MODE_REL_PINNED_SOFT,	"REL|PINNED|SOFT" },	\
+		{ HRTIMER_MODE_ABS_HARD,	"ABS|HARD" },		\
+		{ HRTIMER_MODE_REL_HARD,	"REL|HARD" },		\
+		{ HRTIMER_MODE_ABS_PINNED_HARD, "ABS|PINNED|HARD" },	\
+		{ HRTIMER_MODE_REL_PINNED_HARD,	"REL|PINNED|HARD" })
 
 /**
  * hrtimer_init - called when the hrtimer is initialized
-- 
2.39.2



