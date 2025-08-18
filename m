Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE54021CC55;
	Mon, 18 Aug 2025 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524610; cv=none; b=UNCduROlUXnqRy2uPt25FGWCk9LjAvoOPL+X4YPc8XK485TImIe9DuKseuaF9Yq2ZKYrOCO1m93KPN9bbbQkqnG/WSP62Vvr/5owGxh5+dYebCuA+GWidT101xprDzygPsseeDI3D/QTR+qWKhIi2Gpbn6BQ9nYNC4s9ndOyvLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524610; c=relaxed/simple;
	bh=uBqSiWFj2r5/nIHhkAghlzJuM0XMHyeq2G2hsAv9xYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkAmign06A71EtKt3pn2LUqdxtO1OZyNKmNuuJ/0ZAopWGNkcS4teQUpsKmnmLPkdZnFDbmjogzM5rgajdZJTVAiyDhXnlRfth55MO4sHKWiXBFEikM5NdHUk586EqFnqpO+0XywIE5c8cRWnR3jWREt/McBcKQT2aufwJHDKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMxz2xhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMxz2xhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8C9C4CEEB;
	Mon, 18 Aug 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524610;
	bh=uBqSiWFj2r5/nIHhkAghlzJuM0XMHyeq2G2hsAv9xYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMxz2xhG6V3seJFTEGxhDY6BqpSdFY6ByLUsqt2rIfExc7ktccJ/JZzOi3mLZP1X6
	 PKAxKJHOYeh4roi55wDLhnzKSQsgVFVAz2Qlu1tsLF67JemxKE00fqyHDsx4AowE4U
	 ML+RjvW0624Tcy6866C5lhBDQqICe2+Ea9ZmRh2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 001/570] io_uring: dont use int for ABI
Date: Mon, 18 Aug 2025 14:39:48 +0200
Message-ID: <20250818124505.845116922@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,7 +50,7 @@ struct io_uring_sqe {
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;	/* compatibility */
 		__u32		poll32_events;	/* word-reversed for BE */


