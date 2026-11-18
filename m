Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029339;
	b=oW370QB0evUCSFs6dVgdSxwilsslDew0pTQeY06fD9tKvGSa2y5Geu8WYjNmSmKZGiUU
	 oaIrDfFkzWuYtj3kSj6AYj3Iy+BJQW78DhzXMb5Cl795YOhrZY540an2djaEhl4vF/f65
	 lNcoyNR39FfKPTs8Ne/jM1VAIldDGkVSOtt2FV2SeEN37EfTBzC/qE6ltPQ+bjvsMyp8P
	 NuQKCsxjGUYqsuFQ9VwmmBEhpq5FpNPQEYmyDdyzLtdZt3W3zHY8RlRxGyLkTXjRG1hIz
	 0dmZPnSISFSsWT9/s+4V/69dmck2lhCN1BLT4/x5JWUrgjfEn7cQBVASYUiRT922yqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzzLfMCgSG4garmAXZPzfrwGQp7Tgb+7rfD9l5HbJZ0=;
	b=WC5OpoXsJVzhEYOCUpv35u2NJOY6nRlXH+AMEbX/+lfcV8FD+BqzLFMEvH78o0rY/nog
	 nWSI554Se7ny1CrOl7HV/vopskdEkPrHYJzNpUkDvKAg9gNoEJe7Q13FJiaHMFn27sNsk
	 PB7qMHfqxR/yAWbf12UZflEqOL9vhA/83tTgrRleggXhv+uoyiFRNX+8epxrLuvOpPjvf
	 BjGCG/Sm2q/B+Oc5WlA7NrBeH/FyXA9waePzBVgdPQaF50h6PMuu6lFToQnKEgltrejwh
	 HFhEhtbkEqn1/zWRFrvGsf2r9uOTXowh61DS3tYAcKz9/7MnxN5OTXAr8FzJ8T7d5Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4cVEkCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57583606A31C;
	Wed, 18 Nov 2026 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4cVEkCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DFF1F000C4;
	Wed, 18 Nov 2026 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029339;
	bh=BzzLfMCgSG4garmAXZPzfrwGQp7Tgb+7rfD9l5HbJZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4cVEkCgFPbH1QZj5Im7ziFRnOJFLVEaLfHo6/j62iEVw+qNBS+9QZ5gFzGSoXtyL
	 AG+OAGQ4GtTGrL1VnsbxhC6SF0Hh6Hl1mQLso+vs4xXf6ODeSFJOwkCpozl21Y78xZ
	 odjoSza8hNPIOGlqdf53V4cDs93yAB9n4DnqJV/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0313/1756] scsi: mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150020.786749513@linuxfoundation.org>
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

[ Upstream commit 203b3072e7aa10d98b3f2b766693ea925cfc571d ]

The size of the target device map buffer is held in a u16 while the number
of devices it is derived from is not bounded to fit. With enough devices
the size wraps, a short buffer is allocated, and the loop that fills it
writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-14-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 337b6ebda49c0..a0c181049cf04 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1382,7 +1382,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -1408,8 +1409,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
+	kern_entrylen = (uint32_t)num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + (size_t)kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
-- 
2.53.0



