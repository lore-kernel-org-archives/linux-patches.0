Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061230;
	b=Iz0OfEgby6RYOmvxk3dmlx0sM8cvNkOkt3u9fhdAg8EfArjjPqcyNe1nRBpQkZom8/27
	 L368+TMC+/NzbkaqWMOOCr9H7lSPDJMPhzxDPH7+gnS2pryWO/Z2Gnp3bF9WAxJ0gfWwk
	 Q99jxX04r0oFTKVxzoxBAmukgQTLFQYoTyFASvZ0H/omtHZHNyCOSVyPp20E6uPxFZH0H
	 SZ9rKgi1mPY+CmkH1Va0pezIAk6i2KCrl+6RixBgLS3B7QvI6gwgvDUZoQYAdErThEJKJ
	 Waa7Ezaa5fa5/5WZMMIkDg8hp0G9lrgFxtmLUo2rSpCntz3cc1yPBbunmQXO6orL2AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0sZ5JFaLQawuQS+i9zyiDAMMGwh8S1bicaPFsaHUOg=;
	b=W3+RmxGVsC3g/SFqOVh1KZ4cAfZvFHX26U4E8Js8moU3KwV/KMdEIJpv1MHhwk/6Jx17
	 dlS6cOHYkE3RgI4d2z35hap0AEDCug5BO2PXwQwzb5xfIvlk90jE/rSrlhptV3u++E4Lw
	 VjeZKBNm06/kBP+nHP4C2U0IecbJSEDyihsIlXpAHkwsZOhqwyh14LbV9nqowfASPBs/B
	 7vkX4bocFl19H/spjPEwQHq0fZqnTPA6na2oGp7gTpod/aE2mFmTyg5WNqUvf6WQ9YtSz
	 mqoDjWO4sKda+NR9zc7HC4b5Kd+S9rEF5/kExv8r31oFRt9Ju0SfI4GgWTrDv9hwPCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9V+1Ws0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED02606A325;
	Thu, 19 Nov 2026 04:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9V+1Ws0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605751F000C4;
	Thu, 19 Nov 2026 04:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061229;
	bh=j0sZ5JFaLQawuQS+i9zyiDAMMGwh8S1bicaPFsaHUOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9V+1Ws0L1hV2bl9JWo0zf0GqpyaHCI9QX1O4W1Zurfeb2gboqBUqz2A7Vm63JKtH
	 RN+m6ETCufgdgv33yE1x+3zI1KtxFpGvckGSObBFUXkGUX34n2MzF++7Uzx7zT6yse
	 vmFgjQ1t1x2+ulSVBvZOvaLm+Sw5hyqAp5Yor6yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+619e27617b2abe6b9b72@syzkaller.appspotmail.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1479/1848] floppy: avoid NULL deref in reset_interrupt when cont is cleared
Date: Wed, 18 Nov 2026 15:58:37 +0100
Message-ID: <20261118150021.192471931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c7a8ca9ef6767..135ecb2cb31fc 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1785,6 +1785,9 @@ static void reset_interrupt(void)
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



