Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7383F356903;
	Tue, 26 Aug 2025 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218928; cv=none; b=ZKlLBmtOMZ8hM+EpT+ydwTwUpY7kqIJbdeN/A4iU16NMTdom6zFNj4DzYNDM8Uah7QQFb4xBX8YWt5fcgB+Ak9Vz8vLcmi/yse4yD4givvaGBzh8xPHlfl3S92w2cB7I7ZdvS9/HTjY3YT0KbFCOoUnSh/0qU8fMCiXBNvgYueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218928; c=relaxed/simple;
	bh=vFQco0Odyp+mSaY2JPROgwOH/Ycp3KywUVz/RTdp1ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEZxR0FJ+bxpAtybWrGF0h8LldoeG2kM9XE/JFVaAHexnAIrVQ8FZuthM4sc3k5IRbXfeqvRKC7Om1AtgXEI0n9wZWNeDkYuAb0FRo8RrB0gxrc4W+XQf9ytQBO6NHFp74pmEVdWrMtBx1H1TL57WUFOchY2k5eGRKaEPTgTtvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFdfDuPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFdfDuPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F381DC4CEF1;
	Tue, 26 Aug 2025 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218928;
	bh=vFQco0Odyp+mSaY2JPROgwOH/Ycp3KywUVz/RTdp1ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFdfDuPR9jqhLbDusdcDn4naDRHQnV/PQsoAdSZJfA2F7OkxF9TbUG5mp3EoGpO77
	 Jgg+QDMVmmrAaKUIYBT2COOv+vY1E2NJ+FG3C86ncgtSdc3ThblxaSJfHkUWxRlQ+g
	 +v6yjrVR/Lc1Iyr46l61cbd9zlDSpA6h7gaL+2Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 156/403] io_uring: dont use int for ABI
Date: Tue, 26 Aug 2025 13:08:02 +0200
Message-ID: <20250826110911.191200850@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -23,7 +23,7 @@ struct io_uring_sqe {
 	__u64	addr;		/* pointer to buffer or iovecs */
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;
 		__u32		sync_range_flags;


