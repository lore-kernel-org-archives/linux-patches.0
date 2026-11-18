Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019363;
	b=K5bAERJCJOYrfSU6rY251sVLhiJpwoLAwEYEiXir/H1aMC+M8Z/2YYKPJgxnB86j35xc
	 vwMpoF/XjcW6RorqGgTZHWpRJMDptooe0Di7cM2mGm4oR5CVNHW5qJ4QLWtNJOQ8qmrb4
	 O1ACuSDeyAhKy1Ci2lHb2iA49pLuDbdb4FVh8cKZc8yu7sAkfOfIJDcNJdd8apAHZ/3ue
	 Xl/ElGgWSXRsFiWUOxzpX9msC4Jh17au0WXeu9CCAmRUwibVTH12wXtdB0lbJMF9U2I4H
	 akjqgE+OACjeowFJlDJ9OY5sTYxqFdoUcTu9tORBkIJh+xQm9gB6ELo1SqpC8s8bJ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1kb8cbDFVoChwllYPEweSiKdjff542TPhdhvObtFyi8=;
	b=SPgLgAQhe4OAzWbJeWL71o9m+LW02pwrbJK+745mqTG/oXdDqSnOcHnvkT1nlbjOlVUV
	 8KJd0dKLc+SjNZE+bm8F9iwZCHR7kBAcIoZJdWGE4nWNYqpSmJN7FVNqHqvcCIKlCztJC
	 AGdkGvUGXPna978cUddm/vVqj1Sq1MUDLJFPvFQO2xO6l9rdBXmXdK5Cp6XBbMfQnZkZ/
	 cpDfKVaFm+WYjEJZBtXVMxwp3PWYHb5i7vDd1riDBMvz8JH8kjj/KGjsFCSNttaNmeXQ/
	 qSqVd6hwe2c+6n6LBaxkKfUjOcnPxeL4w6KEmb5ssMMSq+0XH3oSb0yNZqCcLfpDIxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvC8nFF5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B6F606A33A;
	Wed, 18 Nov 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvC8nFF5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98C81F000C4;
	Wed, 18 Nov 2026 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019363;
	bh=1kb8cbDFVoChwllYPEweSiKdjff542TPhdhvObtFyi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvC8nFF5Jg1iOE0+CJACB42zkAPTGtFlxiEPVsYhs47bIs3uDQWYjBXe1D6+otlo4
	 axg2l5MHiRZu7YPIUxe798ceOlq5YJbmAjRYmEwFHvvTKuIJYw2BL4zEgXKHb1U1Sl
	 cJWxajTQaJy965QbfIxfz5BoNwdEbRe8db25C3es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1567/2651] selftests: ublk: make the fault_inject delay a pure timeout
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150344.359356678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 69ae59173a5668d015ab2733c8628ed542f00ccc ]

ublk_fault_inject_queue_io() queues the delay of each I/O as an
IORING_OP_TIMEOUT with a completion count of 1. Such a timeout also
completes as soon as any other CQE is posted on the ring.

With more than one I/O in flight, the completion of one I/O ends the
delay of the others, and ublk_fault_inject_tgt_io_done() reports every
early completion as "unexpected cqe res 0".

Pass a count of 0 so that only the expiry of the timer completes the
timeout.

fio 4k random reads for 10 s at queue depth 4 on a fault_inject device
with --delay_us 1000000:

                            before      after   expected
  I/Os                     2263170         40         40
  mean latency             16.3 us    1.000 s        1 s
  "unexpected cqe res 0"   2263169          0          0

Fixes: 81586652bb1f ("selftests: ublk: add generic_06 for covering fault inject")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261008-bug-ublk-selftest-fault-inject-delay-v1-2-a96af7ead06e@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/fault_inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ublk/fault_inject.c b/tools/testing/selftests/ublk/fault_inject.c
index e055f51a65447..4b59f17a918c0 100644
--- a/tools/testing/selftests/ublk/fault_inject.c
+++ b/tools/testing/selftests/ublk/fault_inject.c
@@ -92,7 +92,7 @@ static int ublk_fault_inject_queue_io(struct ublk_thread *t,
 	 * reads it only when the SQE is submitted.
 	 */
 	ublk_io_alloc_sqes(t, &sqe, 1);
-	io_uring_prep_timeout(sqe, &opts->delay, 1, 0);
+	io_uring_prep_timeout(sqe, &opts->delay, 0, 0);
 	sqe->user_data = build_user_data(tag, ublksrv_get_op(iod), 0, q->q_id, 1);
 
 	ublk_queued_tgt_io(t, q, tag, 1);
-- 
2.53.0



