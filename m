Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27080470455;
	Tue, 21 Jul 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656090; cv=none; b=Vn30KD8LyPFuyDRIrTUJT95NWBLC9WD6tI8aoSrBtedgfMGmIMQyqQxfxU8Mr8ktBFxZONUZDw/GPVSjYILtRIoF4EfzumwDy+VE3EObSsFOZdSkdNJts4pZQscNiAjFKgweD7NKWByWjYuu/Oe9UjKABI09/MxzyoKEcFZiFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656090; c=relaxed/simple;
	bh=hV+LVaxCTN4/k3nKmrNy5/20aL8CPMK1MPSk3LJtQbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLAHmyXDtV8Wy55vwjRCKUdOptbcLXO+no3paN3p9ewfcpBJ4c1DFOCrUcHlsMQptCqEqlUZfxThk/Px8im5AzMj7vochTZAeVLAXSKuf0MF4tpybxXVcDPcK2oUc0P5o1gEkyu2BYJo2EsMbTXuA4s/OgsLXRhRfW+y/G+TKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lc6Ahdjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lc6Ahdjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C561F000E9;
	Tue, 21 Jul 2026 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656086;
	bh=kCPJNovyGGfI3BHORYinyZlyojWn8av2BT3dbUX4oS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lc6AhdjpriJtxZ2X6huqYykhvjSkT/XpzyKbEN3apDdU/oHWjVLBadj5qxQHyq37E
	 1Sa37CfdeEIsyL48QIaVPuUWAbffd0IPDMeITvmGEqTARjiJfBmp5dWFtmpYA4OePd
	 zsLF0MmGcBSvQpDJMowmaWZmA8KXzu5MrXxfdB5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Nayyar <sidnayyar@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0254/1611] bpftool: Fix typo in struct_ops map FD generation for light skeleton
Date: Tue, 21 Jul 2026 17:06:10 +0200
Message-ID: <20260721152520.754680771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 993c7d9484a463..bdef69c5e6cd44 100644
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



