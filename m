Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062548;
	b=mtyjc8OWKULdsr6mwqDTrze/o0Q2wuPQ2z4P82O8Mrrqpvusozp2CP7zHyr0ZkMYS4hD
	 DIJwNpIdKwDccEqXxIsPJZt5v4LcjMkW6v5HG+HRFWwp5hRGkafB+cQpyx1ThhIT0gK6F
	 M/yYHsEYX0DWaFjBuRtnpeBOaK55ig/E8l/trserKGi/PRdv9p6T5e/0G67h8/fj1IVRa
	 6xDCsbebwEQrvFn8TM1Sr6wy2SGgL5E9VuTksCVDQ4NgXHBHh5gNuj2oplqrujpa8vtjr
	 EWccFk/2zMeuOQT3XNWYi5tlb/AUTlI2XCXnZwGFTZ2Edm5Twvr7jsYoY3ezbEj3W2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtYxa/i6h+/M9duBVebWNkL4iKTzOJGe/KqY5nxWQoc=;
	b=HRJCB0LaIAHkVB++SFHS71DSA6oAgEpYsj7cqfFAF12zfO88NUG+AZRz62kqzVoLhTf/
	 Yv6g0lxHZ3lRCD2zwZoX3eKxVBpR1KArSQxr87f9ZH/96h6V3NwQ8zJxbbZ7lvCSwfH84
	 7nBXzL2k+kvfQlSKoF2BSnW1nFwNgmKV9DMFOTpZ9Eem/huWUWzt4khQ0aoo1XlimWesZ
	 A/yaia0gtjg/UOec9wSNr20IAhTTGfA+b71e5qtTD0pKaLf5vPIro8iv5sM7Zhtxv5NWW
	 Dsx7bnGzJ8DnmSZieOv939xaIk2d9Lv5M89dOSkrp00HS7gN+ihnmEE2AeXruP5sdwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaA2Po8a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F5606EE95;
	Sat,  7 Nov 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaA2Po8a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD111F008A3;
	Sat,  7 Nov 2026 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062547;
	bh=NtYxa/i6h+/M9duBVebWNkL4iKTzOJGe/KqY5nxWQoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaA2Po8adcsQQhbiTezCpfAKei7BppUVuNUdlgPnG+GEhTG6GhncQkYMVC7ENzJUJ
	 vk1bQv2hRlSWRVnYa8qYG8wg0uBXvHVET9HHg4Mzkhltg/XfkLlydJ6O3DMsTQ4x6A
	 7INiW1O2A4P3DNfsIR8zvgJVECSmsfLkHzDrnlIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1435/1536] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Sat,  7 Nov 2026 08:57:31 -0500
Message-ID: <20261107135038.139869142@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit cd37a69c367b6a5f685db0ac7d01f08545081a30 ]

The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set to
~tr_doorbell & hba->outstanding_reqs on the line above, and
hba->outstanding_reqs cannot change in between because ufshcd_poll() holds
hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs is always
zero. Remove it. No functional change.

Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20261022034443.3034432-2-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 69d043053340b..cc730a2463df2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5673,9 +5673,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.53.0



