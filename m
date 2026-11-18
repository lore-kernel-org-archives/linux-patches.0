Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037056;
	b=1ocde+IRDABx9AVP7y489WOuknfMN2AkbYOjTeQ5xlJxl3zZAZOzlMqegZDnx/H8SlqT
	 wwqxT0prD1+0IouJokeotSNe/JDuX7f4UPSTwWB9Pbx6tBL+/wEMi/byHkuCByATtQKZg
	 Vf4dk0nr2VoU8x3PBjHXzfUaaqVE/LiRV/eg2u8en0RaC8YAkrwscQBkP0pbEm/s8GsvF
	 5lgm2VYCxtJ3/lv7gB92LUYE+KiJE4C8bUkUZeoV5YBgmiub9daFRKHZUf6LKpcTJC3p5
	 OnX7dXv5WVBYtQ0NBZ/XxkBjhEpXxBgDEpzh1QSVjueJPoxwMu1eSqDG5XHtluiB0aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MdAyH06sTXrAOYHcYRCMBQLV9/Hicq13NbwtF4y1QS0=;
	b=0Pnq6uFZFVhA4YI9IP7UqmoZytuH1heta5JJPu8BuV0az6k8GIyElVWJdQJ7+ltj3yLg
	 zjmvQFtyPj1RLKe4AEf9B4SszM56DbblJVCCrbcLNbtFl7mLmNxR/VlC4RWUJAlwjJeCx
	 8fXphFf/1c2fXyR/QdPsIdH9w1d0rtOatCOHUR7LUrmfmqrN29gbNlmEk1kwXYvb9Rm4D
	 ZDYuhfNQGx2d9Fsc9zfMeBJzTxTxboyl8vn4bOcPTC19jghNRqWGFM2NxktjQF2FOUjir
	 sZZzoSM3Jz9QwmICjg+AJDo4+hrKWShz7WYrP1FoOfIT9ABknq0h06VFYGRfpup6YMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGxy5S55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C76606A32F;
	Wed, 18 Nov 2026 21:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGxy5S55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C59C1F000C5;
	Wed, 18 Nov 2026 21:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037056;
	bh=MdAyH06sTXrAOYHcYRCMBQLV9/Hicq13NbwtF4y1QS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGxy5S55rsGeWUXADBaG+fh4LVTNGITgOHy4dvd8f3GcdFA6TxbHMKxM/HDaNHnOM
	 ptEmSqAewW5WteADo8DdaExdpcFW9bBd6HuO9NP/Etpc2M1k5uStsb5HJuUHwAPZvm
	 QNLBCD5zUS2xsr8uncFJPeABZy9rymokGkKUMyq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1277/3318] nvmet: Finish the blk plug when integrity allocation fails
Date: Wed, 18 Nov 2026 15:31:39 +0100
Message-ID: <20261118150358.546740723@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 18fc5f6f1ca945630dae5404265de55d65194e22 ]

nvmet_bdev_execute_rw() starts a plug before building the bios, but
the two error exits taken when nvmet_bdev_alloc_bip() fails return
without calling blk_finish_plug().  current->plug is left pointing
at the stack frame of the returned function, so the next
blk_flush_plug() walks a stale list.

Route both failures through a common exit that finishes the plug.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index e8e9e9a444bea..c7fa910128b42 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -300,7 +300,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -320,11 +320,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		rc = nvmet_bdev_alloc_bip(req, bio, &prot_miter);
 		if (unlikely(rc)) {
 			bio_io_error(bio);
-			return;
+			goto out_plug;
 		}
 	}
 
 	submit_bio(bio);
+out_plug:
 	blk_finish_plug(&plug);
 }
 
-- 
2.53.0



