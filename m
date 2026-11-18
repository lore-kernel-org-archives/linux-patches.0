Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029345;
	b=lCdH/cdppMg9eZ0fWwusUJmgbnEnk7bgwUvXdwDsEQ32sZ+OLBK9HivELlzMJfgc2o17
	 rnG6TACL1PZ0T4vbBfldCMHcpnBjqrxRG3LhjKVlezBfHX44IMEh3c3AVgdMLOvmu2Z1R
	 l75gG3LSsWYPdjVdq/34gw/Trnq2xzdmH1/pnrYNZ2VtyC+eV7+qGAkBFmhQCJb3TlOFv
	 dfb0rfRm72VPOL9gXg+vKQgaYnDA7fYybVT7DdMOGouJNVawOYpsYFPQ6yd334sJ4bqO6
	 s8fozK12bwXHP+LUdFAQ8wZgVkXRf3It12S3SBMKSCmKgYbYJVSVXLgEealB1fXUYkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8md8+cs+kHE5VJxFNHGZoW3IOUFtLrytId63oVqg2/Q=;
	b=fH5+SIPCgqnAIHm1R4oKz4DjT9uLhMph/O4HBvPA4eHKLvZuMGczFbr84ldJx1M5xCAo
	 BtlmavCsRDZO9HDm/ZeCSUJ8u5U44huEJHKVu9ugrs/E7TqPVVdEbrfjLyW7ZC1kgVEIj
	 z1Vfy6YFdKC8DbIIqYtMsCuCtX3DEDztTkGp/bFfoGVRkq3zRiLo1RGEiWGR89mifYgVL
	 XfT7+GM11gqfNxZsvFzyeakFQwORjBLaf5CY2HfyVTHC9cEYHiUzMNcMW1BGesYXU7dfa
	 jueZPJeUQJ0f0LNUsgw1Iq6mt0JpujWIDzG/JRQqs6LnYAHMaNElbk+E81KvV6kqMPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRqaPQhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE17606A338;
	Wed, 18 Nov 2026 19:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRqaPQhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0621F000C5;
	Wed, 18 Nov 2026 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029344;
	bh=8md8+cs+kHE5VJxFNHGZoW3IOUFtLrytId63oVqg2/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRqaPQhj+2iyoE20fu6902I781ObiInCYO6B8Wo+LRNQOeL+E10R7MZ1iU+G24pPT
	 iInmWchhxJcZHhr8I20qYTqZjEMZ2cMNYtQKgZiNF+0/W1wLl77PBHqDLwdVlwwOSo
	 MazjCNPMby2C6dDqEvLgVq5BnU7qDs207w9WyJhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0315/1756] scsi: mpi3mr: zero out diagnostic buffer status memory
Date: Wed, 18 Nov 2026 15:40:42 +0100
Message-ID: <20261118150020.854994108@linuxfoundation.org>
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

[ Upstream commit 052aea807cfbcefaf5b6ed8202f65da1fc65f4a0 ]

Memory allocated for the BSG diagnostic buffer status is not zeroed before
it is copied back to user space. Several fields in this structure are
reserved and never written by the driver. Use kzalloc() instead of
kmalloc() to zero out the allocated memory.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-16-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a0c181049cf04..e75badb31aa04 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1160,7 +1160,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
 
 	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
 		    sizeof(*hbd_status_entry)));
-	hbd_status = kmalloc(length, GFP_KERNEL);
+	hbd_status = kzalloc(length, GFP_KERNEL);
 	if (!hbd_status)
 		return -ENOMEM;
 	hbd_status_entry = &hbd_status->entry[0];
-- 
2.53.0



