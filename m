Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B451774B;
	Thu, 18 Jan 2024 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575460; cv=none; b=QZCi91irpe34MQB4jGRtIICBrohcicemQ29aoK023C4OKczJZMKLsamxzJ9AFB6LgKpqI7qWUzqScejqh5D5+wPzqc3gM/Gs1jHwYIsQucUN7z8xz+u8FJ/cC3RZHrmlpWBr5tf9rUx8azT8XJyA80N+Bd02600Qm93+kaedGVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575460; c=relaxed/simple;
	bh=9uPgzFlu7Wt0U+u+faC0V7RP84x5DYOK7bDwnoOk5qk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=PZvcrAjelZAxcD4+uVZpmWd6UUVXs5rjdO1YeNKgmcF0/uEQGA8az17WJhb1PdXdvqlWnsLPwxu+dg2aw2YlXC7knj8r/IYw6O3zOgv05HQ4uM8xy+k7eGlO2L6VuqTrDYfKiMyY6BvGReQiwACE7mBFZRR9o8USt/Hn2uxcxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdrpzwTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdrpzwTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A47C43390;
	Thu, 18 Jan 2024 10:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575460;
	bh=9uPgzFlu7Wt0U+u+faC0V7RP84x5DYOK7bDwnoOk5qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdrpzwTp+q1P+WregI4pk5K1KtYGyAQLISFRnOz+7Kqs5AS3GY4MSVyuHFAujc02Z
	 cuLfe8w0afcjexahd3jCBBvI4xr9XNYpy7Gv1VKz3zKYPoYGsH2qoyyJZMpiplwWoV
	 4iR+nE8hKMZOnOP/ZlY16GN/aZso8Z1rUunPyxX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 141/150] binder: fix trivial typo of binder_free_buf_locked()
Date: Thu, 18 Jan 2024 11:49:23 +0100
Message-ID: <20240118104326.590816658@linuxfoundation.org>
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

commit 122a3c1cb0ff304c2b8934584fcfea4edb2fe5e3 upstream.

Fix minor misspelling of the function in the comment section.

No functional changes in this patch.

Cc: stable@vger.kernel.org
Fixes: 0f966cba95c7 ("binder: add flag to clear buffer on txn complete")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-7-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -706,7 +706,7 @@ void binder_alloc_free_buf(struct binder
 	/*
 	 * We could eliminate the call to binder_alloc_clear_buf()
 	 * from binder_alloc_deferred_release() by moving this to
-	 * binder_alloc_free_buf_locked(). However, that could
+	 * binder_free_buf_locked(). However, that could
 	 * increase contention for the alloc mutex if clear_on_free
 	 * is used frequently for large buffers. The mutex is not
 	 * needed for correctness here.


