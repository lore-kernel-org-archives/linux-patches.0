Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015262;
	b=t/CAdKEuXSIdKDRkfXvz5YdZhM+2nOst9Qw9IcLY5iI/o1NID0bjf8fRKeql5dXPB+9J
	 ndGauTHxhgtDfoYTdtWxI+PzY7yEzbsDPQ/8GorN4xT4hOEWb/hhMmLY6gBpavgoNSCmZ
	 xz8lh5d9WNfkVPlyBRkoLiGyJH37vuMDZvkktjKM/YEN7VzIiyONrNOAM4pufO+J5w6tF
	 ftuRuOBxggCk/lVX6V5chQhvOcZmnrR360XR2GoENWsOrsQNClEeerZfdvvMrzlqCSy4c
	 5re8mzNZP6cuKZSqZrF0RvrkLIXXNPCOlT8AVGA+QG7lkbnG1fTAAOqkJHlRDZ9NX0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWJ8yXqky8aoWKgbcN+o393JJ/JA5tBNwFPkdfAJdJQ=;
	b=Wb851VRfY9tuNDJMelHtFE/kkktqTU8jMbZxxct/wegMJdtB970N1/S9hQP8qftv8CY0
	 dhatgTXej73HIxXybQ61csRTwtjSzbOvZvkKEAn2+FxSwvrsHKYQ9O5jVfzCzzRUeB6JL
	 dWsUDavmXdsbzSLmTreWp3tS0zThG/Maf7lEwxrQLKMFKn0nH0gtkAemNTaYJvwtqalCJ
	 4PC/JH/ccLD0vLTAXZQE4zaeKZFU4RGoZmBUBNYQXYNo0K8sjf2tMdK/ssSxB1q9gyY01
	 1lwaBTF6QmPjtQmCUu+WpfSKcqC0QnPEh1a+d2+9sIOYcdAzUUJ+1pIX44u7Ven/8kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WObcdU4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1357606A325;
	Wed, 18 Nov 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WObcdU4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8CA1F000C4;
	Wed, 18 Nov 2026 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015262;
	bh=qWJ8yXqky8aoWKgbcN+o393JJ/JA5tBNwFPkdfAJdJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WObcdU4Rlildk5AYAu3Nf/gbNxDhYc5nz2zVzAzL66xuVYajLw0Fj7H1WkFZNQnRa
	 Cq0EigsC/WwW+EZJXQyeoUhZIdDNyppTK4raAV3C/MQdd6ABofvvW/Wt9JJy3p78E+
	 7dT5baQjfIlgCed/u2yRBMt3p3ptsTTyOuMqJjS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0074/2651] bpf: Reject oversized bpf_stream_vprintk output with -E2BIG
Date: Wed, 18 Nov 2026 15:21:54 +0100
Message-ID: <20261118150250.596373926@linuxfoundation.org>
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

From: Jianlin Shi <shijianlin11@foxmail.com>

[ Upstream commit 41c0348f6e65c26df4866d5dc96c57b1995fe36c ]

bstr_printf() returns the would-be length excluding the trailing NUL.
When that value is >= MAX_BPRINTF_BUF the message was truncated, but
bpf_stream_push_str() still tried to allocate with the inflated length
and failed with -ENOMEM. The boundary case of exactly MAX_BPRINTF_BUF
could also copy the trailing NUL into the stream element.

Reject such lengths with -E2BIG before charging stream capacity, and
tighten bpf_stream_elem_alloc() to accept only payloads strictly shorter
than the bprintf buffer.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Link: https://lore.kernel.org/r/74387ae5024d7e2996095e97211430285095b525.1787492521.git.shijianlin11@foxmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 09471a6052682..7a5c3ac8676b9 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -22,11 +22,11 @@ static struct bpf_stream_elem *bpf_stream_elem_alloc(int len)
 	size_t alloc_size;
 
 	/*
-	 * Length denotes the amount of data to be written as part of stream element,
-	 * thus includes '\0' byte. We're capped by how much bpf_bprintf_buffers can
-	 * accomodate, therefore deny allocations that won't fit into them.
+	 * Length is the payload pushed into the stream, excluding the
+	 * trailing NUL of the bprintf buffer. Reject anything that cannot
+	 * fit without copying that NUL into the stream element.
 	 */
-	if (len < 0 || len > max_len)
+	if (len < 0 || len >= max_len)
 		return NULL;
 
 	alloc_size = offsetof(struct bpf_stream_elem, str[len]);
@@ -245,6 +245,11 @@ __bpf_kfunc int bpf_stream_vprintk(int stream_id, const char *fmt__str, const vo
 		return ret;
 
 	ret = bstr_printf(data.buf, MAX_BPRINTF_BUF, fmt__str, data.bin_args);
+	/* Truncation: reject before capacity charge (not -ENOMEM). */
+	if (ret >= MAX_BPRINTF_BUF) {
+		bpf_bprintf_cleanup(&data);
+		return -E2BIG;
+	}
 	/* Exclude NULL byte during push. */
 	ret = bpf_stream_push_str(stream, data.buf, ret);
 	bpf_bprintf_cleanup(&data);
-- 
2.53.0



