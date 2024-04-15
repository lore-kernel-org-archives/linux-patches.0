Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B436AE0;
	Mon, 15 Apr 2024 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191849; cv=none; b=E2HP4Xc7w0i+6piJSQKu3xkkoOKmfUHTjIuNqksZJg1Bj3NcK1Hg+mI3anVqwJbQ5NxFFB3Il9Yl0g9kjFapybHd8YZipYYqMl2FzhcrPDYHE1haMSUvbWszWabX9GLL14MNwnQP6HGeTzGd1Ohw0fVaugz/7Li3sTFfDCcOazM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191849; c=relaxed/simple;
	bh=ji0/mkmFCyk1geDqjD4QDgoPG3euPD0v0/N19xyv0b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLMreOzp/ZgSsK7/15QCh0YbmwXKXBG3JTblYgrTPWuvxnBAoVq8c4ZSthp+705TMCrFsCofJ/vaJ3HMhX07gBMufLaK8h67DkEBN2rqF3cWKnAW6ZEsbeKDD9VFXF+PRaKiM5saqt+OVVG1fPVfhxZmkfX7j0l4YD1k3pH3aH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI2wiDJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI2wiDJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC6AC113CC;
	Mon, 15 Apr 2024 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191849;
	bh=ji0/mkmFCyk1geDqjD4QDgoPG3euPD0v0/N19xyv0b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI2wiDJjtButDZEyu6D/RkpvS5g65GXaOmQ33WJND+Fnx39Zzmw5+36/D1RQc85F/
	 Ai4u6Z74uxaErO1R/Cl/uJtgzKuDsFEO9ARB1zsEdJa/IUUX8pa9gj2QJrZ8oHOoLu
	 JndIX7oUHoTfHpT0WLMlZICga1+dZJiBZOJ2Fb+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.6 106/122] irqflags: Explicitly ignore lockdep_hrtimer_exit() argument
Date: Mon, 15 Apr 2024 16:21:11 +0200
Message-ID: <20240415141956.555156105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


