Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D691AB8F6;
	Thu,  6 Jun 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683273; cv=none; b=D26h3hFbWB/cHV9SnUt5ZL7ayxD6iB18wQaGyjzxow9947EAxdrwhyyFwQozQdGbk/a4giHhmFcdAF3CH5M1hxv0agg/KUiawa8SeGfyWIagRoMqB9eWuU8EeTKVf6VhM42QkeVV6kY9KTA15vbpBexESijc7rJPKhqwDERGFag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683273; c=relaxed/simple;
	bh=whfTlVEXTrgfydJYkeiNHAkmRvpWZWrpnE7wSZVbHM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8uWiOksaSea9sxiFvHKx8y6euAllvQtdFKTZuxlZRmEjOmFrJDbPMs6dim8Zy0sO3Jt97XNhtGuTvKOXYLEuykI7+Pe7p4ctdsm+vBEaQyq040E4649I+L2xdFI8pWwqNhAVAlph5MrUf4lY5mKnqNHGbidLsuleecUOpLx2SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQLlzrRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQLlzrRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E6AC2BD10;
	Thu,  6 Jun 2024 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683273;
	bh=whfTlVEXTrgfydJYkeiNHAkmRvpWZWrpnE7wSZVbHM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQLlzrRVowfDqXVuNVR2EvLBfm9GKi7E0EDHhO3LlRGh9tmhRpQaKf3gVc9hMrhxF
	 LmHB4nW7Koqjeh4T+MvqgZjrZ2DeQNpQ8S2m+y/ltJpRmu8rQr/3kRs9V6VgI+tyW8
	 +XZyMvnfoMkC9n2Nc5tqlVWzge+VOjbQfZOJt4WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/473] libbpf: Fix error message in attach_kprobe_multi
Date: Thu,  6 Jun 2024 16:01:20 +0200
Message-ID: <20240606131704.950713883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c71d4d0f5c6f3..bb27dfd6b97a7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10417,7 +10417,7 @@ static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, stru
 
 	n = sscanf(spec, "%m[a-zA-Z0-9_.*?]", &pattern);
 	if (n < 1) {
-		pr_warn("kprobe multi pattern is invalid: %s\n", pattern);
+		pr_warn("kprobe multi pattern is invalid: %s\n", spec);
 		return -EINVAL;
 	}
 
-- 
2.43.0



