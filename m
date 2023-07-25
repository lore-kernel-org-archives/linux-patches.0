Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFF31ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B62C433C8;
	Tue, 25 Jul 2023 11:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284919;
	bh=oaLozk9NbJEk3IUbC1+IlVGrGLMgZUywCXTwhbZgeMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+Rz52mF5Elt8PULYkZq5JiXcXX0xcrdSD2YsNanJ7I0PlfRc/g4mEDPWHEtXw+vW
	 2GbPKs47Ffv/sKX4uq4KEPiP/I918/OWeenwol7kGs9e7Lzu5AoykL0gU/JS8dpBH9
	 TrgM8e7tl3qeLL1FMJfzlCh/qkrCmWitDkuajFcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/313] tracing/timer: Add missing hrtimer modes to decode_hrtimer_mode().
Date: Tue, 25 Jul 2023 12:42:52 +0200
Message-ID: <20230725104521.968686704@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index 295517f109d71..1b5371f0317af 100644
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



