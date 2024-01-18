Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FE72375B;
	Thu, 18 Jan 2024 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575077; cv=none; b=k+XTX3hoxjhPQv9tS0RKjKpGNtZmL0ue2aHI5eZKHl1AoG+UUe8yMT+F4T1fb3kf/G/w8dbLQaAbqHTnNo0PbSY66DI14X+2WQ39zlHqC3JCxpwIPxU6qMechO/195p48ObvvhSppVXa9l+VpcgrdPC7iFZuV9eExFRB1s8ucas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575077; c=relaxed/simple;
	bh=gFNVUGt8BNHgIJg6OU56RfeF59IheFPNoCRsDaEMuMc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=izBNkiAb8BL4lyhmYxoH0Xd7Z0M/OYu5q2Uf/ucRvf/1maJqYhv/wBH9Gtin9Vad7wkJDpT9X0aVKrU/653PLzII/ehjRPGnVYri4WcK+ZoOHzeMXsIMp3uhYmlhZlPhzmtBx7vD3lCmVrzOQIXoUVDqCXtAlxWHqX86YhvpKD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g86YWdWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g86YWdWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A7C433C7;
	Thu, 18 Jan 2024 10:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575076;
	bh=gFNVUGt8BNHgIJg6OU56RfeF59IheFPNoCRsDaEMuMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g86YWdWFZOsqfYKEP7IRWSuPnyw6yGmWqI2bKkQX3Hv8yhDsMbHSkgk1g1Z6v0Gw0
	 njrBco46iTIstnHdSmrlQnNUytWcQw/jCfdtHu6iyrIoUrE1WRYcx0eZTUNB0hW5G6
	 E5hzolJe5o6r7XFvVjWNzHRyaXDSgN7JBAbtYM88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.7 18/28] binder: fix trivial typo of binder_free_buf_locked()
Date: Thu, 18 Jan 2024 11:49:08 +0100
Message-ID: <20240118104301.850812643@linuxfoundation.org>
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


