Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93121FB2;
	Tue, 23 Jan 2024 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970908; cv=none; b=aqi3yrZMY7vEIVLFI7tRC4oIM4pzeZWsGmXIdRa/e6YoQ9DXkU2x7imhZ9iz4GN/Mp7Q6UJlUGCm2sB1qLqKsXimVqMBeSmQmUT5NwfurnPwf5/7RZXLvBVpIQiVarjbHT0sEPArNQypGSp02qTxROd0ZW/BYLaboLT5qnEvUFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970908; c=relaxed/simple;
	bh=WlvjXKe8b+8TxBd6/mXQTwL64z2Q5dY+tctKVAB9IN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qxv7hCIGEzDqssivlTE1g6CAm+bpJZnUIhclfGDJllMBol7eseIoQhe/Ut3zbJ5iwd0wv8Vj6tCqYJsdnhCwClB8FTc0ulw9e1pV5PdpCSDmzcNl+EjcMabJZ3Ko3xRFSFSxQZ7HVB38AQ6b+Bp0A3brlJuSSApeufxX4c57itA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4vboHgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4vboHgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC8C433C7;
	Tue, 23 Jan 2024 00:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970908;
	bh=WlvjXKe8b+8TxBd6/mXQTwL64z2Q5dY+tctKVAB9IN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4vboHgU5jEehhDO3RRwIZYDYwH7XvUoEqPxm5KWrLu2iGgRa49ylmP0cvoYjYMB3
	 8yQ7OF1wjiMkFsJxUpyfT2KA08zGJkQNh6RJ5QGSf2QNldqWnysN3PyIAUfqCDHs/U
	 L/Zb7QaNnI2Ga81YoOH6Px85X3d5506uWRLRY8HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 043/286] binder: fix comment on binder_alloc_new_buf() return value
Date: Mon, 22 Jan 2024 15:55:49 -0800
Message-ID: <20240122235733.681799284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -562,7 +562,7 @@ err_alloc_buf_struct_failed:
  * is the sum of the three given sizes (each rounded up to
  * pointer-sized boundary)
  *
- * Return:	The allocated buffer or %NULL if error
+ * Return:	The allocated buffer or %ERR_PTR(-errno) if error
  */
 struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,


