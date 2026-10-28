Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213115;
	b=sPDbohF6wtp0S9FUMC58TMuVDzVq55otULAEalvk2qSIgREr/FApSwIT/0PqI2QylLoO
	 L+t/Qins6W0hTEgaILVZdQiy37ktfxjhJHhWF++pnmsmabGDuKV9FImR6jKP4VjD9P9cu
	 VYhR41s4pTSwSWWOTufyJjkw1QlIcOfniGfWlW7iVS41WGyNl4jaLWEMuWLMShdTFpFz9
	 gMSp2Lqc7C0bE78ReaghCiz0K1LlO9/qlCpTLt1uFx+vY18vChUHVf4kJjMhHms0PVlK8
	 gKdyfsDa1/J3QWP0dBuGlM71U6fXDSVUDWG5DKh3rw6BEY5KFKAgRqUXCOvSBxsYz0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9oC5c6ZCeV9TZVzu3ESLydxwYQ3g1P/JAlLnXCZ2kk=;
	b=qowNqAkrTFn73Qz94SZqlQt2aK7v2DmYwi7/fPm9iF0rwTWMATqTXkaCU4oP90MC9RrL
	 455wvI2bpAJFJZ+UYot+ARJ2h9Jv9qUgeCIrePNxb+lXtVpJ7+Td7lqFuuxIwd3la5wZi
	 dB4hLSD4cKDXCbwlewTCw5ZrdILOkWJqe12UeIDogMy2HmtFtaREVMxuZR5dwpfdx6g+Q
	 QAyotrDtESXnZi8vX6aLG80EfH46PB4LxPIrt7iLR86mRcRP6Psbgffb1BpsJzvTzRMZM
	 GFDGxRuuP9+KSCQ9UW/CgVSKkfKMHQrNs55pkUmUpgTBCGb1rurBLOKroEwYECqP3kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRmUSTQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC04606A31E;
	Wed, 28 Oct 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRmUSTQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF59C1F01825;
	Wed, 28 Oct 2026 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213115;
	bh=i9oC5c6ZCeV9TZVzu3ESLydxwYQ3g1P/JAlLnXCZ2kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRmUSTQmTncNWgX7Xm+B4IUeTld4posV7pJuJE2/6NlfZfchrPNniLssrBOUctZu9
	 XxsqfFTIlDWK2ABKV5m5RpLjs9nUGQe/hNpBc97mSvcpaXbJ2ItbEFTr+pF7Jkcn8p
	 FCmVy1nVm2gwNNkL4JwWhDyx/KYRk2STFBrtMkGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0348/1887] iio: trigger: cancel reenable_work before freeing trigger
Date: Wed, 28 Oct 2026 17:40:44 +0100
Message-ID: <20261028170507.149172881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2a57b9246cecd5dd797a42eb310d6c8816f26d9e upstream.

iio_trigger_notify_done_atomic() defers ->reenable() into
trig->reenable_work on the system workqueue, and the worker dereferences
the owning trigger through container_of().  Nothing cancels this work
before iio_trig_release() frees the trigger, so a worker armed by the
last in-flight IRQ can outlive the free and touch freed memory.

Cancel it at the top of iio_trig_release(), which every free path
reaches through the device core's final put_device().

Found by an in-house static analysis tool.

Fixes: 9020ef659885 ("iio: trigger: Fix a scheduling whilst atomic issue seen on tsc2046")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -506,6 +506,8 @@ static void iio_trig_release(struct devi
 	struct iio_trigger *trig = to_iio_trigger(device);
 	int i;
 
+	cancel_work_sync(&trig->reenable_work);
+
 	if (trig->subirq_base) {
 		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
 			irq_modify_status(trig->subirq_base + i,


