Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED151AB8FD;
	Thu,  6 Jun 2024 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683276; cv=none; b=vFeFeKsphtDCH+qVkgIuSN2+eZUt8aLiY9EstaGTHhgMHqw/3bSdSiXAJthxKns7AtSJ466ji+Lc8Bx14oEw+CYTgXBkZcORmQ3TLQ2SldRLHuajHvvQudGbKZXpafd7uXVnItf3kp2QrPs6AwRafNPaeddLeNgTtmZc8QYaJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683276; c=relaxed/simple;
	bh=rNeKb8mHDYPztJdE6f86jelnCGerQehyFKC/ZVSmHGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA20tfbSCz/wZ2Z7885HavNFRYbCVmHMHPEY8uheg7Oy3v6TL8pXHzoscorPXv4ytjIt2ersSYrMa2IPNeXG0vDiWFnLGFH0uNVWF2uMf+cumHWDxBS1/iRZioTb4Z+AYqOKi3IZKt1LZKoiF2z3JpPqNEYbEItsqYd7nbulPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHCoBJSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHCoBJSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA960C2BD10;
	Thu,  6 Jun 2024 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683275;
	bh=rNeKb8mHDYPztJdE6f86jelnCGerQehyFKC/ZVSmHGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHCoBJSj/Qa7zi478qHETveFbngRzSVZPN1IkndB+8gAslLoFloMthhHRH4EBbODa
	 VeA4YzGOiS8vCj9MQe2+syL6kLMja+a9Z0D7HnbVgnRKMVj+rfjcojyNav0IB8V2nT
	 UF38+Hlva76eNR6T6Fcm5FCO+GSNYEmGWF0TJ1wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/744] libbpf: Fix error message in attach_kprobe_multi
Date: Thu,  6 Jun 2024 15:58:10 +0200
Message-ID: <20240606131739.388825927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 7c13ef16e87ac2e44d16c0468b1191bceb06f95c ]

We just failed to retrieve pattern, so we need to print spec instead.

Fixes: ddc6b04989eb ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240502075541.1425761-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e238e6b824393..de35b9a21dad7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10985,7 +10985,7 @@ static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, stru
 
 	n = sscanf(spec, "%m[a-zA-Z0-9_.*?]", &pattern);
 	if (n < 1) {
-		pr_warn("kprobe multi pattern is invalid: %s\n", pattern);
+		pr_warn("kprobe multi pattern is invalid: %s\n", spec);
 		return -EINVAL;
 	}
 
-- 
2.43.0



