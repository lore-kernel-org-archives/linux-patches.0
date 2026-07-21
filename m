Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA163ED3B2;
	Tue, 21 Jul 2026 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661822; cv=none; b=DP4v4gQR+7mb0YbwXJF2pApnswkcF3C4KPh09JH18mdn2Ovk29MqZQ+lu3Xm7astYFgGRd3qzZNxr3D0gw+LfnJPmEupPcIcG11gWt75Asb96QIouN33eWbSIN/ettYQVY56SiBtTCsTrqezDBak/MPNdUeNVcrFyrJ061goDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661822; c=relaxed/simple;
	bh=kelZ8zPvQlGlMsz/WZixKk+RCukc0DJBQuTLPA1uSGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSehl+yHjrQ0MsWjR9W+KQTVEWbYNJ75g3I47Zsp6NLm/1ZrvnQZP23/Cnll92PtsTm9RD1t/4X4DM/agSjdCa13IuV7z9+8F1Go4IwHfs7sQv/1HvegzKYbrmcAfAzQIgFSD6hzTV7Oghlq3mRyIZcskN1DI/yIAf5Bpxo6Mpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7IGK0tI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7IGK0tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15AA1F000E9;
	Tue, 21 Jul 2026 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661821;
	bh=8qsKI6weYkZ1yvY3GwT0kgaqc8Nd6nu/XdeUQdSXyFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7IGK0tI+xI/7hARDH2p5psJgPGJ1Rk/9fDGKMjf43SlQ41yWOC20dJ29kg1sHYNe
	 ip0MBwY+UIhoMBiyw7yP25no0gKSEoGpzWwSFoPAHXCFddfzOchjQwhkRaD948pZDU
	 BO/0y+CzkY0zuIIXNpJGgUHSzOV0QXiQj2NKhvc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Nayyar <sidnayyar@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0184/1276] bpftool: Fix typo in struct_ops map FD generation for light skeleton
Date: Tue, 21 Jul 2026 17:10:27 +0200
Message-ID: <20260721152450.210808612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5a4d3240689ed0..a89cd4f1631272 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1347,7 +1347,7 @@ static int do_skeleton(int argc, char **argv)
 				continue;
 
 			if (use_loader)
-				printf("t\tint %s_fd;\n", ident);
+				printf("\t\tint %s_fd;\n", ident);
 			else
 				printf("\t\tstruct bpf_link *%s;\n", ident);
 		}
-- 
2.53.0



