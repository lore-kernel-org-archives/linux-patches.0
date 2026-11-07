Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061111;
	b=t6mZm0CZIgSiFWXG1hIb86FMIKmxkGLbnlpwkw77qMkKUAXFD1ztlRF0tNogsNEvqRc9
	 5wEUA5XF8//xBdsGrg3d09mY975Dd91zNIT/twaun8J/nKn/V5GXj32SW+TG7d5zsuUjA
	 xLE4LTDFJtYGAMFXMovb7c2D5ew3cvPVDBp/nlQmlamG0J/6qImC0vg6Em6509xvQdY7a
	 6Z2MKpjs9ZsRrgYtyfBnmsNYPDN70y2jzeo/A7/LEgOr8lsnTJ4mGpGBM+s9RN6UBoOlW
	 A55VUjIJo8O/OIjOo4mkaT72rroF7eciqfo1PqEiUn2vyV5OoNLx7vH3Bqqx4Pr7FnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g38MTfDFINc+qVHXu48y+iGUG+zdZ1pBV1WojDJc1xQ=;
	b=mSulK62At/ExuKkHRkIez6ls7PXtVwLZYnjRWorW5N3H1ipmD/5FPdv3MEQm9IfSQ+UQ
	 DNSOenqhXgePqae5NK9jRQaNTqSQpiajswl3/cvOqGuwjX/OFt9rl4i8HgXrQwxOgtbCW
	 GjUszf5zuuz7DXInBURfURczBRxt9cyi6q+Ts+cdSibgGYtcZhdBipIO+Q0Td0LnfHQZ3
	 DjKYiIaKgY/9YCZ2grtfXNUYqq1UCzklOlpG+rW4ZoLPG08K922FCvBRVAzG9xt8gqopr
	 juIkiGw8Dh2MNMXvg0XQeYOhlBuEXIzxBFteDNIam9zutOXdxt/na7G1bP7TzF/tFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zefXU/do";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C8C606A332;
	Sat,  7 Nov 2026 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zefXU/do
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8275B1F0089F;
	Sat,  7 Nov 2026 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061110;
	bh=g38MTfDFINc+qVHXu48y+iGUG+zdZ1pBV1WojDJc1xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zefXU/doqzbT8VsV3h5Z+VcZ5Yq19PO1iK8A8VojZV5GDRjIfm3t9WGR1i907EVGQ
	 OqJkkcmuF6snPe5iSttnv4lHg/VUtEvdU4ujOFd6dVX4WMVYSS5ivcEVG4yZDE8MrB
	 RfaJc/sF1zlryKP+N+BgtV7Kq4kOEhrgPhrdkmWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0428/1536] nbcon/reboot: Switch NBCON consoles into the emergency mode in emergency_restart()
Date: Sat,  7 Nov 2026 08:40:44 -0500
Message-ID: <20261107135009.586756201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 24c5bc26385af..caab5c86c6e29 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt)	"reboot: " fmt
 
 #include <linux/atomic.h>
+#include <linux/console.h>
 #include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
@@ -85,6 +86,14 @@ void emergency_restart(void)
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



