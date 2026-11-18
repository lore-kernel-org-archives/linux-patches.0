Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033702;
	b=wMLivxxQVWeQT27cmXRTduuRb35cZ4XynUSTRHZyoVuc1P2VKWoR5IM8A7GwvCZg0uTT
	 6JaowR3dQXchg0NBqqeSt3+jaNOeAxEOQwDQC4j7dqkIwlGd2klMWg+5+5TpRGupzKs6s
	 /4A+IvY7nbpAqNI/cguiW1/8bMQLpaaIoUuNqCpj1AKWv19QJfGxoW+hqsHVMbh9oqd4v
	 32dHmoYyRm/pFxsYzN+d8bFx06RzQdRppIJKI8x9tAX/osZt74G0cPR/Iw+aFBXO/g64X
	 XYuWADx2K7Nf58rk5o7IqKblNtVjYYES7lsSiroi0UoK8XR+GtcqVqqAjYqqLn33NMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZUYkpIfyyC/lYHHEgyS9fWmEHjCroE8ctuH0h2U/w8=;
	b=L6xOETovgwOuV5MpROzxazWNajRnvD1P0ran+dBzrtGlBHA6MLjLX3Xt0HbrS12Abvi2
	 kw51azJkd914pGnqivUGS0O2xsLU+TJO6sqP1pcMwcECSB64ALvhY0LqirHYEKAD8BSxX
	 y9XwEjdLPnpSWGYdsICrPv3O6vPnNpOvOH9oiNaWYU6OT0vnpHlybWtAbiaIhsPHVsVH8
	 MIhuUEdTKRUOBNJ9GrcSOrUOsz8QPnsAb/Ti68fFiMZ30Qj1DikY5kEwXnyaYU8S9ifks
	 seC4vCPgmXFE1CCPlXraU0d9mNgr+kgItyh2Ow8Z0/D0q3QBEos1y7TYrJiZFOoVzrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0SpocphF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975D60A2606;
	Wed, 18 Nov 2026 20:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0SpocphF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C781F000CA;
	Wed, 18 Nov 2026 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033701;
	bh=GZUYkpIfyyC/lYHHEgyS9fWmEHjCroE8ctuH0h2U/w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SpocphFAhr3JyyCO1TyEW7p3XKNgFdsf2PfgaKYhut9hF20+F2LWZeQtZvLNDnsu
	 Ens7Xwg1YJoZUAsvpWVVnZ3XL/h1ilsF/IvXW5iRvMLTFobENeY4Nf/sH5iOD7pziB
	 2ixCKu5Q10xA0MwW9AtFkuXLJ9ofB+cGyVNNZvoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0107/3318] media: ivtv: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:12:09 +0100
Message-ID: <20261118150317.469393823@linuxfoundation.org>
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

[ Upstream commit f373cf17fb8e7a530bc6e1e36fc41cb5dab2cdaa ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index 80478b026d752..279a4d6bece19 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -330,7 +330,7 @@ static u32 compress_sliced_buf(struct ivtv *itv, u32 line, u8 *buf, u32 size, u8
 	unsigned lines = 0;
 
 	/* find the first valid line */
-	for (i = 0; i < size; i++, buf++) {
+	for (i = 0; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] == sav)
 			break;
 	}
-- 
2.53.0



