Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018614;
	b=BHEOv1lNnB2Dit5smtq6szIQMRsKwMuIS3eDMJTBL7oRpvJG4pcpQOPYTBEDX+RNeHF2
	 FPkaQrivhZZYOOM6hTMZ1OaiU+pcZ6YAmzNVUoEV8X+OuT/9NnPkXGJ1xKjvJkA6WYYB1
	 Rm/goWJ8MM7ub1vD+5TnLiUCUeTVjMgXbkhB2idvj/amAKiRZhX+ydTP0yIDOGnsqOKdj
	 FZX7QmkUegcA4lpxETR93eJnhwnLLG8459su3DTz6oQIhmdbIo2Nq6Lvo8nJMv+EJ1YeA
	 Te/n2bHlwfgrQ6MEDY+2DpH+N5FSYapzHhL299guFQ8u/FMT06hZtwQUhgjWHTYKvug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tVUJ/jlVibh789HnAbwISwnuDz/HXfgUSqDpqB8H6J0=;
	b=CPMQtJFi/tE+0smR0HDepYM6uVIROSuHUh+ikA1t1EH0vi1BmprQ00mih5dldWOviE1a
	 z9CEin38bOufGghCYmqs8481tXhrRKESmIRvD/zch2ZP4lIoue3IbEkBAs607Y/QjgL+S
	 oHZe8gXFTt88AxWxJvoQrfqbezE8RkRM4s70AzNaIFsOqu1/ZPBMX6F4coFniQTv934bP
	 e3+9fMt9Q6E6KUOXaBI371fAM2pVFjnD+a61GhF2WBRNdzZ4bIk74UhQXC5TQqd8pwt+u
	 FF2yuHOC2qmYVEQMTHx0CU+6tzAtcgBXAyqV4EwQIIMhrqMGHwM9zNz+9//SkSstqKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlI7+qlQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB93606A31C;
	Wed, 18 Nov 2026 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlI7+qlQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9C21F000C5;
	Wed, 18 Nov 2026 16:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018614;
	bh=tVUJ/jlVibh789HnAbwISwnuDz/HXfgUSqDpqB8H6J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlI7+qlQUpXBbN9seaSVwKOoly3KYZei8dLvz+q38J7SMdsta45emyyyutUY9aXfY
	 sgpARG+y35MoyHQed350YJ254bdW8IbzxTojlJS1Y+Js2Q9ByZhBVeIZEI1Gp6lNPX
	 +m2TMCdyjpZkz3L5KUwNBR8KDPobl9NU+7u6OC6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1301/2651] firmware: qcom: tzmem: Use DO_ONCE_SLEEPABLE() in qcom_tzmem_enable()
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118150334.803232660@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 60d4a6edea9ec617725db6dd1e66d96a13bc8d0a ]

qcom_tzmem_enable() is called from qcom_scm_probe() in a sleepable process
context. The helper it wraps, qcom_tzmem_init(), calls
qcom_scm_shm_bridge_enable() -> qcom_scm_call(), which invokes
might_sleep() and later acquires the qcom_scm_lock mutex via
__scm_smc_do().

DO_ONCE() takes the once_lock spinlock with IRQs disabled, so invoking
qcom_tzmem_init() from inside DO_ONCE() runs a sleepable call chain in
atomic context. CONFIG_DEBUG_ATOMIC_SLEEP=y catches this on boot:

  BUG: sleeping function called from invalid context at drivers/firmware/qcom/qcom_scm.c:334
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 49, name: kworker/u16:2
  ...
   __might_resched+0x148/0x24c
   __might_sleep+0x48/0x7c
   qcom_scm_call+0x30/0xc0
   __qcom_scm_is_call_available+0x98/0x100
   qcom_scm_shm_bridge_enable+0x60/0xbc
   qcom_tzmem_enable+0xf8/0x118
   qcom_scm_probe+0x2d0/0x680

  [ BUG: Invalid wait context ]
  ...
  kworker/u16:2/49 is trying to lock:
  ffffa83e8a485e38 (qcom_scm_lock){....}-{4:4}, at: __scm_smc_do+0x70/0x488

Switch to DO_ONCE_SLEEPABLE(), which guards the one-shot init with a
mutex-style path (__do_once_sleepable_start/done) that is safe to hold
across sleeping callees. All callers of qcom_tzmem_enable() are in
process context (driver probe), so this is safe.

Fixes: 9941fe8a04f3 ("firmware: qcom: scm: Fix tzmem state on probe retry")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/lkml/5ea74dd3-7471-4c7c-9242-c2005312b1ab@samsung.com/
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921195636.1925869-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_tzmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_tzmem.c b/drivers/firmware/qcom/qcom_tzmem.c
index f926c1f648221..9fca7d3029433 100644
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -516,7 +516,7 @@ int qcom_tzmem_enable(struct device *dev)
 	static int result;
 
 	qcom_tzmem_dev = dev;
-	DO_ONCE(qcom_tzmem_do_init, &result);
+	DO_ONCE_SLEEPABLE(qcom_tzmem_do_init, &result);
 	return result;
 }
 EXPORT_SYMBOL_GPL(qcom_tzmem_enable);
-- 
2.53.0



