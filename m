Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D5A1774B;
	Thu, 18 Jan 2024 10:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575466; cv=none; b=T4QhR6aty/xPu96f1s9rKoD2+0dkIu/2JZXVTmqOPEKdEjzTZD3PGWvFM+CBd5Eys2gPcFM/d8mb1EJjGCb31MbhStxyweezVeKkfJz5nf7AwgtvrNTz+Zb2c7PipcCah7bipVzQPN/9dbxuYf1hKSK+UrD6IyrQAxzMc1VBwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575466; c=relaxed/simple;
	bh=pFHKzdFKpNTVcuk/tACP/WlgizjIjx2u52yud6cWLrU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=QyBg23OVGZHq1hp6ITQjX574jGH6lhMsb55E7yg0dtSxUYV7XBAlfKCpUSFiVKpbAxOkJdFetaRMYafn1aBjRT6rfe6Fb1wU+rrf+1J/oFM+BHJWMuvxcTIXmhQXuhGEajgzAKddeVKY4QWWtEuGsP/q+rZsJAeGRqzjeoWSaig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5JtycwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5JtycwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9188C433C7;
	Thu, 18 Jan 2024 10:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575466;
	bh=pFHKzdFKpNTVcuk/tACP/WlgizjIjx2u52yud6cWLrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5JtycwBdyaTbxMGvq4oWkXNqQkH4p3BzbmGXxj5OHfYAlxxgzOhunOWKpQl3JPVu
	 uMvIRSgBBL78SXMPfYGhQq8r6TGIqJOyNQ9TQ/E4Rx7JR7idC72/9x/0i3zYKHq7M7
	 PQ1BZ7Sl0UIegl3fR8SqDes/DvEDw/8xVpfSeEgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 142/150] binder: fix comment on binder_alloc_new_buf() return value
Date: Thu, 18 Jan 2024 11:49:24 +0100
Message-ID: <20240118104326.640478773@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


