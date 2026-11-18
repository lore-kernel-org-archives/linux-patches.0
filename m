Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054890;
	b=mtc7qmZQD1YX+BhKZjrQk4LTSoqZsrGtvNze9ih/nz6pzKB3GwO0i90cK/N060eHtn+S
	 dUK9baIwIWbfIQNulsr8LNJGGfzdQZYC2mwT0PzRGrs0v0d6ZvlPhEd6nzcrsQ59OLKny
	 94lxQptSEriJoq5IssOI7jFXB855GLAsRuys4LIjX9CIFtlwrldXH1LXj1et1am25sr2I
	 V5q7dSkktWqVutx+cEMyE2ihIxLdF8zfvRSrB+HsHjt9xPuG84PG28qSy9OXX/gAT7tnq
	 YVUv9ip+ZhQhazvWgwBzz/vnO0xpojJav8wJOK4css5Q3iEEKElic0sXugdSIO1doOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xaMrivZGT3rhvnMcvl1gfTZGdtQ5pU/kHjBfhkwEjVo=;
	b=sqj6E4tB/rmNVmHfGHuDvCp8PZLYbe7LlHH0npBqzx8onR2RFBeqU9eNQJn1RU5Vvz5X
	 NXHEuj3d4jUvPyJlM/baZKhxEkb4lJQc0vfBOHY+4cJPc0iYk/7b0+6PMU/c/uEHjAlhV
	 HKeigcfUqW8aJI0vH8KZ7OM1OyYooxODd3deE6CphQVAPfevorijAvCpJG2bueXoIX2gA
	 lemWNgfIoqK5rW8LwIYpFD8uHkCrUL2WmNcXwZfLWCVFmPEyReCP1Vl2DSTQ9lWW+o7tD
	 g35HDh5lEgOoa7Nrq4PvHrQgxgq9tAyWXLg8Cnbf0XFiMqq9Yx5TxcUZ1QMOlSDT+mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJz+Ruof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A3606A31C;
	Thu, 19 Nov 2026 02:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJz+Ruof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F7A1F000C4;
	Thu, 19 Nov 2026 02:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054890;
	bh=xaMrivZGT3rhvnMcvl1gfTZGdtQ5pU/kHjBfhkwEjVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJz+RuofgRZj4DcXCTIC0MkC6LiMG0bJQzfMZN0aSZXOd39e2KQktQC1BuTrASLs4
	 4UKkqDbrPu41uAKOYQlDsZB/AgxCa0IaL7upT4fdp273dPrxGmbGCdn2dlzurwG8q1
	 e9qYPocBXXXo8X/fW7Oe/eksBdqzAgn9hBfJ28gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1437/2214] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150108.647510895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit bcf0a5bed59acd5ae19d80e1f617c1a5b355af0b ]

The reply frame address reported on completion is only checked against the
start and the end of the pool. An address near the top can pass the check
while leaving less than a full frame, and an unaligned one resolves into
the middle of a frame instead of the start of one.

Require a whole frame to fit and the address to be frame aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-7-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f672207348385..06135b4d96559 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -113,11 +113,16 @@ void mpi3mr_build_zero_len_sge(void *paddr)
 void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->reply_buf_dma;
+
 	if ((phys_addr < mrioc->reply_buf_dma) ||
-	    (phys_addr > mrioc->reply_buf_dma_max_address))
+	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
+	    do_div(offset, mrioc->reply_sz))
 		return NULL;
 
 	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
-- 
2.53.0



