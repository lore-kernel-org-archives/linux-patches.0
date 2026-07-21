Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B0366DA5;
	Tue, 21 Jul 2026 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648845; cv=none; b=klIx2TJAHeulA9vWmEEL3Ymm0XCngRnBZ6Bpx8/PgJSyh9D0YbIMNZ5qnOpGblbZXLtEOOBHt13ClJo8jCj5xh9300qL+r8VOpDs5MFlN8AhapkGnVdZJT7DMg8oxKDcD2H137vrK/vD8DW0mqgFzgZqEP5zOJt5iNlXziCVhOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648845; c=relaxed/simple;
	bh=qnmP+JN3P0IMJMTY7qVcVvpXi+AVsAu1SaH/ScVguHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmA09u7XEDvSXWzpSI9ICHE0g4wAKzIGLNHiKP2IJnw8Po+B4Csvjsl+6/zX+IBPZ3Plez1ziNI4LsoyKaOqMVHRHzhmjgY1L+aMOdCFYMcFgepTdcqfRLSRVYqDTCajt/+VpPQ8krVzsiUqnNXecGWNFdZ8GSLKmMDd0au0fHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/C/G2Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/C/G2Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280751F000E9;
	Tue, 21 Jul 2026 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648844;
	bh=QvYxGLiq3KscTgW4et2BYfGkn55DT/Ii86V7iwkN6EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/C/G2IxTVfJ7OJXvUqyvt09CAeAD+EFQPbIjoSupo0uTCCqmb88ls0t8Ud3crds0
	 8q0odmHiXzNc7+F/gryFYgJmv+uvXBvxmdJIlde3I1FYcijqZI92K4COB1/pYEj+0P
	 YB/PX7GOSEdMIAfxSlwnJ8a6wJWoApl5eHuOf1Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Nayyar <sidnayyar@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0352/2077] bpftool: Fix typo in struct_ops map FD generation for light skeleton
Date: Tue, 21 Jul 2026 17:00:25 +0200
Message-ID: <20260721152600.993648836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Nayyar <sidnayyar@google.com>

[ Upstream commit be4c6c7bc42952b71188894933946b410deadcfe ]

When generating light skeletons for BPF programs containing struct_ops
maps, bpftool incorrectly outputs a stray literal 't' instead of a tab
character for the map file descriptor member in the links structure.
This causes a compilation error when the generated light skeleton is
used.

Correct the format string by replacing 't' with '\t'.

Fixes: 08ac454e258e ("libbpf: Auto-attach struct_ops BPF maps in BPF skeleton")
Signed-off-by: Siddharth Nayyar <sidnayyar@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20260520-struct_ops_gen_typo_fix-v1-1-4dee3771da46@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 2f9e10752e288d..d6040b52d4e1bf 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1399,7 +1399,7 @@ static int do_skeleton(int argc, char **argv)
 				continue;
 
 			if (use_loader)
-				printf("t\tint %s_fd;\n", ident);
+				printf("\t\tint %s_fd;\n", ident);
 			else
 				printf("\t\tstruct bpf_link *%s;\n", ident);
 		}
-- 
2.53.0



