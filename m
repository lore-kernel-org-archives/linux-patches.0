Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4D22F0F;
	Thu, 18 Jan 2024 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575079; cv=none; b=Qs86UafFWJ8CXT4oX8/aBNK0Bnq6AQ0gDKw+bz/Aqj2UDXzdeaL2HmUDxIV3yWZk/PzjtTmH0vJRy5egrE+21tE1eKECOXymq6h4xZQAUu9d86dxu1l/5VVxXDsYz2geUYmxKcmif8svzAdfmcQJeZSDEin/j+H3LBofCICPcZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575079; c=relaxed/simple;
	bh=O2K7G58sv2oQf+t/bkRBKh90Xs6aS1XjQo4hPRM5Ky0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=IqA830EwA3nSu3Ik9R+FF/x+vteTUtNWKY9goD0YTUQTH3zBZb4dnhXR1pnmlY0woPSaWCuHCJwlJNFvy6oSD1VsEEYwTI6l9xrP4Lgdxd7gYktlKlnaeTtCVUwv50ZVoZgbAK7T3dK/HM/b88DdHSw8+ic9M+ZgC7Cy8sgAqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQs9MXX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQs9MXX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08341C433C7;
	Thu, 18 Jan 2024 10:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575079;
	bh=O2K7G58sv2oQf+t/bkRBKh90Xs6aS1XjQo4hPRM5Ky0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQs9MXX8jVxasAVSrj+7HkcvqDBogD5qccT37d8bha2ImwB6P9t4m2nrX9JnMwd0z
	 /9L5DyK7OF639odL3WvO4uGORcO5p9fk9uUzFTMR6o10YYdVqcvutyiiG1jQri3+E5
	 FFgma8repdGLK3StSPfPHIaHwXm6tKULlHKqIsHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.7 19/28] binder: fix comment on binder_alloc_new_buf() return value
Date: Thu, 18 Jan 2024 11:49:09 +0100
Message-ID: <20240118104301.899537136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


