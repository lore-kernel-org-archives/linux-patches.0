Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029046;
	b=fH35iZlmUO7Lz0oQgDk7oinf9a3+OdhD1xdI0epEBopElx3NNpxqUX5uxI+6z5GDCltz
	 3Uc+PCfe1rr0HXuqCEdfd2LajVJi7IKGDzjwQlTOD6Qwf4PiSRPAFoBmHqSViWP76UyZW
	 6RBm4Ec+243PwPSaw/nwKGaoJpOjRg6nx6+D7z9be6TQqUI5ktLVDVxPyrJo0u7TpuSRa
	 tblFfFs20ooeEw/AHcRZY6lBUKleyafo/TY7OV7vsr4CEsrULhXUgKv8B+qNhlwtqYsSp
	 Eu73Zhy4NL8/nCHfJfrWeAWGlsjbC8KcNZOmNO6/JCBC80eM6AYQYPn0OA6OgBZpjng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GlGMzkj8PHWeGYMKfh0lTXhCWa2KZjRBIrXEh9axcHA=;
	b=xSE1xR/AkD/0IoQxP/ngsyjH3t49QDCRs8Dwak38WShDIt1BIrRkCdnllHUE8O5zdxJ7
	 QDDtNhVtXzl7rPvxoVJhCD0QddsAbzTw6uOKyWWEhgE7YtJaUyI9pzG4SKezyDS2JFPhg
	 l6aWLytmSbWfiuBGJBQ6My4JsJ+CVn2iaw19rXBgvILu4M105KyPc2QeMRIoRjaq4cIM2
	 uB8rWH8lhTh0EBRq4lgSh3buQLIuLfe7XTBgPgmkGAhNlJvkIpDzbps2B9zaK1ONCODOD
	 2uf93KJ385MHu9tRPlRdwLX/2vZe6NN4mBlrX/ab+iR7GJq8fraiBMolMSIYEhzxXaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX9ookZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93211606A325;
	Wed, 18 Nov 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX9ookZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CE01F000C4;
	Wed, 18 Nov 2026 19:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029046;
	bh=GlGMzkj8PHWeGYMKfh0lTXhCWa2KZjRBIrXEh9axcHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX9ookZfU8fRvPSDP5hAwKj3D1mH+Dt1yHOL9uDXrDV/XuHJBfKgkv5jXT36Sqhkm
	 G4gushRuoHyIjqCu3jKjAh6qWJPXe/NqZ8nVYI+7FT74h9i3CW2iSSgWv4eJTuhkc2
	 Ebv/TMvEFzQAFdzjO3t5EuWcKUUbiDDqFXgCbEEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0164/1756] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118150014.760599129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 06c7cf7a072fcd52e68471628c56630d2bdcc650 ]

jit_repipe_code_load() reads code_size from the jitdump record and uses
it to compute a pointer to the code blob:

  code = (unsigned long)jr + jr->load.p.total_size - csize;

An oversized code_size underflows the pointer arithmetic, causing OOB
reads into earlier heap memory.  Validate that code_size fits within the
record (total_size - sizeof(jr->load)) before the pointer computation.

code_size is uint64_t but csize is int; values above INT_MAX wrap
negative when narrowed into csize, which defeats the bounds check and
sends the code pointer past the end of the record.  Reject those too.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index d6583cc32d635..de7dd4db33db8 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <inttypes.h>
+#include <limits.h>
 #include <byteswap.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -450,6 +451,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	csize = jr->load.code_size;
 	usize = jd->unwinding_mapped_size;
 	addr  = jr->load.code_addr;
+
+	/* code blob lives at the end of the record, validate it fits */
+	if (jr->load.p.total_size < sizeof(jr->load) ||
+	    jr->load.code_size > jr->load.p.total_size - sizeof(jr->load) ||
+	    jr->load.code_size > INT_MAX) {
+		pr_warning("jitdump: invalid code_size %" PRIu64 " (total_size=%u) in code_load record\n",
+			   (uint64_t)jr->load.code_size, jr->load.p.total_size);
+		return -1;
+	}
+
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
 	count = jr->load.code_index;
-- 
2.53.0



