Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D753074AC;
	Mon, 27 Oct 2025 19:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592206; cv=none; b=MzJ6I5M3CUQnhaF1f6W7FHr1bAqU6GiASkeR4X1TzeKJVZTX1Z2ktaC42OQ11GMUznmYmUHLaaecAW83KfMi47lMr1tjiAp3ca9WiKX0UKZwuK08eduXiR3nks9SxPmBc/rH/Ua7X9kCCfg6IcpHR9UwPeHT/YN9bRHC0w376f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592206; c=relaxed/simple;
	bh=O0wCLIIhrKe6gzNvyeZU6Jl5T+5tvl033kbwrhONB/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KAkn3uWHNPn5gAbV7vTsefRXx7vl7/PVWiH/libSTetZRPzSqunZ2iXMmHvPFmEqPpuE3tMMQ0iYXD3Bcy0cmS3GV9TL0Lf+E+3Wgwl+xhyWETgd0mU32q4oEgOzyhIwikpvZRE9oDOUDkDg24UXBlwv5izchd6FNi7iKfgxnwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnXkdjiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnXkdjiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7624AC4CEF1;
	Mon, 27 Oct 2025 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592205;
	bh=O0wCLIIhrKe6gzNvyeZU6Jl5T+5tvl033kbwrhONB/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnXkdjiL0qIml7G1objS4OG+zOzoWzr9D5wBYKY5Jb6xFXo/LTck3UuhHP4dQoO3l
	 gLiGyQ77aycjMVsIggFl6O2e6UIHA4HEdEvTG7ewuh6NT4OfmNJEaqAVQflWt9718u
	 O9kcIOzzVN8xLJBnSArW1f/ofRvlTLzpJdy4ioSg=
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
Subject: [PATCH 6.1 033/157] timers: Update the documentation to reflect on the new timer_shutdown() API
Date: Mon, 27 Oct 2025 19:34:54 +0100
Message-ID: <20251027183502.181276872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1007,6 +1007,11 @@ calling add_timer() at the end of their
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


