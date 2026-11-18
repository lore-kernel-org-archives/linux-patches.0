Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022940;
	b=QMA1KhazNCW9ixEdYgs+WWgcDdS7rbShDm45Wx/AoQtow4Iwti1Rra3iBvODJHwI1trR
	 PXZPv+J4FmleZnQVaGc/bCPg7b7FWOHM1gKOlSbnOp6JBVgo0vbn5laK2hCpfGgIN3bzb
	 LQFs539KWGPU/YzkrUHXJcie49X6H1UEeQRpp+Rdb/TftRL6Czs9uSFC+Jb6CsJXo+jNz
	 4CZR1qXABweDw883RWzoLcYcU4uoQjksmR79Y2zYDyPKQmWj5JDAj4JwJj2iPmzT+AEo3
	 kMl1B1fngCLNbY9oFbeWeIFI+ENDOP4QsNOp30Pvc9MfVMEQA0421ziZQRBKholXm8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=whvrBsrwXw+hUi7zJ7Mi0/tpOZQlxiZ7Z/wNRaH+OCE=;
	b=2v9y+5sD/f/oII32S9IxuGKogqAYegKKqwHUfPxN2KIOLhwNF4R+XbSRWERytUI81Dzs
	 BPyDo/u39EhDTbVd7d8h020yMoWQEGEnqacP0aZeDb+yPBLrPduxSvme2BBa+pin6eAsP
	 +chsUJmv/zETEcu1s7LJJT8/hSpMvbmeeoj2+URrcgBBVnRRRsMB2vvb5uuEmOwPZVCk8
	 SwYi/0W0UPFO4LJMKmHlZLN53SoDqzvOmPX6Z5O43iX5LEcYLX8vQfZNqWBvtFW6DDG5Y
	 jVopjzFXym4NN9nfFyy+kY6KTp1WSMWGYNkQCk/ICvuRqzflwLxR68jovLsQTFLeHqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEiCPDsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A4606A77B;
	Wed, 18 Nov 2026 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEiCPDsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE1B1F000C5;
	Wed, 18 Nov 2026 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022940;
	bh=whvrBsrwXw+hUi7zJ7Mi0/tpOZQlxiZ7Z/wNRaH+OCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEiCPDsxaek4l+gobMI3cZndsKrbUJGmjo4fDDBQJu+LcoXyui/eftQSiRB/kem4T
	 iNL7BxuEAcR0Q2/vFxiWL+XGBG3RafjQv0Mv3QLP3WTxO09Klsf2Ng72oAWgIydk8X
	 3aaEEElROh5iXxN825AZg4mM1T8gxGSNrGlA8xGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0135/2151] bpf: Roll back stream capacity when allocation fails
Date: Wed, 18 Nov 2026 15:31:10 +0100
Message-ID: <20261118150126.707589040@linuxfoundation.org>
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
index ff16c631951bb..d2889e54e748b 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -208,10 +208,8 @@ static int bpf_stream_consume_capacity(struct bpf_stream *stream, int len)
 	return 0;
 }
 
-static void bpf_stream_release_capacity(struct bpf_stream *stream, struct bpf_stream_elem *elem)
+static void bpf_stream_release_capacity(struct bpf_stream *stream, int len)
 {
-	int len = elem->total_len;
-
 	atomic_sub(len, &stream->capacity);
 }
 
@@ -219,7 +217,14 @@ static int bpf_stream_push_str(struct bpf_stream *stream, const char *str, int l
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
@@ -331,7 +336,7 @@ static int bpf_stream_read(struct bpf_stream *stream, void __user *buf, int len)
 		if (cont)
 			continue;
 		bpf_stream_backlog_pop(stream);
-		bpf_stream_release_capacity(stream, elem);
+		bpf_stream_release_capacity(stream, elem->total_len);
 		bpf_stream_free_elem(elem);
 	}
 
-- 
2.53.0



