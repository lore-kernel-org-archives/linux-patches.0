Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065306;
	b=gQB98dr+TRu4dSfnjYkxq5Bo3JvPaVypuCw9LpM2i0GQDUqsx6T1aVwEOSK7C8xjPCo7
	 q/jmm60yHNYxKCvW7FDWFHzeoHj3iStFZ5SqmstmDeeyJvnQN6KLOfWlwCiEvKyzWDkHK
	 JSUqVhoQRw+ESMlTvG8dN3QpbF59BKCD9VU5t9LPApmdwRgEM11HGwahJrlr95H1pLEMZ
	 k8yUQzYYsz3H8AdvNMEpjM5cOGlMmnk/839IrQqSnDplXzkoTpPQjDrXpTGu0n6rr/EPa
	 36CXzMCz+KlGCz8vg1QUjABdcyKqKX/lUqlX7wAXUIAf3P4Eo8mvyK5U8bczT/YRicg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nEvzJ5omP51SX7WhBajFbW7rP1YFlxHeXCI1naWVqRk=;
	b=m5/UrFQHVUMi8vmhwJ/UEEUtub1Os+f8z95+PGjwmECiqoUcs4pfC86gAEJlQ/6sLA/O
	 XgI8imraghGgWJebW9KK+DTgHOYmd1d6BP+XJ/q1cexZqZoycklgnGanozGvcsNNNF+0O
	 nQTF0OSYA6mnR0xCBo/zkaHZ5ZDji/5t0tphsq8DPH9eVzBO6k5k0FYak7BrZyuHlQwf0
	 lDF6zNisiiqFgp5vB7tHVZ6G+C9ls03/BLzbIIGDw3mnjKZjvuCHgMf663uFSt1u7Ki4S
	 h4uK4KCrMD5byNqMgNDeFjalU/41UvjgEFic+BqYs8YEk2d57NFK6L1NY6twjaYZ9uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdikMP7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9D606A32C;
	Sat,  7 Nov 2026 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdikMP7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2A21F0089F;
	Sat,  7 Nov 2026 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065306;
	bh=nEvzJ5omP51SX7WhBajFbW7rP1YFlxHeXCI1naWVqRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdikMP7xS1IPXvegZbP3UBlcDm5lfMFitEjI4NcpGZyWRrF3TbLw/Yqn5cs+ZMmts
	 CYKzLwKzoisbNTdMLLckRxYg8sc19l+LdtisbeyGiaXgsbVbHisfOeVzz5ODSya4Od
	 IG4IRH++GLRDBL5PdyvBDM0Vh8d2ZIOskoO95aWI=
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
Subject: [PATCH 7.3 1057/1257] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Sat,  7 Nov 2026 08:55:53 -0500
Message-ID: <20261107135008.481455066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 025a16c50ffe6..2c4fffd4b824f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6022,9 +6022,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
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



