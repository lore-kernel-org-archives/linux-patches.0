Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029311;
	b=uCCnxL68r77LiTHIauuUpJjO4gWU3VFLFCqfbmEawrQqP/AF0j9gz/UOgEfHugg8F2M8
	 hrJEe+T0njkF2lSLrpFLJxfTWW5lWylL5+lufujHOAgYV2LsH/MCmXWK5C80bN3NMfb/U
	 GPTcbaUXEX25qGJJBj13lhnnsr3LYcZWc1oTJYC4jL1urldAwlZtGARYwE9H5S4iau1S7
	 DKouHyBpXxBH1JvmpEaq/y8inOcXD/rLlTDcqCSnpXdzaFd7/hxK2ggvA7xeifqgv9S0x
	 hiZt5bSot1XrWHOV+1KK0RjcaoBPsMtbQeiV0BlWvTnGZGDGEvCxEbIrAhnQHFiFV6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7oKvGuVyEPLNCeWNZzda8M4JzZv42tCun0+PwyzNKi0=;
	b=twoCeaSboOucjF9fYJfJMs05lvyjId5SiY+te6WqcBad6xpVhzlnMtSLxYoI719KdPY5
	 NBvfAWVHunmwZgH9OI1Z+IjqbeoNvWTk6fj05z78l5evrXQEYmwo8CVf5Cmoi7kuhjg/e
	 WZHuBoyJBp8kaYXxhG+FA9OKdSLCjh8V7Vn3+UuAqxxlWDOAR3A4XCfTgH+p0pNKLOCrG
	 oSRmHBrKY7IXDZp08/NCF9e6GCptY9cHKO+9EXgcX2ZNeAfuV/O2ZJrnfSkn4iAwXre9+
	 QI1E0/2Sq3uyB2wl53+61njsKqh7D5Ev+KYChYNpaKbh0MP8huZDR993bhvGnbfbiMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EI3xFjf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2FE606A325;
	Wed, 18 Nov 2026 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EI3xFjf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B7C1F000C4;
	Wed, 18 Nov 2026 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029311;
	bh=7oKvGuVyEPLNCeWNZzda8M4JzZv42tCun0+PwyzNKi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EI3xFjf2AcOpUbjKWvcsvADSQq0gScfzlNp8JsvuJuSzI49a8LzDhy4Imh0Krt87M
	 P1QUq7bIxu1uSCYEVz6+iSAKc5UOUB6q8y2IVC6WzcSNfPlwMLI2iKJvf9HWl2k5DB
	 TCXSh0qzVozvw+PU/fFEkwaux8YqbgE0ASuvV574=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0304/1756] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118150020.448729630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 7fea128f6b829ad834f21834d2605d28a45b903d ]

The sense buffer address reported on completion is turned into a virtual
address with no range check, so an address outside the pool resolves to
memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-8-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index e651f2450e2fc..39c173586774d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -137,9 +137,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->sense_buf_dma;
+
+	if (phys_addr < mrioc->sense_buf_dma ||
+	    (phys_addr > mrioc->sense_buf_dma +
+	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_SZ) ||
+	    do_div(offset, MPI3MR_SENSE_BUF_SZ))
+		return NULL;
+
 	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
 }
 
-- 
2.53.0



