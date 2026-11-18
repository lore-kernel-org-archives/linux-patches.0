Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018680;
	b=0AaG9e3+5cb2PSUCUm/y+hMAGrhAbTbanY9Lifb6kHfg2Osqq4uxb0QmeGqn+h6LugBb
	 gLQT0mavWlCwuVGIo5NS9K8HqCP4iFuHGjOjBjc8hBvgKWMfk1XsmfnY1x8HnEHBmLNmf
	 voKwTAzki6aiB3xDQ23wsiPhepqnRlMgkG4XvxGe+cjkln4I2VC3ezSFm0PmxMCNGXJwz
	 bkGVAG6uX8YJF1OT9ivgjOOt521qweb8eHtpDB7iAwNAOEzK1AO59ZXCM+DQ8wTIiYF/F
	 0ofqukYSUFHXtcR0ZBnAhD4SEqA3F1NULe9Lk137Jc6+fuiH5kX/zNMywUOTwqUp2UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlNEiNTAdT39GVLGoD37c6srH5ys0v+OAzrRq6XMSoE=;
	b=XyINZV0Vhr8TIvn4vwcgbEuQi/BcQ/+jfp4eiXNx5lX5Oj2Q5wwVLAQZNwfjshDHf5Ph
	 evLOtQxWY0+PHj6PHG+F9q+m51ptVD/ukBoiK85jKI5cNZPYhdcjmqifWmi3kWiFPNDPI
	 zth+EoSvtdfNC9mNaAivNxCfn7qQb/EzAa5VRhGydcT5ciJiY2v36W0qMj+VDryVpEAWh
	 fwmm1eB+z8VbbTSFsurv48kiDt/KHvb5Cx4Bp+FhqUQeIOZbEZAjdtgvlG3VAsf1sz3uJ
	 HyhwOQS9w7NdRam5G3O2Gbv4C6rYJPeWs3oAW72aqnsIe2MXWoMBNhsM6miSPbVbDcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udru9ntp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07D7606A331;
	Wed, 18 Nov 2026 16:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udru9ntp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C11F000C5;
	Wed, 18 Nov 2026 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018680;
	bh=HlNEiNTAdT39GVLGoD37c6srH5ys0v+OAzrRq6XMSoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Udru9ntpG0OcK9l0VcPoDZtsDupG8h41AZDUslq2Vr705yPkWSjy/VnsG0rUKx93w
	 0vQtAg8ZbBTrjrSyXkI6DEVFQBrzpq0los1jc5KFXdXLRiKCKTw+JnNJ5uo6QMovHe
	 68/jYr4HI5F5m1RDKjo7dirca+D076ALIobEPO7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+619e27617b2abe6b9b72@syzkaller.appspotmail.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1326/2651] floppy: avoid NULL deref in reset_interrupt when cont is cleared
Date: Wed, 18 Nov 2026 15:42:46 +0100
Message-ID: <20261118150335.739792812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 53b05cab9b753..d245f6120098b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1784,6 +1784,9 @@ static void reset_interrupt(void)
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



