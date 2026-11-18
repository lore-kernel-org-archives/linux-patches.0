Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045888;
	b=LixBpByK02dzGUdNTRo/Ra+BiDXH76pqSJPAsSbRZzSuvRlJ4ZGUBIdOfy+vV7hYXmlh
	 gMqVa+p/LbuqLaPS/JbOKHO20kjMwF2mrkkC2vkKGssWsXicIHBVmuFc1x5iH6nF4OwDc
	 WnsSx7qXgH9IJ7TWkvlvc87RwZdLnbu3u32AOk/LGTA3XwHvLXVX1gSBH0rG2lOWuWz3E
	 ELauLE8k4u6cHgOvXyjKb4KMLrarZ16dDWIG1vV4Pl5dO/KflM1KJj2oo17FuD6YdJeQO
	 ptBgFXL5sJv7VM7c/x5obZ+/cHz0N07VYsR3mfcaXZH1iLBPWmXR3kuGLr71fNYw7Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7lIDM9RbPQkQnVMyDmeL25GtYDi/tUDTjEm/TDFv8X0=;
	b=cQCvaV+X0zNOq6tujtEyjfjB3LWFEj1O8nN1ug/TR/IqS4tvW02HROJPFaNTxiMK+BAD
	 1VEHnBzAfgUEuBZKxi/Idz6UDgA9TT1shFLzDkBmibesCzKWS2wn3SbDhG7nXvBeu31jH
	 GbY2BRU6bPf8ksDXEq6im/urY3UNV87WSvbuAbna7kse8XGdZ8He60qiANUaTO5Jkj9e+
	 hBHqL5bXIdKjCIRIOz1VGg3LEpp4OYFhaEdA3xc9Lq7I2pPcKt39F8wYoQcc6QMs67dnk
	 YAHIKt9qrLZLOLaTZPRI6xChlz8f5pdicHvvn5oN5A4Cqg1ujHGCOFzBOktIoEfkRjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dumOgStZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1A3606A32F;
	Wed, 18 Nov 2026 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dumOgStZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128841F000C6;
	Wed, 18 Nov 2026 23:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045887;
	bh=7lIDM9RbPQkQnVMyDmeL25GtYDi/tUDTjEm/TDFv8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dumOgStZ29bOJcWZki/TlBfR+mZrIYgZKF4RA9F19RM32TRXO/M2ctLzKXagiOJ5g
	 O92A6kCaxazRHLS6T+7lr2bratYSRBYz+fR0MLsqjpsr8ZvdTtaav/ZCzupSNjmBbv
	 VoxJBfuJLwxPwlVxK6Q4WN1wZ6ErC1d4C3p/848s=
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
Subject: [PATCH 6.1 1085/2857] nvmet: Finish the blk plug when integrity allocation fails
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118150240.689525514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4a30f7d11cbce..bb71ae68562ab 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -301,7 +301,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 							  &prot_miter);
 				if (unlikely(rc)) {
 					bio_io_error(bio);
-					return;
+					goto out_plug;
 				}
 			}
 
@@ -321,11 +321,12 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
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



