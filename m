Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057264;
	b=qizDBGDGS7Un9Kf7ww9vIZEgYeT2qZ9Yoncrv8HWwBzwK8UF9ZEBLsgWEIILoTL4bRgw
	 ICHQLk2BHa+C5YZ2USmPPV9VR8f7+Wbt3y+2ebwMgo6Ox7HFLUA2CHrtzQl44QpfjaV7D
	 tCOM4Qh+EBHEMHCOZLAhdu0Ccb/ELsZ8JhEyyDFr1DD7/urIaseZgdEXWpUvKZUpjmBH1
	 scK614oGje45Nx7U7OC+vTmTGQ/9aIb5NHHn9g6p7yqoNExYS8kSiLgT+zOaAQrny1fJ4
	 Gr+wmFJ+Ji33RMklEKglZMVWntzpgo/WZkY8T61dizthi+xm3DTmASgih+uybc3dBKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbLEXt5mEludjDxLp1HJ+CV6dNKKvRGESo51Hrw1NUY=;
	b=GvGEBcpZcymKF5xsBEa5MSfRWnTTfxZpLld4IOdTDEFjHHQILj/GvNXUgHIk7FSEk9o/
	 fAaOGLSYmLZhLAIhU9zxY4zGvnoZMxPPTNnw+BWAcK5MULMIRNqXYxd+jzQbxdh0tr5I2
	 zAGNCedfDdl+wPpdJ+XR3noCW5nsqk8xFi7/Sz38XZ9/n2MKsCdg+os37BczIAf0eBRbm
	 6Kzi0bS8ewq1V+cRi4xYIJWXhjFHX2b298/fEupovnW1l3mqg2Yhq6coqVg/M2YSxvJWX
	 WH0gzheDfS7zvnvc3uKmfyY8vlVQg0FLSuN7TmaJsGF6gZlZqt0YL2XHgjMge5ZtB4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R1/tiinh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17660A2604;
	Thu, 19 Nov 2026 03:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1/tiinh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A2A1F000C5;
	Thu, 19 Nov 2026 03:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057264;
	bh=CbLEXt5mEludjDxLp1HJ+CV6dNKKvRGESo51Hrw1NUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1/tiinhwhaCOj2tE+we/Rxe3B7GEZJBtUllWlkAvh4vXR4Te53swfKqLTksPJb8T
	 JQr8QPojV6WohZzrWWDhKq6Uxd+SyzwzKJTRc2CPG2ujcrDsZch/lTKxjkumIe3bRq
	 W4lgx15+dg3qGw8jF9Iv2i9k2YJFhpEPyoIo9NCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0069/1848] media: ivtv: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118145914.013010116@linuxfoundation.org>
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



