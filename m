Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC2522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA47BC433C7;
	Sun,  9 Jul 2023 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901560;
	bh=5oj0Oh/qqw+ZETpDIJ4JtdfnfpvuvSIXqopL1OZEYRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCs31jOcQIntWTYsICa7TEQTf4u+LRudZGmxhTAK1J3aKQkKYs0rkhgmiDQWbFPTG
	 Eo9DB0TE6txY1qNHBqGA+ET87pgJMUFwF5A4TH8tGBXwUcHamLB+Kd5eBkaGCM2/LU
	 izXCOwhrwiogI4Pdp7hmKexDa26MZe4VS0i3Cr/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 035/431] tracing/timer: Add missing hrtimer modes to decode_hrtimer_mode().
Date: Sun,  9 Jul 2023 13:09:43 +0200
Message-ID: <20230709111451.920374746@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 3e8619c72f774..b4bc2828fa09f 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -158,7 +158,11 @@ DEFINE_EVENT(timer_class, timer_cancel,
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



