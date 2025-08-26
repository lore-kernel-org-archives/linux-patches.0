Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA5620B7EE;
	Tue, 26 Aug 2025 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206776; cv=none; b=Zz98t46b5tuiqTandI/WICd+oB0iwtLK2TUX1HpsaZ/5zGq4jAW5cXFv9SZsOvopkmcZvYJP2vndqK9igrvQ1wwIyXCX7O2QLpiABv5OTzeUZrtYjgzeAgm8ba3rfCDnfdIPDE6tOMGXEULHsXGcVkY59lgw3CgGQXZDpsKtcJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206776; c=relaxed/simple;
	bh=osAfmBSyVzf1FxJNLaGqIkPBAu+oBVA7n5eZSmu9Z8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgKrL/EBdpzjwzqcH7XHM3bcFpqyD0rGcCoO20FkqRA46QjclWxztCfgS4Y2n9e+DjgTyKV3KFkKa0WUblQLkqf5dbFIh0RktT1kKf7Hmg5kdtcUIZyJS+939mM4m9SoVmTZ6MXT2dhTx9Xy0ZDQd+RW8A5aHtYSXw2skiCBLuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3P22QzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3P22QzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46322C4CEF4;
	Tue, 26 Aug 2025 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206775;
	bh=osAfmBSyVzf1FxJNLaGqIkPBAu+oBVA7n5eZSmu9Z8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3P22QzPwiMqKbY8UryE1wT+R13EPWoN7MWq6qEh8tPEm9mCZvI5HAxgrxQVL//Wz
	 WH0lrKVueiriFFak/slnzp3surDEHgSteezR+3MVKI/Z4ZcZXZCQDdqN8DEc+Wurb2
	 uffQT9AwIKeRPKXS/eYQowbIvd1MjO/XXDIexYIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 001/587] io_uring: dont use int for ABI
Date: Tue, 26 Aug 2025 13:02:30 +0200
Message-ID: <20250826110952.984811109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit cf73d9970ea4f8cace5d8f02d2565a2723003112 upstream.

__kernel_rwf_t is defined as int, the actual size of which is
implementation defined. It won't go well if some compiler / archs
ever defines it as i64, so replace it with __u32, hoping that
there is no one using i16 for it.

Cc: stable@vger.kernel.org
Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/47c666c4ee1df2018863af3a2028af18feef11ed.1751412511.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/io_uring.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -46,7 +46,7 @@ struct io_uring_sqe {
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;	/* compatibility */
 		__u32		poll32_events;	/* word-reversed for BE */


