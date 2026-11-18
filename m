Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015764;
	b=iOhK+679eKS9Zs/ekm/L67/SMiG/3BT9By7dZmwhQypZF8Tg5l4ixetavJBgYdZAUQld
	 2uaw22itrQz0ENrY77G2G8TkkXnDarMBXuZGddCe0J42JAPd4Wf0LIO+gx95lfkkS92f+
	 QuivurhgsBqYJEMy2pilmfRzFjdGpXrQ9VaQ31gDQMoDCClp+7zZ9Vb/LT1KuF9vKMl2n
	 7O19/EDc/ZstIaarKfSFQFx730c1xA99aXh4zKlL5vcsbvsav3oIaxr/qV2zRlqitkOWX
	 +hZIiG2D7su+EGiKtEwZRKp6Tpy6e3USvGrbui0RrGCEZafJ7fZLrZVz6G6UYjr8XGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+C6rdTVYu6F3hVbnXQUcQgCYv6B+x2h8HKX8u3rzTA=;
	b=AWcCsG2x8U+EzstuvbLeM8S95OxxiXzw2I3DnxJU+rrGlnEA8dZPOvjRzz2bNyAvVGNH
	 ebVXol6xOpJVMIy5xYIOr3oUL8C+A3CU9iK65A66ZUjqcoqKKiJufLc9J2TNSs/alM4yv
	 3LTwplhTYMcSjucfKJeO3HHNrSwn9faAOyGrfcrI7bdOeD9ytnFBQaBQphSkOlHhGM4Ia
	 7sj9Au+Y1ek9BIAdmfgkV5nId8Mrl3YhVPQSrb4PqKOOruvybDyXmO5znW6IT5078ZLQW
	 jPLWGMnk0uaNdrbHYITirNC+IS5gKmGO7YwlAKXSnEISLGh+p5o+79NBRhazoVCt7Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYRMyZjF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0C606A31C;
	Wed, 18 Nov 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYRMyZjF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE381F000C4;
	Wed, 18 Nov 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015763;
	bh=r+C6rdTVYu6F3hVbnXQUcQgCYv6B+x2h8HKX8u3rzTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYRMyZjFKPqURr8N56toCepUQmJ8GyachR0aMW8odvQwS3sGDLcjdj5iB1bCEI+bl
	 cCXcU87z7SJ+j5ziaskidF+H4MWRTte+EI/3w7hT/qMb7TxvWcy2BqAQmGshC9pC+O
	 mUzb05eMb/L/wx97iD9a8o/7yRjRQxGcge6wOYF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0287/2651] perf trace: Add upper bound checks for augmented BTF struct printing
Date: Wed, 18 Nov 2026 15:25:27 +0100
Message-ID: <20261118150258.240150490@linuxfoundation.org>
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
index 66d931688aa3d..45b1e58c4b8e7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1104,12 +1104,13 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
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



