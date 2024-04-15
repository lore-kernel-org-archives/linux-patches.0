Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6B1E4B1;
	Mon, 15 Apr 2024 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192128; cv=none; b=uuEvQGvJ9BfvQZo8y4CZxhaAUqKlx/jA5dcltIXBdrHxcTdiNH+ndqyMH592mAFzixsg9abGQZFltMqh6sCQ/8FEX1bmK1EpcqL62381n+3w2ZpmJWsXetrCsW1ofX0S3Ia8M3U/StYLtY8pb4+z9tSBKNI5hZpE7UzZLBILfXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192128; c=relaxed/simple;
	bh=VvGlRyWUYjUyH1MhARQ4QU1d8NCqBinMpq8lByMO/0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3kdtxu5O1GXMx0Ni7zZ8rvF8/7c05AURKAvzKtDTz8XWfILgAIUx+2IgZYvymL/vqcmnvlc7QQdJz67OoSSru1/llWqU+l+TTqU93mSPiZyqOfDGlMijC+nJuED8AiN7BEn9yDcDGUNHPLgwKEBsDBJ/dAC0vINSsGqqcbHcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0XiWjvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0XiWjvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA47C113CC;
	Mon, 15 Apr 2024 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192127;
	bh=VvGlRyWUYjUyH1MhARQ4QU1d8NCqBinMpq8lByMO/0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0XiWjviVOF2wFRqh+4+yDknrpucY/61xtv9zuDs2y7YXhsnsZYWM3KolRxw/Ifa6
	 VWY8dBdxNgHBMoTDu5LFzeLSvDUsJJe/ZoUzHUMs/pt1LqlQ2y+m833H0yHodfJYNM
	 gsLg/hgmGwIBqGGixBywloNl7se8r3U50dHZkBP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.1 56/69] irqflags: Explicitly ignore lockdep_hrtimer_exit() argument
Date: Mon, 15 Apr 2024 16:21:27 +0200
Message-ID: <20240415141947.856384537@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c1d11fc2c8320871b40730991071dd0a0b405bc8 upstream.

When building with 'make W=1' but CONFIG_TRACE_IRQFLAGS=n, the
unused argument to lockdep_hrtimer_exit() causes a warning:

kernel/time/hrtimer.c:1655:14: error: variable 'expires_in_hardirq' set but not used [-Werror=unused-but-set-variable]

This is intentional behavior, so add a cast to void to shut up the warning.

Fixes: 73d20564e0dc ("hrtimer: Don't dereference the hrtimer pointer after the callback")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240408074609.3170807-1-arnd@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202311191229.55QXHVc6-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/irqflags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -126,7 +126,7 @@ do {						\
 # define lockdep_softirq_enter()		do { } while (0)
 # define lockdep_softirq_exit()			do { } while (0)
 # define lockdep_hrtimer_enter(__hrtimer)	false
-# define lockdep_hrtimer_exit(__context)	do { } while (0)
+# define lockdep_hrtimer_exit(__context)	do { (void)(__context); } while (0)
 # define lockdep_posixtimer_enter()		do { } while (0)
 # define lockdep_posixtimer_exit()		do { } while (0)
 # define lockdep_irq_work_enter(__work)		do { } while (0)


