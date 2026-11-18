Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029148;
	b=D42mU/jJ9GXP3ohzoe/HgzdgQMzjqVgrBP2LFtP5kJQU72fGDfWaZDMEpsow6oSAdoxT
	 OTaUJvaAxCJRZpaJKY3ZyhPDb99SrkkiICEvf8SQ5qaPf7RfG54cFXd0JnTSvmaC/FA3z
	 f1RQkaD0xUQGjL3tfGZC2jToTNSmAicnfLVNuL5RKd5aqdixGuqGvAb3p3InyenSYa76r
	 HERCEuRLSK9x+cyDeBqXjsrO0cNYXTfrsehryk6HwkMcbKd99dIkXQZNXssAfg5BbOzEm
	 30i3rHwmG5Jhhf5Xfdn5v5MeWlJd2PmxLLlC7YNk5UTTn6M4lTDkGA3XWelGu5ZpYRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLD8pnMLxPzZQyEMnrgS5aZ57WyAkEw62dMbPcC5cT4=;
	b=uvkgBTEj3ztSA0Qbs98ZiAXvor6Qzzt0DhzwsYuBpVaA60vvg0Bi4AlwJgjWTVZsbRYI
	 vZ21cRoVxlephHhGTlo+es9YxIi2G2gHkWmzWcEcdbwPPKVN5tmnSjNmTqLAKafvZMTCx
	 0o57ygQ4mWlCGU2Y9upvyPiIVhDCMfbrwzVFz8pAQfaSS6ok3iJgN5jdXU/MsUSytsxud
	 w0AZpUZalB+Kfc5onk24SmKLdI2/HKGkVXsfHeoWgV1dUr6BTZ2tzaB0CA0f3sBHeGvmf
	 B749u3q7S5lAx62ZUSzzklQj7snkU0NzePMZa7DDTBb05rdb5St+wqWmxxRVlU/II1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqTmKPU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C096606A31C;
	Wed, 18 Nov 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqTmKPU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BA31F000C4;
	Wed, 18 Nov 2026 19:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029148;
	bh=CLD8pnMLxPzZQyEMnrgS5aZ57WyAkEw62dMbPcC5cT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqTmKPU6hBBGPGsE8aWZDJDlTo1wkoY15QUovGjQGRbiKqn04qrVZLk0TqBgXH3yX
	 ORsIVmmITk9V06eFa3aJHxKOm2yV9v493hKJgRPETE8ooosnjbWyot7t0Ug1GVF4bt
	 D8ZA/DlQZp+Nj3VRiBbuDahFMNterhaENkxYfXS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0246/1756] perf trace: Fix error checking in btf_struct_scnprintf()
Date: Wed, 18 Nov 2026 15:39:33 +0100
Message-ID: <20261118150018.185454434@linuxfoundation.org>
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

[ Upstream commit 02241f791aa28802cc05223a740e163e14cd5ea2 ]

btf_dump__dump_type_data() returns the positive number of bytes dumped on
success, or a negative error code (e.g., -EINVAL) on failure.

Currently, btf_struct_scnprintf() checks if btf_dump__dump_type_data()
returns 0. When a negative error code is returned on failure, this check
evaluates to false, causing the function to proceed down the success path
and advance arg->augmented.args past the unprinted struct data before
returning 0.

Consequently, when syscall__scnprintf_args() falls back to the default
argument beautifier upon receiving 0 from trace__btf_scnprintf(), the
fallback beautifier or subsequent arguments read from an erroneously
advanced augmented arguments buffer.

Fix this by checking for '<= 0' ensuring that on any failure or 0-byte
dump, 0 is returned without modifying the augmented arguments pointer.

Fixes: cb32035214b9a09d ("perf trace: Pretty print struct data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
[ Restored that call to be a single line ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0af5254df4720..385686a93ab8f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1044,7 +1044,7 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		return 0;
 
 	/* pretty print the struct data here */
-	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) == 0)
+	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0)
 		return 0;
 
 	consumed = sizeof(*augmented_arg) + augmented_arg->size;
-- 
2.53.0



