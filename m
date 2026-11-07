Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064758;
	b=cwltpIr1RvYsxOcP/27AJzcIkiBaEZe1I6ppKeovd9Nj0xuQf3xZ/TDCiJRBMt0JNnXO
	 z5gYRjzH3nGgEeBlUCuYlpiNDEUYJ7B5ZCktoivLjCUyyXV8QMpBqMus+zqI+xFah7+H/
	 C7h28TcA+WqvSXFJGAisYWSxZfnZssVGE3ByashATtNmmdC5IaX03SMM4//H/eGe9Xnfc
	 aQPb0P+MKpryqMosGxxWbE513pm9w4kO6KuXQYTYKLQbZ5UJqoUjfoCgALhu9cqkeGp5y
	 tzbpFthDfkt8NQKi9woGvhQBAApRmXE8DJcnvhsVB2hl2NC0Ig3s7e74xOnTke5U34Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/jx0p/rxsMpUYEE9kfXcgGY4rOv5fg+Pv3wp7DIJxw=;
	b=fpN+kGroiP9Iuv7/WmegI9COtvxfV5NWj4TlKqDuEhuSPjQxAaPOkbmobmPvKpqIc/ps
	 i5y1K23xmNesV7EDyD1RuXTA4En0BQJETU274ir2pQP5fidz+2YXH5TnkMn670GGl2LAD
	 npXHFn+NZ4UTpyqtk8gKaFv1b5Yvf6Ytrn7ZwU0ZnjYhI3OAnmGCgesEPmTLt5JASi3cD
	 aDccsDLttspav+NXtEKZ1mD9yDt2UMepIC6lQjzE9PSrpF64RWw0teS+niIv14aiWpdHC
	 7dxyqL0d55zIKvbWXt6hZ7ggIsyxqN/DK6QGVB225bEIZKYv2OBm4Fk40HQFzGdINcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T8kjM1xm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE0606C002;
	Sat,  7 Nov 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T8kjM1xm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A890F1F008A2;
	Sat,  7 Nov 2026 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064756;
	bh=1/jx0p/rxsMpUYEE9kfXcgGY4rOv5fg+Pv3wp7DIJxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8kjM1xmfWLCC/p7hjXCSkJEPFtSQthYk9KrDNVQqoUMImgB0WtSThkaZZj5LJEzU
	 O49WbG1p8mOOBSEGD8E8z8oeXGFfVUzAUL3W2Yiwtr4kvaDVDU583FfdFsE9BC+v/F
	 4LJ/Ndja4ihfYfDFP3LMWNzyCoIXQFi7wY7x4VtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0728/1257] spi: ljca: validate the response length before copying the data
Date: Sat,  7 Nov 2026 08:50:24 -0500
Message-ID: <20261107134959.376834309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 0fe4573c822c4c9152e2fd5269ab85410c9e458f ]

ljca_spi_read_write() only checks that the response from the adapter
carries the packet header and a non-zero payload length before copying
r_packet->len bytes from the response into the transfer buffer.

The payload length is taken from the packet the device sent back and is
neither bounded by the number of bytes actually received nor by the
size of the requested transfer: a misbehaving adapter can announce a
payload larger than what it actually sent, and the memcpy then reads
past the end of the 60-byte input buffer and writes past the end of the
caller's transfer buffer.

Check that the response carries the full header before reading
r_packet->len, then reject responses whose payload is not contained in
the data received or is longer than the requested transfer.

Fixes: caee8e38da67 ("spi: Add support for Intel LJCA USB SPI driver")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013031717.3933277-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ljca.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ljca.c b/drivers/spi/spi-ljca.c
index 0c6e6248d8ba3..8fd001610f67e 100644
--- a/drivers/spi/spi-ljca.c
+++ b/drivers/spi/spi-ljca.c
@@ -105,7 +105,12 @@ static int ljca_spi_read_write(struct ljca_spi_dev *ljca_spi, const u8 *w_data,
 			    (u8 *)r_packet, LJCA_SPI_BUF_SIZE);
 	if (ret < 0)
 		return ret;
-	else if (ret < sizeof(*r_packet) || r_packet->len <= 0)
+
+	if (ret < sizeof(*r_packet))
+		return -EIO;
+
+	if (!r_packet->len || ret < sizeof(*r_packet) + r_packet->len ||
+	    r_packet->len > len)
 		return -EIO;
 
 	if (r_data)
-- 
2.53.0



