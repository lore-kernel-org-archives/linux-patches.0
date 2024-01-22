Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450BC14A4D1;
	Tue, 23 Jan 2024 01:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972124; cv=none; b=MTm7xee8K5vox+sVudl/0WmMPL9a3sk5Kozd1AKoofVbuzY8kb9B9sVpqMsEuogxpBtYmwZYrYBjvVpTuxzwfBfT2dHvQp1uShUo3pZexuNiG7vDSkK8uWOlTAqljDlQEbZbsK+d3rtKH5sfliT3LOEQOaE4I/aw7t8qB3yTRVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972124; c=relaxed/simple;
	bh=enyAiGWjVonO4xp5jDGQdGoTliFAn8nyZAzIUJk4yHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9bPEMJB7Y7mxASbKmo16cZ43olrGGhc0oHUK/c4UdKqKO1j80t3HpYHN9OSun6U5goFhtCAqLW4KfiWId8iaplwGk4Xdne0++VEKqd5nJgS1pRFGaD6PbMMmYglsyWrxW/5igpF80Hs43ELZDXuwpF9wVQ/X5KC2q2rieXFEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtY1JzJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtY1JzJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C23C43390;
	Tue, 23 Jan 2024 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972124;
	bh=enyAiGWjVonO4xp5jDGQdGoTliFAn8nyZAzIUJk4yHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtY1JzJpKhTNhacJnt8ABrZk65yw9pIQtc7ososeqMyjMh59RmFaiWMvKYf0Jbz4x
	 hy4vtnlQdV68lkJKRbDpzAt+AnzIRT+L9qkAa/Avfo0U/PVxeZWssNGxtUxTuctssF
	 gvY+wKF3kFKnkrLZyU8uaJjUfGk9efOyW/S3Y3Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 057/374] binder: fix trivial typo of binder_free_buf_locked()
Date: Mon, 22 Jan 2024 15:55:13 -0800
Message-ID: <20240122235746.592025677@linuxfoundation.org>
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


