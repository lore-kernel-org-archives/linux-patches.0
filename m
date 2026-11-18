Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033704;
	b=Bp21wIy3EqL94Y3vot+jUHuFnLmMSJrd7QqanTN/05xiRtzqyNLfqJK7jkiM7I2nif8o
	 IoyFJGGe7TxSj37efa0G3OIakQcmqSLjE2fLKcn/ghkHJ/DNuo/Q15fGFbIKQdB8+BfN5
	 CtPcWQj6iYbJKhas2lvzp6Lvg1fxMU6CwyxDQbJR8kN/BMeScftUr+f0q3U/8c6JvJmCb
	 mDtid/HJC21VuE85kSXoWeR35cfMdzmm84gqgx7KxuTi7xDiOTyNlAp2eLSYuARaQMuXz
	 H7J1jN2C9wNuMQVUuR8BsWHs+MQeBZAjaXPYVbJglzCvXAMLfTbHHdO4TzKB7xa6ovw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N17kXFYycTS0o4HU45v6dTTlD/2kd8S68u2Cc+XWawk=;
	b=eyxDfIF49/hXCyCFkY6ark8SkO0HXtbpHgkFPbyaStYX2hM8ddMr9boZgrxuP+DtlQXa
	 rkttp+lbzVo8HHKVn4vAPBFtaU+hi+UUtDiDPM1MrcwZU2k/lMPd/tP1GQC1uJY8p3PDi
	 70AQDgqoZwYW34HoA34JEWbGOZxtxd3tTi1vt/RaQU0Nwh6V54XWc3kqIjuu+01Rn651u
	 z8O3E2+jGX942bawNHpXdmXu223cUv8JlEmwdG/y1qb0PLYjkyq7eRM3Q2Z39Rc3IIVJz
	 Ybo7lHBwdoELl6y7Daep2KbLMl48zS/V0CmAp2kR+sUzGBeQRjbabLFxeajDYWmET/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vi456Jes;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58F9606A320;
	Wed, 18 Nov 2026 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vi456Jes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D641F000C6;
	Wed, 18 Nov 2026 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033704;
	bh=N17kXFYycTS0o4HU45v6dTTlD/2kd8S68u2Cc+XWawk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi456JesS6ltYmPtvtfsmAZ6nbVaVeXdpm4/sOunPGY/Dck/gCxD9HHPL6nhWkLGF
	 nLU4V06tpwSCSpMC00kSQq5T0q9whbGARYmxghS4NNr8kTN/oIcZx88zedSHV4DshH
	 YnOiTqzbLX2TA6fzgSDZLeEU0ninArhgZNKK0E2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0108/3318] media: cx18: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:12:10 +0100
Message-ID: <20261118150317.504730869@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bf533acaaa7dee21d49bcaabf8e813ea36bddcd8 ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx18/cx18-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index c7cce38dd7547..38b2cfd2372c0 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -135,7 +135,7 @@ static u32 compress_sliced_buf(struct cx18 *cx, u8 *buf, u32 size,
 				    : VBI_HBLANK_SAMPLES_50HZ;
 
 	/* find the first valid line */
-	for (i = hdr_size, buf += hdr_size; i < size; i++, buf++) {
+	for (i = hdr_size, buf += hdr_size; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] &&
 		    (buf[3] == sliced_vbi_eav_rp[0] ||
 		     buf[3] == sliced_vbi_eav_rp[1]))
-- 
2.53.0



