Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213081;
	b=SpFVysTxc6Ap6uygRk8MfSw6H2hwywIjmlQNlm9JhLvy0nCmRkeXlkSTDsuwn1MgY9a9
	 4h2Z2HGa+T+/1S/anKu55zu78zODJZht5FlLEmQNfxHybOYMEYcQH0hQ/gKqO23VFKi+K
	 vnRh6awpcgi2wsIAyDKcp0DEmPxlRnRf2c6HNrWktdXo/e4geM89gcOJzt0joNExMWFHT
	 vpEcUwNj3IbZxPJ8HChjYlgZwSWBg2EqS+H8vmjEqur7qrsr6YcMBWvPJ27arKUq5jK/X
	 YqySGjcqutRus/4hBb/MXe84s8tkoxnzOqhDGmljjrE5+KzyPykt5W++sTlQZvQjRsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6gTOZbkz6g6vmx5tQJJtkB3IORj3ePqRmoT/VnPhgio=;
	b=kikA4pooiQ67ViTA5EJmZ3O/J/fEUjI4NOQUbtOSu4yN63u4+9CCqgHRyf3ollaYDZAh
	 YIf7BC5FtfFaJQ6D6kuAAUEJUL4QYi5+3hcV7LkdW9kwZ1HDln6kj6fveO0dIKp4kdjRL
	 C0DakUHoMbeYQU5ynvWOd2oNDS1bKp+ir+EeveoPuxvVcpeM06inSJus3U2GhxwyKgzJu
	 jYHZdWAppxrtSeJoEl0VKfsvlwMts/ek/nSatRfTg7bR8BrAd9tkRZX/Q8KYR80iF50Vw
	 vYPnHqRgQZBEzmUIZTKEACLtGmvLLRrbapgFysZ3pfaDkCcjCV6EBjjPxFTyVQpddRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gesfcYal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647F606A31D;
	Wed, 28 Oct 2026 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gesfcYal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6AE1F01825;
	Wed, 28 Oct 2026 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213081;
	bh=6gTOZbkz6g6vmx5tQJJtkB3IORj3ePqRmoT/VnPhgio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gesfcYalpK2OnFIG+Py79QvbN1UztT5XkPEz0R2WTNa+RCMing90r+AbmDYukPaIW
	 4DaL3jJTkmoe0sowQPDKMpDODrse4sQDae/9w2k7WPYKhw1jW8gDPu684X9E8iF+pp
	 b6OkQ8ZZVLSJwi6IuTrZZUUQi5X8ocV3V3qu0mys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Jinseob Kim <kimjinseob88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0379/1887] iio: buffer: serialize buffer teardown with mode claims
Date: Wed, 28 Oct 2026 17:41:15 +0100
Message-ID: <20261028170507.856188528@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinseob Kim <kimjinseob88@gmail.com>

commit 84bb0fc46ccf6a545b8fdf57cda83770186ed8dd upstream.

Buffer-mode claims hold mlock to guarantee that the device remains in
buffer mode until the claim is released. Normal buffer updates take
info_exist_lock followed by mlock in iio_update_buffers().

However, iio_device_unregister() disables and deactivates all buffers
without taking mlock. This can invalidate buffer state, including
active_scan_mask, while a buffer-mode claim is held.

Take mlock in iio_disable_all_buffers() so that unregister honors the
mode-claim lifetime guarantee. The info_exist_lock -> mlock ordering
matches iio_update_buffers().

Fixes: 0a8565425afd ("iio: core: introduce iio_device_{claim|release}_buffer_mode() APIs")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

[ Backport by Jinseob Kim to 6.1.y: mlock is still in struct iio_dev,
  so use indio_dev->mlock instead of iio_dev_opaque->mlock. ]

Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index af02e52183bec..37ea4a2d85f85 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1291,6 +1291,8 @@ EXPORT_SYMBOL_GPL(iio_update_buffers);
 
 void iio_disable_all_buffers(struct iio_dev *indio_dev)
 {
+	guard(mutex)(&indio_dev->mlock);
+
 	iio_disable_buffers(indio_dev);
 	iio_buffer_deactivate_all(indio_dev);
 }
-- 
2.53.0



