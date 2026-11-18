Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029316;
	b=rR0WRH0BfkuFmbFCb2ftu8MqKpIpqK4s4pPC5p7emq7AbbWe1uvzjBjjf4kzTQUBc+ju
	 Bpomp1ru0wT+QKYgKV7i5jkDhNZkTguinZ8GuWxp98n6UUdhr1G/OiSQuSHF3RgMemVoU
	 tErDgbOhi/WGTkKpALo391I9Gj1JjkJFNx8GKoKLCJm+7rBpltI1i++/DANeY3LyqCayH
	 OrKDnuXZBsaYwTC5EGfLoL1j1QK37n+ylEWZNBnPxscy9WW+hkRQFs0Pj7yaMLMFpyDGs
	 Fwub4864L+onUqrPQCcaGbxC7ddHQudIrWP1XfM+ACPhlpLFVuozWHtnR+muGnzdLrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3/gddXTHWhSIDGtbY4ysEFrtyZTIhRbvxadROP6j6iA=;
	b=cWds3970F73/kuUj9s2u24Pfi9OBxUB/gn+Q5cKymZUHwqMjQvzGz/Xya965fHBAWK1l
	 sobN2ARhVeVZSPQFI4FBUySeZB20wHE52Hs1sNVJfdyL+bzgl3pd5pRGiTZX/OjaKoIg3
	 xWLy0kL1v9/DMvADkoTLjLAwc3BPp6GrxMus1eyI0tv+6KiyLXI4/C2d1uCQjLVudY4PI
	 qfdKo4YyBnR9Lcy9r46vv/QFbUQTCHR2Yq+yUOBd+gYgyp7q2oa+PeLWWw68m5tfurPMO
	 4hoA/NKKVKqalNPotrYfPS1PMDl/Fe3MjtjDOB/e6OU5v+gdxBZHa+PMTHjzO9mc4Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHWJyfyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429C60A2603;
	Wed, 18 Nov 2026 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHWJyfyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DFF1F000C9;
	Wed, 18 Nov 2026 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029316;
	bh=3/gddXTHWhSIDGtbY4ysEFrtyZTIhRbvxadROP6j6iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHWJyfykeJT6EARmKCrlZh2tF5BKqihTEpC1Te+xirEGjOFc7tSUp5KJekunJbhYh
	 PUpUDcWJpvJBVqUwRefUW9CwhGN3rLD7k5D0xaxnXH0ScHwZH7sR5ws4vLy7UaRXXO
	 oIIhDsK2FsY4z2mTC7htZ8VQn/xspWVw4JDdSz/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0270/1756] perf trace: Add upper bound checks for augmented BTF struct printing
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150019.158487225@linuxfoundation.org>
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

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 024b219744a949419b3c9e8aa23031c04428d9d6 ]

When pretty-printing augmented struct payloads using BTF via
btf_struct_scnprintf(), augmented_arg->size is currently only validated
against values <= 0.

However, several edge cases can result in size mismatches or buffer
over-reads:
    1.  If arg->augmented.size is smaller than sizeof(*augmented_arg),
        dereferencing augmented_arg->size reads past the available
        buffer.

    2.  If augmented_arg->size exceeds arg->augmented.size -
        sizeof(*augmented_arg), calculating consumed =
        sizeof(*augmented_arg) + augmented_arg->size can overflow signed
        integer limits (e.g., with crafted INT_MAX values in an
        untrusted perf.data file) or cause arg->augmented.size to
        underflow. This advances arg->augmented.args out of bounds,
        corrupting the parsing state for subsequent arguments in
        multi-argument syscalls.

    3.  If the captured payload is truncated (e.g., short reads in BPF,
        or during cross-architecture analysis such as replaying a 32-bit
        perf.data on a 64-bit host where host BTF type->size exceeds the
        32-bit target payload), passing type->size to
        btf_dump__dump_type_data() causes libbpf to read past the end of
        the payload buffer.

Enforce an upper bound on augmented_arg->size against the remaining
buffer (arg->augmented.size - sizeof(*augmented_arg)) and verify that the
captured payload contains at least type->size bytes before passing it to
btf_dump__dump_type_data().

Fixes: cb32035214b9a09d ("perf trace: Pretty print struct data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d701836f62819..d3bd36e12080b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1082,12 +1082,13 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 	LIBBPF_OPTS(btf_dump_opts, dump_opts);
 	LIBBPF_OPTS(btf_dump_type_data_opts, dump_data_opts);
 
-	if (arg == NULL || arg->augmented.args == NULL || arg->augmented.size <= 0 ||
+	if (arg == NULL || arg->augmented.args == NULL || arg->augmented.size < (int)sizeof(*augmented_arg) ||
 	    arg->fmt == NULL || !arg->fmt->from_user)
 		return 0;
 
 	augmented_arg = arg->augmented.args;
-	if (augmented_arg->size <= 0)
+	if (augmented_arg->size <= 0 || augmented_arg->size > arg->augmented.size - (int)sizeof(*augmented_arg) ||
+	    (size_t)augmented_arg->size < type->size)
 		return 0;
 
 	dump_data_opts.compact	  = true;
-- 
2.53.0



