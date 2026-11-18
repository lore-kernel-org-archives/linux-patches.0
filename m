Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036878;
	b=gPOThQJiq6OKaC21uIx1ay3MvfBOKhYShxFppqKraaOv6H15iaJvIgJgMc7q+rpmj97C
	 asgCxH/N3tGJH67MT7FSeYBO8J4uUiF5faucDb8/G6gm7X/e55M7ao8I6v0Af/D71Njhj
	 Gn7p1dGcFpUFO4e6zrypfPFkHxkZxsEFITrmlBJJjhhqHG8zTF9Gcc/T63qXQ447Aiq5+
	 m6lz8KtB66fmbPU4NCQrgmKu6uKpHgyq18VJawIoIhv6k07yt3GkgKyYBOlAvGKxVAgHa
	 h91cvStgOecTy/GBAtF/PoafAwv19+e93ZheFpzNtnpnE7N1FNUzdw5nZri82+YLAgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mY+K9hz5vYF0hnO4tWVtJPk5tTqszh3FsgclWD09/pQ=;
	b=4UGYMb/r/eNDC28FSTbeoxiU7bKVPlSBCjUIwA+NWhPYg7nzcAWngt5q5yEsA8/GVNCq
	 f6ix+AuhjewD9MCZvH/m11uTFAydw3OunoyPGQYBAoXd7nel/6DPH+iprN3oWSFl8KFb6
	 Mgu0fXreeiFWkJbK+E8L/EfGVnZ8h9ymXseC2G/1F6MdWhyCiNmYeRGZlC5LWaf5cFg59
	 1PujmrOi90/v5zhKqQDvmDOHebcUfxmDwYtfU/6El5YG4J6B7025e6BNqGbW51wGYPF58
	 AqNp7V3fBjWMa2SiiallMHyC2k7IRjiRBZBZTBuCXFz96vI7k4pl8eCy04nvhCZhk4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwoFPzCU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD8E606A33E;
	Wed, 18 Nov 2026 21:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwoFPzCU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940901F000C8;
	Wed, 18 Nov 2026 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036878;
	bh=mY+K9hz5vYF0hnO4tWVtJPk5tTqszh3FsgclWD09/pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwoFPzCU5BKQ1e2MHrhzugHF7TQ933+g0bqwAY4lfJieVP0noVqArvdXOr8T7NKFY
	 gXSs45wsHaKtiouV2ZLFGIbGp3JIV2eQHYlJkS/h3Up2wbtxaqfK4AKXxockAB4oRS
	 y3mdZ4dm8bLRvxVBt4YekSleWeZQsRn06NdbqLrY=
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
Subject: [PATCH 6.6 1216/3318] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Wed, 18 Nov 2026 15:30:38 +0100
Message-ID: <20261118150356.657188126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 24e010c7d12c3..3ffd18aa9675d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5621,9 +5621,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
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



