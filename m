Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463E72DECDF;
	Tue, 21 Jul 2026 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658121; cv=none; b=kJOmnjVvm9ECBXh68My3OwLdZ1Ds9E2A3dTd6mOAd+VvzbLQVTCKUg66PTQ49h/GocUsxoOLsto0K7Ug443DmhPHLIpwB9MGZGESwHhj2bGkxn1EK7HK3dHQ3tfqg5PUyS2d6iRCySZ8YvpndSMWxkaR/mOc7vZB51/j+nnU8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658121; c=relaxed/simple;
	bh=8sTG4lTijNqt2qjtiEdr+/68bRBPFHhhDWUutzRR4g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9W6PZoRq1wsMwJCRHdgqMJoByTZrwfgEzA1qFV/YfaIvDS6Qf7g21k7H2O1WmrarQslPRSMVaflmlKQZ9NxX6fnwUTI0BdwOjTtbdfISlDbe8u+XVt7qCZG0l9gMky9RX2BVKc5rHnBRGGUumz9U0Nn7a/9x+sOKOL65YAXBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDTOAOLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDTOAOLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEC91F00A3F;
	Tue, 21 Jul 2026 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658119;
	bh=kE6aI5gCnBp4F37aMy/Hz6yuUSzmbUqIhclzon+VRp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDTOAOLlT6e3328h4Sxai/RDIjqfvrtARhapPNxwDB0axooakKZmPCzSoSVKF8CKB
	 eyIefR+o2tFEpjWznmJiRSOTOU9M6yHUJJfLr13DLyJAekn2ae49mzr04u2p7yLp8b
	 mR7i7emQC4MzzJQIpOuoEBJ2k/dvp31zrxsFPXGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0980/1611] tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg
Date: Tue, 21 Jul 2026 17:18:16 +0200
Message-ID: <20260721152537.434153675@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 251a8fe1b9aedccd298b77bc28426d564c5a923f ]

Sashiko found that user can cause this WARN_ON_ONCE() easily
with adding a kprobe event based on a raw address with BTF
parameter.

Since this is not an unexpected condition, remove the
WARN_ON_ONCE().

Link: https://lore.kernel.org/all/178177265367.2059927.13789953014706792126.stgit@mhiramat.tok.corp.google.com/

Link: https://sashiko.dev/#/patchset/178165816303.269421.7302603996990753309.stgit%40devnote2

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: b576e09701c7 ("tracing/probes: Support function parameters if BTF is available")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 7ed89e8af6f871..2a080eda8df38f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -677,7 +677,7 @@ static int parse_btf_arg(char *varname,
 	int i, is_ptr, ret;
 	u32 tid;
 
-	if (WARN_ON_ONCE(!ctx->funcname && !(ctx->flags & TPARG_FL_TEVENT)))
+	if (!ctx->funcname && !(ctx->flags & TPARG_FL_TEVENT))
 		return -EINVAL;
 
 	is_ptr = split_next_field(varname, &field, ctx);
-- 
2.53.0



