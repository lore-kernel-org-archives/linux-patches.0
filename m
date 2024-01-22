Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643B60257;
	Tue, 23 Jan 2024 00:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970903; cv=none; b=Ny7NGbqKtdwY2KSbRhL0foxBgRuYqMhr1CVXS6m9MdYXxJAVNWz2QYD+4JxC3owM/lldvlmBdmzXnU9NVu0+o4WAs8c8OEuyidVESyyzQ2ihPdPS7Bx3eNJQ/cjRd7HhPLN+ZA/8LdMHNEzrexhFDtKJk3riEHApCmZAOISQ2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970903; c=relaxed/simple;
	bh=G3j12jLVap1Up/ldGp14ZP7mzPOcTSxYCnmCdzly5lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgXH+j8yZgbQK7oEuKMinipZoE2Dfqtn0wJmd1RcEUG2r990dyiDG9v+cc0Y48rnBvZHjyvOXQfxygvj/K3nfSJ8AclHrz8WpAHKZe5jVCJEAtzB4YbykLkrEsSKnlHTbVIRqwJs4wJV5xTMoVEueyjuJAyKALw4d7CbJwkn73c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfhGwypI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfhGwypI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5CEC43390;
	Tue, 23 Jan 2024 00:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970903;
	bh=G3j12jLVap1Up/ldGp14ZP7mzPOcTSxYCnmCdzly5lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfhGwypIcm7mu0p1eRwgpVdLqRIdYH6XSlytY9TGMoFRH04twWpryAOR2PKVkV6LY
	 jy0yay0iJrIsxRO4H7sb+Ycx+B70Hpj/l6AJF7vm5rG8mL4EBWnOY+ToCWySBN0xqT
	 nwUiI82aa/BZ9aA/EYipwYKuLs2uJUoiYZd+00I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 042/286] binder: fix trivial typo of binder_free_buf_locked()
Date: Mon, 22 Jan 2024 15:55:48 -0800
Message-ID: <20240122235733.639204593@linuxfoundation.org>
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
@@ -711,7 +711,7 @@ void binder_alloc_free_buf(struct binder
 	/*
 	 * We could eliminate the call to binder_alloc_clear_buf()
 	 * from binder_alloc_deferred_release() by moving this to
-	 * binder_alloc_free_buf_locked(). However, that could
+	 * binder_free_buf_locked(). However, that could
 	 * increase contention for the alloc mutex if clear_on_free
 	 * is used frequently for large buffers. The mutex is not
 	 * needed for correctness here.


