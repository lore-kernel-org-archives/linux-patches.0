Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030925;
	b=haMPHVcY7NF+smiUzrcjJ01ipGkDk+ngqm4jB4KEmsbYp/CknQ3g++sJkQmT0H92WkGb
	 PpZrHkYXbbOT6S24ETF5cE0VHBkTCqTshLOCrGNqgEZWe8KdH5tTVrfYEvz6vj1G6yMBs
	 /J9STeJXvfH8TuFRYv+vAAMGZdcOtJ3lDbTqWYUtZZ/DlY+AbsdfKXhxOMqSDg5kysq85
	 XvKDrqD3jT2YzgWXgtXrjI4eKxclmjGyfIlL3AqCSgkEe/b5ZQEb71cvi/z+vcNqSoAdX
	 R3IokWX4QlGgliwj4p3y++KuaS3s6EqPwvs5vXZKWprlOIhN/qWGsm564oNMFlWj47Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWmTvv1Mbqe1IA2xkYQhzlZPp2DujuPRpVKhFSrbrTM=;
	b=Nf6N8ufXtfJBoFXJuolEYhsOqZm5Nod+csK4KRhjobCxl2eRhADGUjrtgtiXRIuZE47+
	 gf6vXUlCs8+YnY57TWz961FkVtnt2pthBM30IRg+F3z+4iAEU/fT4NPqQKsfY6vD1Erwp
	 xgUNWrETXsmGZ4C/yaNaeY5XbxYRV65NGirEuvGJWIRqk/4W4cDiLMRrwix7qZHLj5sjH
	 m2waYM8jsYPi8DQCb9jXLyArJj9T+IT16/2382Qxa8CQR6H9XKuKJic/ah+z1MuH2C0RF
	 pY5U9zfip2e71LcTBhX2VhrUB+Z3GHaruIhpN6tzFC8JhFFai6SFJ470MeRrKLnxciQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u+PsCBY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF050606A7DB;
	Wed, 18 Nov 2026 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u+PsCBY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA481F000C4;
	Wed, 18 Nov 2026 19:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030924;
	bh=XWmTvv1Mbqe1IA2xkYQhzlZPp2DujuPRpVKhFSrbrTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u+PsCBYMgt8lgDNHG7g5NjwBsD1yWgrxdTCTU2ddXjFnyDU3vQLWzEMgMHEL3SR5
	 0yHe9JCkChkVxzQMuB6PaFpZ8MSjhG22UFh0ivt1T2P9DR7LdD2PfZpFNXzyQTHdeI
	 ot35p3qh8Y2eWUh9TERiOrRrlINzbn/d7tB4mRt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+619e27617b2abe6b9b72@syzkaller.appspotmail.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0874/1756] floppy: avoid NULL deref in reset_interrupt when cont is cleared
Date: Wed, 18 Nov 2026 15:50:01 +0100
Message-ID: <20261118150044.200104960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 7c82781039c03a3e47b70d3259f336adbb9d2692 ]

reset_fdc() arms do_floppy = reset_interrupt; the IRQ handler then
queues that function via schedule_bh(). If unlock_fdc() or do_wakeup()
clears cont before the work runs, reset_interrupt() dereferences a NULL
cont and oopses.

Example crash excerpt:

[ 1070.468148] status=80
[ 1070.468152] fdc_busy=1
[ 1070.468158] cont=          (null)
[ 1070.468161] current_req=          (null)
[ 1070.468162] command_status=-1
[ 1070.468163]
[ 1070.557051] floppy0: floppy timeout called
[ 1070.557053] no cont in shutdown!
[ 1070.557056] floppy0: floppy_shutdown: timeout handler died.
[ 1074.419509] floppy0: FDC access conflict!
[ 1074.419782] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[ 1074.421969] PGD 0 P4D 0
[ 1074.422320] Oops: 0000 [#1] SMP NOPTI
[ 1074.422648] CPU: 10 PID: 3269 Comm: kworker/u256:4 Kdump: loaded
[ 1074.423830] Hardware name: inspur Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[ 1074.424284] Workqueue: floppy floppy_work_workfn [floppy]
[ 1074.424757] RIP: 0010:reset_interrupt+0x3a/0xa0 [floppy]

The same NULL deref has also been reported by syzbot on upstream.

Return early if cont is already NULL after result(). The hardware reset
has completed; result() still drains the FDC. A later request can lock
the FDC and reset again. This is a defensive fix for stale work, not a
rewrite of the floppy continuation state machine.

Reported-by: syzbot+619e27617b2abe6b9b72@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-block/00000000000093c4d105f9aa34d6@google.com/
Link: https://lists.openwall.net/linux-kernel/2021/10/27/56
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260723073512.11120-1-yangxiuwei@kylinos.cn
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 95fa91a5f7f89..c38082f192a1f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1788,6 +1788,9 @@ static void reset_interrupt(void)
 {
 	debugt(__func__, "");
 	result(current_fdc);		/* get the status ready for set_fdc */
+	/* Stale work: unlock_fdc()/do_wakeup() may have cleared cont. */
+	if (!cont)
+		return;
 	if (fdc_state[current_fdc].reset) {
 		pr_info("reset set in interrupt, calling %ps\n", cont->error);
 		cont->error();	/* a reset just after a reset. BAD! */
-- 
2.53.0



