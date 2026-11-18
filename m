Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019361;
	b=45xko3q2EgtXBC2kSAU/heBbVcgyjeLgSM0zW/KqCxr6G+NGzJwRXE5z1VUeSSatjy9+
	 GUvIXqk6U3EpVr20cPpSE0A8Wr3AJbH/Az0rFR8xji/K0+zUrLB+eV8RFwVyj5XhvGIkz
	 CWJvnjkjNpW0TXTve6p1kKYERIl6sfrNztRKt9X/93bzSpQDFZuOq9WSo/vvhpcxlb7j9
	 1+UvdX/kjbIVdue687PZNOwKPVAKhKDJ193Pitad+gGJQBL3TYpDVgTrjugXJ+y3jPw9+
	 Qj+B2Xkw5h1VvQYzzfJG5zc0+WLKta4o/WqTlTWVMFcytSlZhKzfMbOWOkkWISWkxxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=duRGFYLyxJOJ36pl5wE1z1ddSz7X0XtCm8YVvELsZd4=;
	b=qJyRZbFggb3wC0bEcJTxP5HmK8ZUVCZiTWJo5gAMnvnB4ne1JTaw3PckmVKt5l6kPfSK
	 Sw8pXnQDXA82eHxfJgNKrkimY3sw+XUbraMfif3vfcbXhAQFvqk6hjpQj775cPDCe8iA8
	 RQZSdM142Uct1uOnJMC4klZ/CffVqBG+MbIXP+blLMJepSvsBXQdm/MePM39Sij9BlS4j
	 LXWL2zOgAOIMp8r1GUMpq7I0tiWe8msAHnWIVxwRtx0rNHmpcWyIAORleZfKuNN+7hkNO
	 XzVQyPBZyO/S41h1ZbNGBz9MtihabQxeyNuUcIKVWUrW40dwsuA4rkP289UHFAaIcDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkFkdy3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3460A2603;
	Wed, 18 Nov 2026 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkFkdy3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEF21F000C4;
	Wed, 18 Nov 2026 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019360;
	bh=duRGFYLyxJOJ36pl5wE1z1ddSz7X0XtCm8YVvELsZd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkFkdy3vQnp2O+PrCIqvjq3vIaO8c0HXCAc9O+ztmP+rcgvMATlc5Zl+NLeQe1wTg
	 OInSBqxhJ3jfPkLsJ6b1wWlLVh/+pOP1p/MNpU3oCmwDPhu+7oxVOw4InSoLuxFKMF
	 ip70HVqVSzQ9Tt+8ujHv3QOtJF2Nz9QwOSdSTzvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1566/2651] selftests: ublk: dont keep the fault_inject timespec on the stack
Date: Wed, 18 Nov 2026 15:46:46 +0100
Message-ID: <20261118150344.325578615@linuxfoundation.org>
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

[ Upstream commit 955cba87d9ed334fbe0b669b35b4abcddd7f9929 ]

The fault_inject target delays each I/O with an IORING_OP_TIMEOUT, and
generic_06 relies on the delay to kill the server while an I/O is still
outstanding.

The timespec of the timeout is a local variable of
ublk_fault_inject_queue_io(). The SQE only records its address, and
io_uring reads it when the SQE is submitted, after the function has
returned. The timeout gets whatever the stack holds by then and expires
almost at once, so --delay_us has no effect, and generic_06 fails
because dd completes before the server is killed.

Store the timespec in the per-device fi_opts, and split the delay into
seconds and nanoseconds so that delays of a second or more give a valid
timespec.

fio 4k random reads for 10 s at queue depth 1 on a fault_inject device
with --delay_us 1000000:

                  before      after   expected
  I/Os            446927         10         10
  mean latency   18.3 us    1.000 s        1 s

Fixes: 81586652bb1f ("selftests: ublk: add generic_06 for covering fault inject")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261008-bug-ublk-selftest-fault-inject-delay-v1-1-a96af7ead06e@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/fault_inject.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/ublk/fault_inject.c b/tools/testing/selftests/ublk/fault_inject.c
index 150896e02ff8b..e055f51a65447 100644
--- a/tools/testing/selftests/ublk/fault_inject.c
+++ b/tools/testing/selftests/ublk/fault_inject.c
@@ -11,7 +11,7 @@
 #include "kublk.h"
 
 struct fi_opts {
-	long long delay_ns;
+	struct __kernel_timespec delay;
 	bool die_during_fetch;
 };
 
@@ -47,7 +47,8 @@ static int ublk_fault_inject_tgt_init(const struct dev_ctx *ctx,
 		return -ENOMEM;
 	}
 
-	opts->delay_ns = ctx->fault_inject.delay_us * 1000;
+	opts->delay.tv_sec = ctx->fault_inject.delay_us / 1000000;
+	opts->delay.tv_nsec = ctx->fault_inject.delay_us % 1000000 * 1000;
 	opts->die_during_fetch = ctx->fault_inject.die_during_fetch;
 	dev->private_data = opts;
 
@@ -85,12 +86,13 @@ static int ublk_fault_inject_queue_io(struct ublk_thread *t,
 	const struct ublksrv_io_desc *iod = ublk_get_iod(q, tag);
 	struct io_uring_sqe *sqe;
 	struct fi_opts *opts = q->dev->private_data;
-	struct __kernel_timespec ts = {
-		.tv_nsec = opts->delay_ns,
-	};
 
+	/*
+	 * Pass a timespec that outlives this function, since io_uring
+	 * reads it only when the SQE is submitted.
+	 */
 	ublk_io_alloc_sqes(t, &sqe, 1);
-	io_uring_prep_timeout(sqe, &ts, 1, 0);
+	io_uring_prep_timeout(sqe, &opts->delay, 1, 0);
 	sqe->user_data = build_user_data(tag, ublksrv_get_op(iod), 0, q->q_id, 1);
 
 	ublk_queued_tgt_io(t, q, tag, 1);
-- 
2.53.0



