Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212973;
	b=GKR9sf1MvOOh0mT2plm7/Q93sZeRfGEmrv+2kBqyOliVGxdk57YQtdVmmo5+GaYmaRRx
	 Whmt1JG9BDjZpD2aJRk3ClI4wvTKFDEzAaYAF3aESJrpdW6fNBezyNUgZclGC4GJxp7C3
	 amZkMYXVn2DKvkDICC4gg9Wr47w79K1ljEH8tjr9FydTUsBx3rIgCkmivYVoEFoIeuaPp
	 e7oRUI781XQRuXgEdr76oAruaaSdWxAgdZH3kOPbvnvbT1oUHzVd0t3rO4UFtnnCc1XAt
	 87rBblSae3ZzRz5bGK4aQKTu17qd2Fdtem8fQnPK8Grul+NLKG3rRXzrpMvvLIwv0gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJi3kW9chbexC0hjy09qjH/mDRMooGuePZsIAG2QjSs=;
	b=4c2mW5PLzfiMpCXweVabi1wODIQEsW8MIr1vIYuTLJPyLozAemdWgfaRYBmHizegihHj
	 SupYXHgdxz/p88GgzPwtaIcAQNqBwEzbERHRUrSHsvV9NK342NLfCEEEJD1ipeMlFf6Y4
	 XH8l+gjg19X5cuvF7mCcxpSXg3DeLUS8ZN9yrmnyY+b7yNm588EdU2Rs3xkcwG2as8E59
	 k+WVFdU+7yqOpFw/3fqHc/rKCjqJmXn7ZY4yKIovUlig7me3S8I/72MtOxJN/8BDI4Drn
	 MJdWQLtNvxQgPkscAcA1mb16bEXG1aj50/lGHMplKREAmWyGSKRrBXNLiFuQqAH892A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SJpfYCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C79606A321;
	Wed, 28 Oct 2026 18:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SJpfYCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F21F031E0;
	Wed, 28 Oct 2026 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212973;
	bh=nJi3kW9chbexC0hjy09qjH/mDRMooGuePZsIAG2QjSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SJpfYCq58cJ4YssgO4YMaWaHWJNyCYWH+4qOc46WeS2rl9tP+mw3ad/TnIdTdVEp
	 ONYCeB7xQJlKnFdUlypMZY02PcHsLd8sbsx3Ex27FCfTsHbLT6JHcsuW0jjDvSUh9z
	 +7NmAqK/NXQtch6h85OJ0zth33a8gysnk9a10MPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0340/1887] iio: imu: adis16400: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:40:36 +0100
Message-ID: <20261028170506.963439146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -279,7 +279,7 @@ static int adis16400_debugfs_init(struct
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
 	if (st->variant->flags & ADIS16400_HAS_SERIAL_NUMBER)
-		debugfs_create_file_unsafe("serial_number", 0400,
+		debugfs_create_file("serial_number", 0400,
 				d, st, &adis16400_serial_number_fops);
 	if (st->variant->flags & ADIS16400_HAS_PROD_ID)
 		debugfs_create_file_unsafe("product_id", 0400,


