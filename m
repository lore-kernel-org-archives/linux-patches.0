Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1254C12A17F;
	Tue, 23 Jan 2024 00:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968840; cv=none; b=DkFTJd2fOQ6g+BIt7WuPhsyqzoUBDQH45ychw3mlh6qZQKN3tc4UAPO0n1HMcZ9AWkXOV7xgxDtXAkFp2ns81ZsH/RWp8nKs7GjpQv7IhmM4LfWpTZuUldoXfYgqQ34kir9XGsJux4sVW1Rm0fP3Y9yANuIlDDerx8HT88g3Fy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968840; c=relaxed/simple;
	bh=EVJLfZHDQe36mFWrcGNCfrjn3zKcTzYG2WZihhU3X64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXrbOZFlIw0F6Q5thlTHDhbnqCzI2Hr5t4ej1gfXNjvXC+BxCZ+Z9Ie5nSQrT2qO/A4y7BQin2if6r5Qe9u5CpVGKJkrxEJoVyJCDcZocAR2fbXhxCWvFMHyRoWD0DyT6g0LKlAMDuCSJq5F36Wb2Ox0O8evV+g1yeMWL8sQyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvsNwZBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvsNwZBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A49C43390;
	Tue, 23 Jan 2024 00:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968839;
	bh=EVJLfZHDQe36mFWrcGNCfrjn3zKcTzYG2WZihhU3X64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvsNwZBKHPGetAF8n+GNA0mqMxnG3a2hcR5hVAQp8BRsGeyz7firbRmxtOjllsa76
	 QEHyeYnQ7WuUlzbwEqIuR1FxNdhhWbGkHc9fAKNekVrWrKpb8Hqc02K7R0hsjB53Eg
	 6LufxI2IutKBPNNVgXsIwaiHG8YxH2LLKE0TFG08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 035/194] binder: fix comment on binder_alloc_new_buf() return value
Date: Mon, 22 Jan 2024 15:56:05 -0800
Message-ID: <20240122235720.712262193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,7 +515,7 @@ err_alloc_buf_struct_failed:
  * is the sum of the three given sizes (each rounded up to
  * pointer-sized boundary)
  *
- * Return:	The allocated buffer or %NULL if error
+ * Return:	The allocated buffer or %ERR_PTR(-errno) if error
  */
 struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,


