Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022926;
	b=18DzspNu3isZxTMope3mUWDH89aL3rJTSx7QIPI5Da/81vjHAvFjO5xzU5rpxwUqCAwu
	 UrYFOmF0upLOWUGigoCSsrbpd5WFbKWRyHQGCAYkMx64oD/HqHjzx+5x8x3eTuSjYNpSR
	 IcrVNk8yKW5qAufd6mSEPagw37trlxaFA7yx1Y2Q8S4kqDvU7U6FnUMqkEwKVOy3/XIni
	 NMTJilwGKrb+pZKcx5UFbukA2xi5Qx7PrixFHgtji+LtWiqfAnsqAhbifLowbXLi9cr9C
	 FU2Bsxl65NuQeGS66IscE6GP9r8ZWhafueFYWP9hVVRj2xz6mEX3eNBcPYe3HDAl1fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9pTGWHLGxxpc+/HmUYK4W5xaYkxbu+NTsv5E1yQNvg=;
	b=wI6AERMwLmQ2GgjnFOqKq4YR/gaKKrJZylCtT0jAR1mJcmmzrDxNOCmt+ARw9k+cEKs4
	 nyWm61F/muJOZUWYqBFcbU6f+5MMcymckv+W5PTRZlmGfSeI+Q3t6uN/mcV5q2EouiQ8V
	 E/+loUqqoy1yumB+pGJFwl7n0Vd6k5jtlmhyazULVUW/VcAH/Nnlb1WPnsVw3mDocFNJ4
	 N+4Um5e8eqRvSMabiH9fftEi1WS46jOgSFS5f3J0BgTMtGg2PiJsGvsWLGCGwg1HdOqpC
	 qvg11AQhzt0vm/ePYfCal8FQDZT9qtMG4eNDE6YCkRryvPCD5kV/lZfx6o8Jazrtp1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBFaA2q0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866C0606A325;
	Wed, 18 Nov 2026 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBFaA2q0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A391F000C4;
	Wed, 18 Nov 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022926;
	bh=L9pTGWHLGxxpc+/HmUYK4W5xaYkxbu+NTsv5E1yQNvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBFaA2q0AtwgbJmbY18QPGo7ESY1lbuUg5/98hAlfEICNII5Mu5nM3hyvHk+CHABD
	 ASY3Mpa2nRA1eSYswi1Xvl2qVYWy/vzgTD2XIQjGHwCibCH/PoivJ63ztwgPbxlJ+c
	 iV9CgtlyGcmQu6LO54udHGSAPDX+BQ72OrAFG0gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0140/2151] bpf: Reject oversized stream read buffers
Date: Wed, 18 Nov 2026 15:31:15 +0100
Message-ID: <20261118150126.884022329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ea0b60fae724aa1147d4a07eda5131d3a9a9977e ]

BPF_PROG_STREAM_READ_BY_FD exposes stream_buf_len as a u32, but the
internal stream reader accepts an int. Values above INT_MAX therefore
become negative before bpf_stream_read(), producing negative consumption
lengths. The generic usercopy size check prevents the oversized copy, but
emits a warning and reports EFAULT for an unchecked argument.

Change bpf_prog_stream_read() to accept u32 and reject values that the
signed reader cannot represent.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260823193202.2389715-2-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 2 +-
 kernel/bpf/stream.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d018a74a882d0..d551905c8aae9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3712,7 +3712,7 @@ void bpf_put_buffers(void);
 
 void bpf_prog_stream_init(struct bpf_prog *prog);
 void bpf_prog_stream_free(struct bpf_prog *prog);
-int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, int len);
+int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, u32 len);
 void bpf_stream_stage_init(struct bpf_stream_stage *ss);
 void bpf_stream_stage_free(struct bpf_stream_stage *ss);
 __printf(2, 3)
diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 9a65fd2c918c1..31ee75cba52df 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -346,13 +346,15 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 	return ret ? ret : len - rem_len;
 }
 
-int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, int len)
+int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, u32 len)
 {
 	struct bpf_stream *stream;
 
 	stream = bpf_stream_get(stream_id, prog->aux);
 	if (!stream)
 		return -ENOENT;
+	if (len > INT_MAX)
+		return -EINVAL;
 	return bpf_stream_read(stream, buf, len);
 }
 
-- 
2.53.0



