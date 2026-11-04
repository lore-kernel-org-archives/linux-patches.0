Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829479;
	b=ufUJraG5MD8a/freQlRfshBfIZlpoItZxOq5NnKuEts04nDtOqvF7U4K4MZfzdeI52bq
	 4gbmQYGxgjLW3hqwYhYg8xVMErIplh8u8c7pKiNaRLtGHPlWjzMrsp4cx604TCEkQrd1Q
	 pUNUxGEJXGkGGLSHR4G/IIwY/GN2mIY+1Z3E/khXgW2/rMEDF7RD9H/1lQdw/qxK+RmLH
	 F3jTQV8FebKu92eDAhi2EcGBu3K6zbgVHXuiRH5CQqNITphIefpObYX4m5OUdPxNfjMVl
	 JlFKyhUodyT8GsYZNqwKlJBH/TaOR7/PEnK0jee/u+M6NTB/EPKJAr908nBfiCBV/ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ccx8zE1ruMdw0B6DGYxl1DT3HxsOIL6K22niL6Cdwz8=;
	b=a84Y1OBLaqlqFbtpDhGlg+zzGtUkFgFw5/CwnB6l/703CRmKAs/LH/YhGRFtOGThqNaY
	 z/d5iZSyldmDm2XELPF3iaqjaipS25kAGoMqlOvYBYm3U/+8tKQYTsRduhyB4ymphZ6Ss
	 gTAd0tmHjz4oF2t+19mXMR7ApqGfZMddbBE/aqxzL7EhFD/pP6/ZSELHaep7Xr501Zn26
	 7iCDtjTj17l5tSI5czx01aMLXnY3nLw4yxDxQKB5TA9u7l3pf6KH8/1+I5U9UtH3tlb9t
	 ieR4J2Y+GwgmgsDrx9EzKqpWbcdou9ufIoYyWg/PHE2mHZ0zUgYh7dVnsJ5cxGV2NVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBDLrtnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915206082BF4;
	Wed,  4 Nov 2026 21:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBDLrtnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313FC1F000C1;
	Wed,  4 Nov 2026 21:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829479;
	bh=Ccx8zE1ruMdw0B6DGYxl1DT3HxsOIL6K22niL6Cdwz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBDLrtnXVzf0VlTMaLSXhcuqEwJI9oPfEsEHIuSTYOi0J7iGNDnO6h0IqLb/e1tyX
	 QCtc8BISd1fH08gkOUzmiY1tP1I/yTFyhTUJiNFOB75/tcvTyJdXD0zPGKmhrd7nDj
	 /E9IfTanP/HYbLyivSvwDIlwosHIudeg8qLvABXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0152/1005] media: ivtv: stop VBI start-code scan before short tail
Date: Wed,  4 Nov 2026 15:58:05 -0500
Message-ID: <20261104211047.989727213@linuxfoundation.org>
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
index ae7a00f462574..af086c4cbe1a7 100644
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



