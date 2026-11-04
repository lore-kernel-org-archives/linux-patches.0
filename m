Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829537;
	b=n52L7rEMFakvg/J6LQRy/dG9g4nWLpSM0qfF+pH9fYcV/QP6Uc2OG9OJ+L321ULCOdXC
	 lsTEBieSnokDiOBB74NqBx4u0DZ/SAfH9PnJ6KpncLxuejk4dwzhmRnq2aGQQMKS64/Wk
	 FzTUYnGUjAuEhgN8YtKc7mJbXi8KEXga6T8LPOfDSlKFdUf5ISABv+1+tWj5SkIsSKOLn
	 bvPPaYFIlTU/gnzqv541kO+Kb/t7AqyGrsLuE5FaBHfhIF8Vgew7zwmV35fVFbeUgizIp
	 1PU3zOcgepXrffRBlhyvqyDyhNMmTprvJO10vCfqB4eG1iLLvaWAnnvyOpnOBKjVHZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PnoGYLSFgFTIt1OCbRJ24E/JyM+aqYuqFjoXhHsCvU=;
	b=obuv7BM9ydX1Ia3+9C5qysxvNTUywfVn6JncTqtu28HRBVLxmYhtuwznNJseP6Sh5w8e
	 NyU0prtJwQ5YcSOF8/Cp8IyyhZk4KH8bU9zEexbiTCt7Blt82QSHLYA56EahZG3syZ3xO
	 PrFiALA3dTZuwx9FA6s/f5hvbdwdb1v85yCdZyYnfv7hN135uLzRh32vwrvItyBOq+FQf
	 jS3hp/wSVAQVURheHUO38JSIscnyVhqgkADcFlpHBCnNk+Uox/yxbrBdnXLX2AhaM1NUR
	 saqNkCUCIJ7wfduo6plBNjko6mC6bxFSuW1OdV+hWxkViH/ZVX0mdKf4e96eQCggakA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3ju81zJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B406074FB8;
	Wed,  4 Nov 2026 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3ju81zJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766461F000C1;
	Wed,  4 Nov 2026 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829536;
	bh=/PnoGYLSFgFTIt1OCbRJ24E/JyM+aqYuqFjoXhHsCvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3ju81zJky5CKPpy80Q6WdhT+VFZaDnsw5Sd85CndU3tqJHp3QXiFG2y76geEAR8Y
	 m/6FiIBFalfM6O6ZIwuN+tvCIoGV4V+c8YCdXvPJoncYmbJHDNkqRz4QR42tPwARcg
	 82SSevFiFxlOrwZGMHV5Sv0yDYTA8jJG6qlYx2kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0189/1005] misc: hpilo: validate device queue entries before use
Date: Wed,  4 Nov 2026 15:58:42 -0500
Message-ID: <20261104211049.084384433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 04bd34c8c5069..9368edf8c4a32 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -160,11 +160,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0



