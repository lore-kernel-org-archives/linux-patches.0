Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268B2BDC00;
	Tue, 26 Aug 2025 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206773; cv=none; b=AwLrzzHgReGwV3aNtbusQHVqBNfLyRBdU3bqvlul9ac5kUJksGynzQgs1TKKjiIOzAhQ4HkeC8I7vfneKvLTaw+Wo70Zsk81FkM1T+Y4JW4qojbqWL2hQaAx60HHFcp2kuXpHADDwP5kAVrLURdQs0+JK807dFVuPukBGASRERA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206773; c=relaxed/simple;
	bh=QvRsfbrxLBufMfmtaWFWdYNN5UZAq3pE+WJVD79S/5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfsYyPEyooOTw17J6dWLamVFji9J9dfrjWV4FxzIWelOR4SHMA5J3RNqcarqhkxjLXn2OwEAWdzoVjcBd25jq9sIF9Z/BRw/jRZzit13UutOCq2QyiQmUQIHozxXf8dLSVsd11aZg7Sh4bUmqokED8GCwtVOWhqwH+TNQoaTfhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbTvGqW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbTvGqW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBFDC4CEF4;
	Tue, 26 Aug 2025 11:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206773;
	bh=QvRsfbrxLBufMfmtaWFWdYNN5UZAq3pE+WJVD79S/5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbTvGqW5OIWBGjH6TDaRzKk5xYzvfmc4CaPsovreMHXhE2VvaHEy6vJVk4bQVYOAD
	 NpxN9wqCWnnF61JQHaNcnHphnnM3LnT9dEpulKi51TYw8BVpK1d//G4E+OAxRfvHSr
	 cQuR+G0TAePwbkjPd8n2eVOhMBc+VErsghzZew1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 001/482] io_uring: dont use int for ABI
Date: Tue, 26 Aug 2025 13:04:14 +0200
Message-ID: <20250826110930.812183608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,7 +38,7 @@ struct io_uring_sqe {
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;	/* compatibility */
 		__u32		poll32_events;	/* word-reversed for BE */


