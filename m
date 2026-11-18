Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016028;
	b=tFd6KHXBwNJL+J8D4BuFuG2+Ytcusr4yY4zSH18vfVq5gf7YLXJD018n//bvwAoIacfv
	 Dia8iTwxsu4dd+ZlP/st4r3l6K8TVILvndFTtpZ9rU0nICN5D7ty2VtLy9LAOIx0Q8/iO
	 Itj2drnyvtDwMToLzZsYpR7BZcC/DTX4+BQQLl23MWadDR/EG+CfZlQMoV+ixhXmdUX40
	 4zvQvoHhSR0DqfCfkNW0klPezZe8VT2BBzcNu2I+IjcWoi5FGbAYEbqIK12Jrnn0NZdTU
	 9c9oz3W+Gnc4dBN5Au5iud4vDm5hWiLete09JhDDnD8i42RE1nlUdyRX9YudDVxe2bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQunaF7LOaFygdjerIqjPmEC7oY/4ZabNyfzivQCfew=;
	b=cH5HKBy8xbo+BDprVn9VvugWa1rG/01ZXYbj+BJDbvJkqWJLOEB2AiNUJV9QCX+o1OWM
	 IilQLlWcWuwfGZPv9FcW3Zn3IoooEsflWIQV3r6ElKybPIWFKVq6G81/g/PlDIRB14xgZ
	 fa7/sXZQFFfnaPWBRzAFNGH/zGZcVoOMQ5qZFglXh+oPefIzeFAIZPpF6yvmuLiy75cE8
	 kcj/l+77YoJf+6NLlnwQC2IjemcTSueAp95iO3WdHzDAIBa7gXPAfMSfKjD8kePtA1pbL
	 AxPNBwStgcrHlXvWVX+rYWVPyuodkaQPuCh/0pqn2/5LzbM5EeB9krBd2vQVj2pzpXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gleYWBSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACB606A32F;
	Wed, 18 Nov 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gleYWBSx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D87F1F000C4;
	Wed, 18 Nov 2026 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016027;
	bh=SQunaF7LOaFygdjerIqjPmEC7oY/4ZabNyfzivQCfew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gleYWBSxHHt76DJcjfR/dHhmsBlikrDFN9BiqiUKON2ZsMGQ7RkmW8i37QMPyiHZ0
	 gO4j4uqc1m7odjnvdY4mG+jWSsUQzQwxn+3BWOChFiMvXHDuoEJydMy3y3DmFlb/Q+
	 gm6YvLNEA7XnO4iZKAfgRNTVyhvdb3NV4a3cze8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0342/2651] scsi: mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 18 Nov 2026 15:26:22 +0100
Message-ID: <20261118150300.159066365@linuxfoundation.org>
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
index 4f99678858023..313688029620c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1466,7 +1466,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -1492,8 +1493,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
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



