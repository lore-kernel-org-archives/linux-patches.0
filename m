Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90711168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162FAC433D2;
	Mon,  8 May 2023 10:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540918;
	bh=R35TOCD5/AImE9JcPW5JHgmoxxXW/TS0osNgU9G0TiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woizfE9oOrxnrjmlZF07mt4saxx1hvzx3pYbmDV9L8AwcBw7RLOZEAHVh8UfKTw+o
	 jY4qyQJQ62NNm21W5YBrSZSuXXud8yL1gNee0hQWkfKV0zDym/SpWY0RjcJClJB2zT
	 3QXNGRqNFtx0jpQyYHsi5217qeauh9suQMwkWb/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 520/611] timekeeping: Fix references to nonexistent ktime_get_fast_ns()
Date: Mon,  8 May 2023 11:46:02 +0200
Message-Id: <20230508094438.928830919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 158009f1b4a33bc0f354b994eea361362bd83226 ]

There was never a function named ktime_get_fast_ns().
Presumably these should refer to ktime_get_mono_fast_ns() instead.

Fixes: c1ce406e80fb15fa ("timekeeping: Fix up function documentation for the NMI safe accessors")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/r/06df7b3cbd94f016403bbf6cd2b38e4368e7468f.1682516546.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f72b9f1de178e..221c8c404973a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -526,7 +526,7 @@ EXPORT_SYMBOL_GPL(ktime_get_raw_fast_ns);
  * partially updated.  Since the tk->offs_boot update is a rare event, this
  * should be a rare occurrence which postprocessing should be able to handle.
  *
- * The caveats vs. timestamp ordering as documented for ktime_get_fast_ns()
+ * The caveats vs. timestamp ordering as documented for ktime_get_mono_fast_ns()
  * apply as well.
  */
 u64 notrace ktime_get_boot_fast_ns(void)
@@ -576,7 +576,7 @@ static __always_inline u64 __ktime_get_real_fast(struct tk_fast *tkf, u64 *mono)
 /**
  * ktime_get_real_fast_ns: - NMI safe and fast access to clock realtime.
  *
- * See ktime_get_fast_ns() for documentation of the time stamp ordering.
+ * See ktime_get_mono_fast_ns() for documentation of the time stamp ordering.
  */
 u64 ktime_get_real_fast_ns(void)
 {
-- 
2.39.2



