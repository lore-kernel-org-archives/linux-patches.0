Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015289;
	b=LICXUDcwr9chfA/JUu8XY4OIDPulFNHipwZJVdnPGAZ3Qb3UA1SQUGYTxgtzN+DsN6iV
	 7trhM09/FXtSoEKIepyCRFJ9IR188Nml/R0zm8WuUrxNth2kgTToAoHb1iGH7DPIpX9km
	 vaMXrnl3Y3bfdwsQVB42KonqI+6XSYUzB89+L/UxHr6gWO/OLjaIwTqU138476uNMZ9Lh
	 jdHzKlaEJPaQNdPWkjPFAXJ9qH18NwToDxRP/yE4QJ8h45gmAuGqwEZa+CiBGFXkGdXWv
	 7JnYJDqkDEU+C3MEpNNfWaNv217BTHZLhkjeqOZRx947u9+FFKj7lslLz2RbqBjS+Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MARNObM9UxBJ09ZtGWnHj0miOHoFwZS7hwuLioOBGz0=;
	b=IdjSY0ySwPcbMg2jd9fz+5OuKIO+eVo2IocXqoZ7BU0QSNlqM0HG6TmJnm4UTk3vVH8G
	 DFK3X4HYV0BV4/ojmxPmBKWY6dB0WowKW3JqUlM9XDPq6LE2QRLifmvLWbOEzuEH3OoMd
	 IIMUCF0zsvdtbw8BUXDAGi+l+eAbXwTYdaebla86EQx7ux9xeNIk+Ldbw0Z2w/ZzXMF9w
	 H34LixMUuWP5cTzUddq+1n58f8sY9KXeodI5F2eGBf/NQ6EIlDmbsvnGzDWsCoQynDCoG
	 LJbesH8h5j09k4Emimw8+WH8u1HsoN6aN5tIRuSbN9foVSXJE+iQZiTQUe37N774gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2bjLfPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B426606A325;
	Wed, 18 Nov 2026 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2bjLfPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D181F000C4;
	Wed, 18 Nov 2026 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015289;
	bh=MARNObM9UxBJ09ZtGWnHj0miOHoFwZS7hwuLioOBGz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2bjLfPtaco4CYhWd49/yK+GoRVQXZK5X80Rjcadkte9L4sWVdKTAmx/StcjTle+g
	 8M+VYJHGlf5SuGAwBvuozbxgnBNm/0NGc6Lt8sY99dx1bxhQTGq5bMy/PejO/pL7Iz
	 U129S0MgQstZv3I2Y3vTMJsueR4D4gnk4T5yG1rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0078/2651] bpf: Reject oversized stream read buffers
Date: Wed, 18 Nov 2026 15:21:58 +0100
Message-ID: <20261118150250.733799671@linuxfoundation.org>
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
index 0ecb9418dfbd6..5ca24186c6503 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -4140,7 +4140,7 @@ void bpf_put_buffers(void);
 
 void bpf_prog_stream_init(struct bpf_prog *prog);
 void bpf_prog_stream_free(struct bpf_prog *prog);
-int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, int len);
+int bpf_prog_stream_read(struct bpf_prog *prog, enum bpf_stream_id stream_id, void __user *buf, u32 len);
 void bpf_stream_stage_init(struct bpf_stream_stage *ss);
 void bpf_stream_stage_free(struct bpf_stream_stage *ss);
 __printf(2, 3)
diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 7a5c3ac8676b9..2b80a0599865e 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -203,13 +203,15 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
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



