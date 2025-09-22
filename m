Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A01C1ADB;
	Mon, 22 Sep 2025 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569968; cv=none; b=dySXt6glPXtFe7u6rwkD0ZMP4CoEmOuOWnrRu3YeO+OyBCLAul2KtnKAea11xcL/0axpkQwroLQZF19tZ6Mj8VuMtwWAB2k0vGCBnYER1sTCgCpTY/keG4j+/ukdR9A4wMdvLgSrMKhS9zMcAgsjYmMRth+OOapwb6gGVam+iRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569968; c=relaxed/simple;
	bh=SwpkfGvBXftHTVzRpQQfdRYTcBpsjrewvtRzHq8G/K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npdyyOiQyq43CFFEVrDot8ZkQcvsryTqkaU8VbfjfDQ+6ji9taJfMzzybhx6wRrg9GmZpeF0sTjtcMnZPiYcPUCrdPkUREHbx66HF6NwZTwpAEY0paLuc/Nxu3eVkJiCJUC9EF3quAANl4RQ0waClU1YntHKyJYoq4EWnpWm8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIywb+KR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIywb+KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D1C4CEF0;
	Mon, 22 Sep 2025 19:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569966;
	bh=SwpkfGvBXftHTVzRpQQfdRYTcBpsjrewvtRzHq8G/K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIywb+KRZeFW9nKl6QidVmplCWvSX7JUwQhdFtaoZiLXkw6YCZ8B3S90qpwDjIMf9
	 Pjs+WmsSJcWewIhTmpD5TzJ8oNlw0ryF6Lxk3ZOW1xniKYPIAyUlq+DcJlj/QSseOi
	 SH21tiHwUhYr4Gs/Iq9ZYMLGABMSOogGi9LYVbE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 070/105] io_uring/kbuf: drop WARN_ON_ONCE() from incremental length check
Date: Mon, 22 Sep 2025 21:29:53 +0200
Message-ID: <20250922192410.739180672@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Partially based on commit 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b upstream.

This can be triggered by userspace, so just drop it. The condition
is appropriately handled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -143,7 +143,7 @@ static inline bool io_kbuf_commit(struct
 		struct io_uring_buf *buf;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		if (WARN_ON_ONCE(len > buf->len))
+		if (len > buf->len)
 			len = buf->len;
 		buf->len -= len;
 		if (buf->len) {


