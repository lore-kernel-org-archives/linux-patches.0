Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617701;
	b=jvHeIZKGWF+QM+LRATbiKdKXLDhkH6MjT06uvZwm/2oGdV4fRNdJiYEWFb8/M3biaGH1
	 RD/LojvtJbYMZuEmi3zIJsjvOIuCAJYbG9gTULzOVQhN+VFDgbdr2MIgtW4S+2jKlReq9
	 aEAi+NRnPEPBb1/8/hG6NdWJt6+FjVy/2rciO9qmUw6wxUOr6ZQ5uLPjuRJzaGrallyTr
	 nPF0xHWd6t20DmOVV8qh8dil+DqdIoPYu3ItiU7t5o/NvghkHQGbEmvF6VgBF7uVAx8uP
	 X8yxmo6P4WB2CRxcc8ZpTrUE2ul/CgbiQNcpdBD683h9PHcesKbC1grDf1n++VBUQtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FllgKXdFNWgBCs7xbqsbzkWMU+BvILKiaE41OKHFwDQ=;
	b=La6yDSqdjryiwKT8q/0MTbAw+keA/Yer7WqnW6wKbXIlO0FFTQ8r2n+BFla8srv0D104
	 mnEtbYT8M+vsy3UmxrRDjaLV4cyYUmDBoopkTgyYYEw9vqgBXA4F0WM4y9u1Fjv07gXh7
	 p3qzHdszTrhyiLSYx9nXS8iazwWOpcA7206nsj7+syMAKLMEbLMdtYkqkxd3oPv5vH+Dx
	 Tq1oPBu/wfZ+Hpb41Zk8BTn/qIMzFa33SHy4RTyxv1Ko0JfudAOnJG1EQsncS06UUb4Wu
	 jiBFowyfS7gZ+LmX673iJ3Bnl6hICIkEXTb7YqMuUWtKYm8YTvwVD/6mCUxgGWRlu0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgpWuTWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DDE606A321;
	Wed, 25 Nov 2026 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgpWuTWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72611F0093C;
	Wed, 25 Nov 2026 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617700;
	bh=FllgKXdFNWgBCs7xbqsbzkWMU+BvILKiaE41OKHFwDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgpWuTWubDyJStmfkv+DjVKrNpjop0bMmS7F71Rh5m+zJIC8NjUFDvYlxAPad1XJ+
	 jQFk5d1iSMB9xeuqxM5TE1DpKwaB/R9i4hSYWoAHAljFfPt9eNcfCVkC/7gnxZqarJ
	 PV7Dx7M6QoAS9c2L+K5KVnn6SUbyjTNhWSaEyhI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0047/1005] printk_ringbuffer: Fix space_used() when blk_lpos->next overflows
Date: Wed, 25 Nov 2026 15:23:05 +0100
Message-ID: <20261125143822.843290535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Wang Wensheng <wsw9603@163.com>

[ Upstream commit 2b2dc9dd356aed030e7ac11469d12f736793bc89 ]

Since commit 67e1b0052f6b ("printk_ringbuffer: don't needlessly wrap data
blocks around") blk_lpos is treated as not wrapped when blk_lpos->next
overflows to the start of data_ring. We use the indices of blk_lpos->next
and blk_lpos->start to calculate the size of the data_block. This computes
zero minus a small positive value, resulting in underflow and an
unexpectedly large value. Simply using the original lpos with wrap-counts
solves the problem.

Fixes: 67e1b0052f6b ("printk_ringbuffer: don't needlessly wrap data blocks around")
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/20261004075755.363989-1-wsw9603@163.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk_ringbuffer.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index 85c0c854b3ce2..1b0198317a2fc 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -1238,11 +1238,9 @@ static unsigned int space_used(struct prb_data_ring *data_ring,
 	if (BLK_DATALESS(blk_lpos))
 		return 0;
 
-	if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next)) {
-		/* Data block does not wrap. */
-		return (DATA_INDEX(data_ring, blk_lpos->next) -
-			DATA_INDEX(data_ring, blk_lpos->begin));
-	}
+	/* Data block does not wrap. */
+	if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next))
+		return blk_lpos->next - blk_lpos->begin;
 
 	/*
 	 * For wrapping data blocks, the trailing (wasted) space is
-- 
2.53.0



