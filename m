Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015899;
	b=MtBtYyr0H1bquIQTtHmYQ7jj87sCyMHu77L/974t0lNWhihxs+KmoTRftv6A6ASWiyxa
	 1lCyPv7erH+hlpS6bNnlC2vWJ9keag3OpKjc5fT4NH8d77j2lktApxVrcYT69hh1Wb8Da
	 dN5N98Iy9j1Gr28NbGrCVxYFjZZyaYEOhX2TOlxXoFdJUowLTwIXVO4xrQIO98npaibxN
	 p3/yQ2pEtMqnpF5zHJW7RGtIB6GDvDvdCnIs8Sxyhl6T9qGwobPgvsfILlIOEb8ZMg5Ra
	 Z4g4e28kBYwiF7q/nFGnDRnUQLA5I4rHP4uA40tnOlHylIEhAI32cn4cTBTFXStel1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QKZpvlXgEZONoFaUAZl6aSuxF9mUeH+5eBNUkmEQGNg=;
	b=1/c1f558rSzqQWx2yXHO1cjiOwEeQ+mNLmeA+kbNTEJOeEAWZkU5U6o6PqHjQjHGS4Ff
	 5E2UxHDihcN7E5BYnf2xomTeldwnRhxcmlMZww/UNXOUmBuGhTmC9YlbGT+EYjlKNReJ9
	 rk8fep8fsZ5fedzRBo1TO0hvB8SfnBH0merVcHIy08a5yq//BgffT9HXIR0U4TpNK4CBd
	 FIieexXweU1YyMw4N8xcmKOlOBrSBeWkkesEr4M1C4Ph7d59Ml3sE7ERnEhPfnR0EF2qK
	 ZCdEAmJ83HlDTEpxTfrxCAGivla3Y1f64sWr2uHyQ9uNLrgCFjGtxky4+ZYaeWtPX/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/PQxW20";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B0A606A336;
	Wed, 18 Nov 2026 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/PQxW20
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264901F000C5;
	Wed, 18 Nov 2026 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015899;
	bh=QKZpvlXgEZONoFaUAZl6aSuxF9mUeH+5eBNUkmEQGNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/PQxW20bq30aVng1gpMgm9iLmKu+wfYKO8OkLeGTBSvjBQmJbmxbW+Hkn1tygBQN
	 wKOhimKpM1PzcvNsCmOntqwi/i1xciHGDdAWYo4w+ccYgNHQvl+7HreXn7hSr9LqnG
	 XzRZH2unPAfaaE6aPYAJI+dTan9xkD6IEXwictNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0335/2651] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:26:15 +0100
Message-ID: <20261118150259.919213244@linuxfoundation.org>
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
index 681868716ebdb..82fadb4d2b21f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -124,11 +124,16 @@ void mpi3mr_build_zero_len_sge(void *paddr)
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



