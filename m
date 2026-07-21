Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B93D1CCA;
	Tue, 21 Jul 2026 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653494; cv=none; b=j9J3dUrtU8ZqgNC9/u0qw+pLTuTO+TA3GnzA+YksvqrI2mUzOjXnuMqS2g+mqraSBIo5uvxPXT1UIm322Kk++DVAQSIo1giprsXpb0oALG1dpbPIwBiDDGez6vjqELkVZnyzuaiwyYvcLkGpO0MXMkPl0mbEAX3NbUUFte3idQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653494; c=relaxed/simple;
	bh=pd9UwU+MatfHzVi6OiNoepy9xgRRIpy3WEYRHIc1Fz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBd7AAFVlqvEb5HZAcPxlmws1bbKRJ/Mk4Qz4BCNviK6Pi/ZqMXsWcBPk+AWZq7hzpDrCm8hHDpBoK5GOcTC3z33UmeHJbAdNOU4YEgehL9/T//KLlSut+gGSWe0CzODB87HtQutNyp0w0M9fe0HcPfI9/NfCS6qZCHFr/fvInw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8OPDyVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8OPDyVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436CE1F000E9;
	Tue, 21 Jul 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653493;
	bh=SBgImt/2fgrqL+/IOZl9bO/qtIXLn2uY9TccYDdmzFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8OPDyVdcwuM/YF/ZlLlgPOco42tfr7GU1OBTQoBYCDjbN4knDNNsZdiPvJ96Fa0i
	 4LKwIAdEFpJB12foC2mPPQI1HWne+xUGppFaCF82pvLaGPwUZxOuUGLTAd0u6hxe6E
	 EyUs2wfPTLaJnKf+Xrssi8Pcx6IVrkxrfhE9Bsy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1349/2077] tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg
Date: Tue, 21 Jul 2026 17:17:02 +0200
Message-ID: <20260721152624.634845808@linuxfoundation.org>
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
index 196eff704bca9d..0b1277f03dfcb5 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -678,7 +678,7 @@ static int parse_btf_arg(char *varname,
 	int i, is_ptr, ret;
 	u32 tid;
 
-	if (WARN_ON_ONCE(!ctx->funcname && !(ctx->flags & TPARG_FL_TEVENT)))
+	if (!ctx->funcname && !(ctx->flags & TPARG_FL_TEVENT))
 		return -EINVAL;
 
 	is_ptr = split_next_field(varname, &field, ctx);
-- 
2.53.0



