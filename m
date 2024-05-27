Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16767262BE;
	Mon, 27 May 2024 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838121; cv=none; b=sG/rYhoBpmj1c01HYVGw4lFsBfCifnFvogn/xSm56XzGcmH57cpmqkDfQRFj7SUl3laFZOaXEO5/k8m6Q9GJGDhy3jsq1Up4r/rw0HbA18ltgEM+C86ug7HM8FsIK+WbapQ4bHAdQr+VLxCgW6YJD7vyybZ4LiCPu/+W9DQr7qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838121; c=relaxed/simple;
	bh=fdG1A/qxvVHamtOD5GgFHTc3g6vJD8nnQHNFx31GTc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3YCR0g6eCyMf3EgkgsekH/1qyJUGoO7lEwhR/7hFoe14DU5SEhD8hWyW9Z70BxKPLdyzDtDo3w7Pk+hcsFaDkvojXTb2FevCVWoIYj3LpQ0rOOFRDOZou7wDDNAhFXd5LmC9QNlnt+Ih4ec6BSsZEXtCgkfJiDL1MeAoDzxIZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCZUBC/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCZUBC/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977D6C2BBFC;
	Mon, 27 May 2024 19:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838120;
	bh=fdG1A/qxvVHamtOD5GgFHTc3g6vJD8nnQHNFx31GTc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCZUBC/bUeviSo217JA1hc+hPCCGvvp9+iifc3rv6LLa7/RZDv5nQCmaRKYoTXcUQ
	 4m+kmlAHmhKEDnxz9fBHyR9sfIHbZPwMwcqCKZyhFSjX3OZqYEDArzC6Cg9wlm8FfT
	 aQL7MzlU0kr0KRZoguxLO2Zs8hdjRGUiH3Ru9yLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 275/493] libbpf: Fix error message in attach_kprobe_multi
Date: Mon, 27 May 2024 20:54:37 +0200
Message-ID: <20240527185639.290243321@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5af9cab422ca3..028d8f014c871 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11561,7 +11561,7 @@ static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, stru
 
 	n = sscanf(spec, "%m[a-zA-Z0-9_.*?]", &pattern);
 	if (n < 1) {
-		pr_warn("kprobe multi pattern is invalid: %s\n", pattern);
+		pr_warn("kprobe multi pattern is invalid: %s\n", spec);
 		return -EINVAL;
 	}
 
-- 
2.43.0



