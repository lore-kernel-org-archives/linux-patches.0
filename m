Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057267;
	b=FFRgF905GrF1nEdauGX59/V/8njU9AKIUa3bhM8WTjiY1MGU/W8DktJokzfpOUrLZjpk
	 vGhCKHsc4nm3i79hzILmiR8H078Azt7wt1vBXmt54XTVwRLhr/xSLs3+UMnhXcsma2TK+
	 p9fdcd1omYKNBPQA2p2zxAlMmQJZ1yCBBvyZMCAkklusM2/lTeKTvmn9IZMYYF01Wt/kx
	 ojtDL6odM2OYZ1Xk7V2qId2y00RVjZzrOnR13rNTqPSbewQXcpOV98siD6UsLZRWRWycP
	 HOo336qVD6oZ3Rpv7yEtz0TLuQybhmB7tZfvX58Uz9GSjAwsc2iuDmMyXgz0l76Uskg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6t0wN9QOxi5MjrkYtiMktVLtwJu6V8z/1LK8LUe3OQ=;
	b=uGcwqavCA41bWFej/CEqA1BWBNf2Ybg9Fcg+AbFG8nLUoR16tsTn8gKFWsfkzmJJQfsw
	 gssuk3Owj45Py+bPk/K+uxmicpM7/idHuJuRUl93HkEHcJdl15isRaCsXvZkJMz5T2tTI
	 +El5ttjFNenzl2T06n4jqHFodTb8qYq8QMMMxwO4WvGFq9fbOOByWRbjdB0RjkPPKfXMF
	 bk/usrG6NIPtPL62bBpKaFp6y1an0xefkv5B8GWd9BVt2+qEFpwaHfcm34bgDo7dLAysa
	 /r40G79ExGS3EMkgfDr+UsPqYOnb790irfDHEBInBoB4Zt8TbC+O7celQGLMJKovNpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WexXnlcK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C560A2604;
	Thu, 19 Nov 2026 03:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WexXnlcK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8E81F000C4;
	Thu, 19 Nov 2026 03:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057267;
	bh=v6t0wN9QOxi5MjrkYtiMktVLtwJu6V8z/1LK8LUe3OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WexXnlcKYBcDFFPpvx/gDHpEzm5CetGOoeaUxs9MhjwUAgdYwHaw7yWwotK+hToKl
	 trNJFbvTG8kgTt3OBaX6uvSNPiYDWRxwZ4crRpOl9Qd+0I+R0Q778U3/6/VHVo9TKS
	 kETGnvRl9lQF1sEGsvnBXcoD48Vs70Fwp5chP2sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0070/1848] media: cx18: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:35:08 +0100
Message-ID: <20261118145914.045047748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



