Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015171;
	b=KuCV30TBwWzd7aMT81G/jSMZOQPxxjVN0mdqCisthVNLZlGUME4dVvzbydIxSitQJVJl
	 Gj6vHkZRI7JCpr9I1qy2NazVyNdAQNad5sltW1d/dmYPrr4zFsX39SMo1dHz7ma7Q4kjh
	 unoNc/mMMgyPteI7GgtBlc/J994OXRIerHOKti6yOpVJVGtV9KR+hcZVnQsrxXCOQiJY5
	 tl7MZTZeCV+nprNaBuHTkf/suUCh1UaTsXTx/sEQoyYISp4IHf2/aEPAjGUDyNqQ/EXVX
	 WvbSkhPb4zCT995DCp3WkWS/aI3g28CIvHu2/jj9N0cCTBMRhL9jwW4TB9UHaigh9+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hHODga6wlEY5WvwhsLENrYwzX+qnXP27Y6BEisnNGMg=;
	b=tdUnQw9Olk8GFedu9qfXTFdhJIZ7Y09IeIE97759OmmSYoS1yIMBwTKFmF8WeTs/gq0X
	 23EgTAMoFSI14VCXkspDlAg6ZEFZq+epUzdA9APlJmNPnEj7nTCg14boh2as0dXdE4XU4
	 a14QkIuBbk6j+5cctEkWNrAqmt4FMhH6q8ARrBjpBcCgYsJg5WSU+6/a8L9Uq1HPgCFPU
	 MQG9mA41cNqMlptO9HEcHly4/8hPhOGk0SwHg3yb1xR2sJRC0GfKOSmjhiLIuge3ueDEI
	 aocJnJRrfmJdtTAlLI4PaRbmMncr+NWi3W04a9g7KX0IwSSnt5zkejnLouwugcaab/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIsbzr6s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F4606A334;
	Wed, 18 Nov 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GIsbzr6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF63E1F000C4;
	Wed, 18 Nov 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015171;
	bh=hHODga6wlEY5WvwhsLENrYwzX+qnXP27Y6BEisnNGMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIsbzr6siEavqY4BD9DpPpdcJ7ol42UAYgutAntz+s2k4AazqLuv42coieyDkWYbS
	 qh3lNKHQVQxTZM3+6oSiyvP7/3qnrSM7T1uqIOPDWY3N/x1vjh9FTMt1sGBjLwwhS7
	 UTfnBMYb4giuj6Kk+iF5XO63uY/o7YssUhM04sSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0071/2651] bpf: Roll back stream capacity when allocation fails
Date: Wed, 18 Nov 2026 15:21:51 +0100
Message-ID: <20261118150250.492527100@linuxfoundation.org>
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

[ Upstream commit bd2466ed8fc2ee54408bfe433e75f9f46bfa04f7 ]

bpf_stream_push_str() accounts the string length before allocating a
stream element. If the allocation fails, the length remains charged even
though no element is queued and therefore cannot be released by a reader.
Repeated failures can exhaust the stream capacity permanently until the
BPF program is freed.

Refactor bpf_stream_release_capacity() to take a length so the consume
and release sides are symmetric, and use it to roll back the charge when
creating the stream element fails.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Link: https://lore.kernel.org/r/c0ad7b18c59be6695fcc9e4e1200b2f4d5cbbea2.1787492521.git.shijianlin11@foxmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index be9ce98e94692..0b157ec4e38eb 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -68,10 +68,8 @@ static int bpf_stream_consume_capacity(struct bpf_stream *stream, int len)
 	return 0;
 }
 
-static void bpf_stream_release_capacity(struct bpf_stream *stream, struct bpf_stream_elem *elem)
+static void bpf_stream_release_capacity(struct bpf_stream *stream, int len)
 {
-	int len = elem->total_len;
-
 	atomic_sub(len, &stream->capacity);
 }
 
@@ -79,7 +77,14 @@ static int bpf_stream_push_str(struct bpf_stream *stream, const char *str, int l
 {
 	int ret = bpf_stream_consume_capacity(stream, len);
 
-	return ret ?: __bpf_stream_push_str(&stream->log, str, len);
+	if (ret)
+		return ret;
+
+	ret = __bpf_stream_push_str(&stream->log, str, len);
+	if (ret)
+		bpf_stream_release_capacity(stream, len);
+
+	return ret;
 }
 
 static struct bpf_stream *bpf_stream_get(enum bpf_stream_id stream_id, struct bpf_prog_aux *aux)
@@ -188,7 +193,7 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 		if (cont)
 			continue;
 		bpf_stream_backlog_pop(stream);
-		bpf_stream_release_capacity(stream, elem);
+		bpf_stream_release_capacity(stream, elem->total_len);
 		bpf_stream_free_elem(elem);
 	}
 
-- 
2.53.0



