Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83233793B0;
	Mon,  9 Feb 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648806; cv=none; b=Xpym/Z1ZFmt1lpaCh00EjC0bmNLpe6SF8uS8QxdNAJ+wwQIx9QzDAsAAuleOKzmk9ReFXv1Brvzs8pVax8LS+KN2vR6Ia+6EOJfGIHTBp3NAHoKB/XpF9/XC/t1WMyqTpL0fyjdVJXj9i9UY6ys7qLo8nhgRLCpuD4trhD8fuGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648806; c=relaxed/simple;
	bh=dYVpBr4jjdIdteALwrfXTBta3ydDyqYWJhHl0VvdxGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MNOuMnNSLKm/Dj1Lav4weBUmOpyN0Q4Wj3r5mRWQ3DT++qw+2QV6x8mgu+aDU+bFQqxF120pfi1u0oZ9n2sGSLGhI6vUWcpH4GFTJP/ePFq6o7tNY0AgCjjscll4ncUBjQJteG04xvsVbIbAF/BrwsaqA+MXKR4PbkQ5Ut6jjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBofDNeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBofDNeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956DAC19422;
	Mon,  9 Feb 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648806;
	bh=dYVpBr4jjdIdteALwrfXTBta3ydDyqYWJhHl0VvdxGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBofDNeFkB8J9hWJvLaFzUbWjcS4rYBrp2WQnfxi7eBjjbC8HozLjpP1YXdrrRRrt
	 z1JZOE2KMzAt866vnAEKiDg9xvd0brsaPgkEvn5igqi3ZySsD5TsN1buErvS3rj1Gy
	 4oI362ALDqSSUccMvEc30xL80l4jeThgbMIzgrXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 20/75] timers: Update the documentation to reflect on the new timer_shutdown() API
Date: Mon,  9 Feb 2026 15:24:17 +0100
Message-ID: <20260209142302.572912888@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

[ Upstream commit a31323bef2b66455920d054b160c17d4240f8fd4 ]

In order to make sure that a timer is not re-armed after it is stopped
before freeing, a new shutdown state is added to the timer code. The API
timer_shutdown_sync() and timer_shutdown() must be called before the
object that holds the timer can be freed.

Update the documentation to reflect this new workflow.

[ tglx: Updated to the new semantics and updated the zh_CN version ]

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20221110064147.712934793@goodmis.org
Link: https://lore.kernel.org/r/20221123201625.375284489@linutronix.de
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/RCU/Design/Requirements/Requirements.rst  |    2 +-
 Documentation/core-api/local_ops.rst                    |    2 +-
 Documentation/kernel-hacking/locking.rst                |    5 +++++
 Documentation/translations/zh_CN/core-api/local_ops.rst |    2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

--- a/Documentation/RCU/Design/Requirements/Requirements.rst
+++ b/Documentation/RCU/Design/Requirements/Requirements.rst
@@ -1858,7 +1858,7 @@ unloaded. After a given module has been
 one of its functions results in a segmentation fault. The module-unload
 functions must therefore cancel any delayed calls to loadable-module
 functions, for example, any outstanding mod_timer() must be dealt
-with via timer_delete_sync() or similar.
+with via timer_shutdown_sync() or similar.
 
 Unfortunately, there is no way to cancel an RCU callback; once you
 invoke call_rcu(), the callback function is eventually going to be
--- a/Documentation/core-api/local_ops.rst
+++ b/Documentation/core-api/local_ops.rst
@@ -191,7 +191,7 @@ Here is a sample module which implements
 
     static void __exit test_exit(void)
     {
-            timer_delete_sync(&test_timer);
+            timer_shutdown_sync(&test_timer);
     }
 
     module_init(test_init);
--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1010,6 +1010,11 @@ calling add_timer() at the end of their
 Because this is a fairly common case which is prone to races, you should
 use timer_delete_sync() (``include/linux/timer.h``) to
 
+Before freeing a timer, timer_shutdown() or timer_shutdown_sync() should be
+called which will keep it from being rearmed. Any subsequent attempt to
+rearm the timer will be silently ignored by the core code.
+
+
 Locking Speed
 =============
 
--- a/Documentation/translations/zh_CN/core-api/local_ops.rst
+++ b/Documentation/translations/zh_CN/core-api/local_ops.rst
@@ -185,7 +185,7 @@ UP之间没有不同的行为，在你�
 
     static void __exit test_exit(void)
     {
-            timer_delete_sync(&test_timer);
+            timer_shutdown_sync(&test_timer);
     }
 
     module_init(test_init);


