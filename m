Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3AB241E9;
	Thu, 18 Jan 2024 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575756; cv=none; b=ACL/DPr59qADGNUXQfrZ7wciGTUuR6z3b7z4yUqEMy0mh0tz+8/2A0Y3zVKYeophEPdK21f3Cb2Idrc6EOhZOzG9dkYaiB/8W+UAQskCbs6FzeXOn22aWteW8gBws4XkULd9/Ta1RvdUDmeohd++vxmp62CQbllW/E8ObYwJutY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575756; c=relaxed/simple;
	bh=pTZTmaFih0AgFr2CYI/A+XNKbpJlAIQU6mqA6VbOfuw=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gHW4v+LfpEMKXAfiYOZHPNZOkIxJqobVvqzbvZeTukRDqGA1WPBeG8rGPkWw40OI9ocQutaR9x8su5mimx/NQphYXxn3SlKB/5mRDYJi+11oBx5rli7QFPw0kVjIy+BHRdJKNkgUICP2lX7Vjt5qL93azFM4K9cpuwHI6DKWrLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyzzVGSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyzzVGSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8664DC433C7;
	Thu, 18 Jan 2024 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575755;
	bh=pTZTmaFih0AgFr2CYI/A+XNKbpJlAIQU6mqA6VbOfuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyzzVGSFSlGjH0O+OaMxhtBK9txeQkAz1Yt0WDMbvBWviZ5QkUojcVU+8KZVNzMLd
	 lUeXTUtyFgnfeGYUODtHZ+fon/aJPI3jaWL/w4jmsAza4Bfs3QZFRmLIO3QdfNysva
	 513r8VnEKlqvj1BDxXiopPaTfvvrTF5nPzvKQGlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.1 092/100] binder: fix trivial typo of binder_free_buf_locked()
Date: Thu, 18 Jan 2024 11:49:40 +0100
Message-ID: <20240118104314.904839913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


