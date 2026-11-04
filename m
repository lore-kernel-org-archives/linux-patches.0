Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831188;
	b=d1DTMNq2pfFH61cW37qoJjYofKXJsp7Wkn59mw5t6bejWi9NPtpJcEK3NcWr/xpPZDjR
	 5T/6V5PP6TXRDFe8mM83SaHve2Z19ZZWQ7lCKa6S7lbk4HXHiGOI9zTTde912dOqMYWsN
	 g/4mdXhGbJmpYtSQhQAqp5FAJTfFkRWy8oaViDRYZu164hM61pICoEWoXyzqKcUmKZZ8y
	 0TArxC6xtdBC7Vs3ShqW0jV0BE3t6bwfdZXKYbSGEcCulBPNNhSVW6TZ0/Sm9spHfBjKT
	 b9r2XqCqlh4pFQGOgfFtk/f7KNb8i9J1uHc0ZgXHyotXp1RQbTXC3pr9AjPbFGftE4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2XzMA4V46XVki5S/IxX/AH7acP/pRv0z1/ftdWDm3/c=;
	b=MdP6chMTJyTxjOj8Ro71GsmrqKROOcbPKzyG/NRCpaVsJCqsZu3hcQzjBujJvRcVQVdu
	 SEBvrmZVR1nZxZ1t9Y9ErQEa7FCqpZDxpGF3NqVMN1RzKt+19sZZ0E8LkbzsrctPH3S9E
	 4cAZZ/zLqOVMHIl2lw9zTVpJYHRGu7lrrgrlrZm9hJpFtpDl8ShJFCV5VPP2ucriyiOIs
	 1Wnndi4F+k2iiTISe7faY2u1r91Hy/D1ukUOaFxfT4eFqj4Hh80x3tt3cfzUokMJpceQg
	 TBPG3IgIWsTczX4Aex4zt36VKTI+oCk+xUgv8JXwHIXTO4c4+9ohcb9akERJnSvhfsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjdePdBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8223B606A853;
	Wed,  4 Nov 2026 22:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjdePdBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E14E1F000C1;
	Wed,  4 Nov 2026 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831188;
	bh=2XzMA4V46XVki5S/IxX/AH7acP/pRv0z1/ftdWDm3/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjdePdBVODRUrVY0tCAP0LNxF8qjzoc1cK3otTAZ7s3g2dgeYp5eNKqJpQ61Zn9iZ
	 Vod5zkoDJFxVpFA3pSiLD7/dlgLn9kdA9EUN6mNdqYaq6Vdx+BD2C05j+V5gMOX0Qm
	 hUfzFGLi6L41NAMFGaPBn2z27V1tulQnvi/MD04A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0513/1005] nbcon/reboot: Switch NBCON consoles into the emergency mode in emergency_restart()
Date: Wed,  4 Nov 2026 16:04:06 -0500
Message-ID: <20261104211058.302900491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit d8e5fc3002294a28af53e97f6c83a35956e738f3 ]

When the system is going down a normal way, the NBCON kthreads are
flushed and stopped properly via a syscore shutdown callback, see
printk_kthreads_shutdown().

One missing piece is emergency_restart() where the kthreads are not
stopped. It might be called from several non-panic code paths,
e.g. sysrq-o, kdb_reboot(), or some watchdogs.

Fix it by explicitly entering the emergency (atomic) mode and trying
to flush the consoles there.

Note that printk_trigger_flush() must be used instead of pr_flush()
because the later is not safe in an atomic context.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202608061008.48a1e76e-lkp@intel.com/
Suggested-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20261013154141.94016-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/reboot.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 61924a0560c42..665a25684c70a 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt)	"reboot: " fmt
 
 #include <linux/atomic.h>
+#include <linux/console.h>
 #include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
@@ -94,6 +95,14 @@ void emergency_restart(void)
 {
 	kmsg_dump(KMSG_DUMP_EMERG);
 	system_state = SYSTEM_RESTART;
+
+	/*
+	 * NBCON kthreads won't be flushed and stopped properly in
+	 * the emergency restart. Move them to the atomic mode.
+	 */
+	nbcon_cpu_emergency_enter();
+	printk_trigger_flush();
+
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
-- 
2.53.0



