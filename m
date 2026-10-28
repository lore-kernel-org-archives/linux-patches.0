Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208880;
	b=e1+ZyCD4fNMOpuyIxJB3O0k/Dar+ny9wXTqICRz0/j6nOJVRApzYSxvATM+gUMw+eCgV
	 nWjhBxZq1b7Pbdu9gSkwUl1Imq6VFidU6Lwi9h5DY82QuvlWjOXtGwlloP32k7x8FP2Z+
	 g3Bd//QX4XaJfIhvRSrOoKEeSGD/LK8/yN5SD5mAhABoVhLb9CUYiXnR0ynk9SNyZoWsL
	 uiDdjlk+DxejVBltDzkrZHayLzbhlaKDWNoZccqhYPWjNcOuZkKUNn/+IZ1KMQt5QAJu5
	 Yp2ZS62sdg/qVundOJ9CG7c7Cjs/fcBowvz75GOdZduaUl2RGg+T4FCjS9bTf//d0hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAOejjyr2i0nFRFssHJeupEoQSdeMmXGZpyCZvyF8hE=;
	b=tusBGxvG/7MtdmtjDWqvBgVQx3x89FEclQYichci3ASalJjgDCaTSuCFSUyZ7tB64KaA
	 hxVeFmS1shdqXkep4hlo+oAhPCUfU3QWkPEmxRz8J7k0vMrCz5n2p26DV3LpfNAtoyFT6
	 Tqv9J1aoulhWuF7Jlg0WPtkRNT79C9PtH4cGgwX6aq90QP/6NrX+V/DQwaAt/vpG4MuO3
	 mpF96eI50pucozl6D5vaVYt+OAVQhFdps3B+6gHnTx0xeVqTGhSScE4M75YnSdFLYFWcO
	 n37Bf0MCMbMoeSs4K+PHlSquSRWjhCircIvy3G7OdACIZVqH/Kxx72Rb3AmmcC86NPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvbiTvwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EEF606A31A;
	Wed, 28 Oct 2026 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvbiTvwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCC41F01825;
	Wed, 28 Oct 2026 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208880;
	bh=yAOejjyr2i0nFRFssHJeupEoQSdeMmXGZpyCZvyF8hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvbiTvwofC1pP7VpRTU+7iWeXFhXSu28e1wZUiB2mFyDsRkpn+edfmSOlGUa2hKkJ
	 FlRzioxgqixlsPLRmn+Igm41qaqtnGFVPR/4/ehxCRXSLTHIuVCuLk6PqXpXBoxObv
	 TDWrEdi33vXUPGmFk7nmpIbwGlAbjEy6xg18ccw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 238/516] iio: imu: adis16400: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:30 +0100
Message-ID: <20261028170009.140302051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Arka Mondal <arkamondalofficial@gmail.com>

commit d94787287a113a1326211647d5e0deed1e9de105 upstream.

adis16400_serial_number_fops is open coded and never calls
debugfs_file_get(), so debugfs_remove_recursive() does not wait for a
read in progress and unbind frees the iio_dev underneath it.

Commit ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE
instead of DEFINE_SIMPLE_ATTRIBUTE") converted product_id and
flash_count to DEFINE_DEBUGFS_ATTRIBUTE, which protects itself, but
moved all three files to debugfs_create_file_unsafe().

serial_number prints three registers as "%.4x-%.4x-%.4x" and
DEFINE_DEBUGFS_ATTRIBUTE() formats a single u64, so it cannot be
converted without changing what the file returns. adis16475 and
adis16550 already use debugfs_create_file() for their open coded
files. Use it here too.

Fixes: ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE instead of DEFINE_SIMPLE_ATTRIBUTE")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16400.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -286,7 +286,7 @@ static int adis16400_debugfs_init(struct
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
 	if (st->variant->flags & ADIS16400_HAS_SERIAL_NUMBER)
-		debugfs_create_file_unsafe("serial_number", 0400,
+		debugfs_create_file("serial_number", 0400,
 				d, st, &adis16400_serial_number_fops);
 	if (st->variant->flags & ADIS16400_HAS_PROD_ID)
 		debugfs_create_file_unsafe("product_id", 0400,


