Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AA17E90E;
	Mon, 27 May 2024 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836832; cv=none; b=CfBLRwZOQv5M51l0NmCAXLNWMwgfnrJgPAS7eBVmDAI5t5pi2WefV0A+Jn3kVSsNm/OYyy14G+U9HfHSK2fw2HxbgXrChMcnyEFcoSaFFuOmLSunVYB2mAXM5AnONN6muX67R+bxxfg3GhV0xuukEvYYlk88S+fGHVLIYLgOSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836832; c=relaxed/simple;
	bh=+3t0+BxcvoNxVcjl0/75hdS6BShXJt396YOwR4qbLf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewx49zVo/eKtBBRwfE+qaV3jrrz4/s5tgpssRd0i0nCvXkNmFm0Ij7KXMx6tHASYrlUWvXv5wlLrKrTJQ1WlQR7D4EAcIZdxOJAfttDWLDlGqfcQg95U4dwD8UxH3g2mO+VYgri0LoWOsm+BNXjKhcwGAXann1ZQWBK0G7bQ5N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUbIQuCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUbIQuCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9023C2BBFC;
	Mon, 27 May 2024 19:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836832;
	bh=+3t0+BxcvoNxVcjl0/75hdS6BShXJt396YOwR4qbLf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUbIQuCO/DlGwaM31XrY5ql1CLLpb60yqif1kzRfOY3tgqD+StwJIj44dt1+0Ott5
	 cixmb841CBUFQtYCyttgnlEq7ZSN6/t6z0m5DVpeNXaGv9VdV31+PHjq4jO6USJQfJ
	 VvfTof2HtLH9zukH64WXoBIBUU2bowxaZm7s10mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 205/427] libbpf: Fix error message in attach_kprobe_multi
Date: Mon, 27 May 2024 20:54:12 +0200
Message-ID: <20240527185621.453656298@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4980ed4f7559b..f515cf264a0a2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11475,7 +11475,7 @@ static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, stru
 
 	n = sscanf(spec, "%m[a-zA-Z0-9_.*?]", &pattern);
 	if (n < 1) {
-		pr_warn("kprobe multi pattern is invalid: %s\n", pattern);
+		pr_warn("kprobe multi pattern is invalid: %s\n", spec);
 		return -EINVAL;
 	}
 
-- 
2.43.0



