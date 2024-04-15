Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D722A8D3;
	Mon, 15 Apr 2024 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192223; cv=none; b=GojMXfn1G3nNAb4QzIxYfcJzc/lj2oKHQopj6s85dTwTI/LqWMqk5ssbvC509fFsXKTLsazTKnIPcbSSG9DlDmKcNgDjIs8/X0Mb3X4B3ty1wNqh3X7ovTFz4JRyTztUsknmE9OZ5/scRT/rf4GjYR+MJIkXM53RSZbOJYYp/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192223; c=relaxed/simple;
	bh=QplOc3QWQBTGvzSdsrnvXrb0ni6aSic21Br/25WrTmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9YjKgRz4vADV0j063u3QbO36O3EZ381D8eQH1nZUMHBRKuP/GVxStQLluGK/864Lc50rMJXjSRcYQ7BQOSsVZUN3pDS7MN9tVutfZNE2OS31uDxk0/1i0pGy+8Ii6VmV8OrXS3k4fWiRQFV55tyAF8rQBMUaeK0iwVT8BUtBqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJzPQBga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJzPQBga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE54C113CC;
	Mon, 15 Apr 2024 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192223;
	bh=QplOc3QWQBTGvzSdsrnvXrb0ni6aSic21Br/25WrTmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJzPQBgaW1gyYYmIb0jwdBb7Sl2aPcgYoUU/Kzwh/brA0t5NKYn8hSm5xcQZuwkYJ
	 VSmScTo8S83ygkNy7BTdzLPJjxMoqx5qQTQHq0nvhjKUYm7DNFbHFloFAszCJgbO2w
	 ghOxBT9Qkc/Ld/aogj/7GUPcet8n9zWJ50CUeQSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.15 36/45] irqflags: Explicitly ignore lockdep_hrtimer_exit() argument
Date: Mon, 15 Apr 2024 16:21:43 +0200
Message-ID: <20240415141943.328407143@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,7 +133,7 @@ do {						\
 # define lockdep_softirq_enter()		do { } while (0)
 # define lockdep_softirq_exit()			do { } while (0)
 # define lockdep_hrtimer_enter(__hrtimer)	false
-# define lockdep_hrtimer_exit(__context)	do { } while (0)
+# define lockdep_hrtimer_exit(__context)	do { (void)(__context); } while (0)
 # define lockdep_posixtimer_enter()		do { } while (0)
 # define lockdep_posixtimer_exit()		do { } while (0)
 # define lockdep_irq_work_enter(__work)		do { } while (0)


