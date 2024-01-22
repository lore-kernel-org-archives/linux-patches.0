Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617A61420C9;
	Tue, 23 Jan 2024 01:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972125; cv=none; b=iEwchKHyHYM1ue/2sCKoECOSQMnj2+nvA81juRUbJbSvVD4R1mjGCtTxcTg7h5pLBuvcVozJq9bbOxK+BLX1bsCJkeTk4wfgZxnUxg9Gqo8F3P8IBcxogX3cofScxIF1mQTgd4x5QyP0Q2QVczpmFf0AP0QALAeQupA2UOXivLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972125; c=relaxed/simple;
	bh=0B+4d/HY17Yx7kR8rhbUjd+ZKbNftYOwQxrhlwaL/74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueplsGH+ngTsJQKLDC6zWRM4HUxSCeTKLegclvaeSpdrVFE6CyJ2vgc5tmullgPS9DsdSEQ0hZOo2dNmUBJU2WoPMWDhUDYsoham5ZHjVpKn9MMgfGbGvFzm9QepGkhrY9gYwqnqF+cgVvfqiQed4utcaK8zU/PeL661xH54wcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9F4C1UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9F4C1UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D925C43390;
	Tue, 23 Jan 2024 01:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972125;
	bh=0B+4d/HY17Yx7kR8rhbUjd+ZKbNftYOwQxrhlwaL/74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9F4C1UCHRjgZedV/RGPkyNyDC8M9QSvLcT3EkkP6VWHHASMbgGuZbrStlz0QTKoN
	 bukoxHUq6NBT8r+PkEia1NTxJVQKyofbcKSdp4iut0rpKHiSijgeqBoBH1gnu2LYHS
	 knFiWpN1l7B+cM/UDV9cr8CQodZHl1NdgYX4Yylw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 058/374] binder: fix comment on binder_alloc_new_buf() return value
Date: Mon, 22 Jan 2024 15:55:14 -0800
Message-ID: <20240122235746.626462031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit e1090371e02b601cbfcea175c2a6cc7c955fa830 upstream.

Update the comments of binder_alloc_new_buf() to reflect that the return
value of the function is now ERR_PTR(-errno) on failure.

No functional changes in this patch.

Cc: stable@vger.kernel.org
Fixes: 57ada2fb2250 ("binder: add log information for binder transaction failures")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-8-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -557,7 +557,7 @@ err_alloc_buf_struct_failed:
  * is the sum of the three given sizes (each rounded up to
  * pointer-sized boundary)
  *
- * Return:	The allocated buffer or %NULL if error
+ * Return:	The allocated buffer or %ERR_PTR(-errno) if error
  */
 struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,


