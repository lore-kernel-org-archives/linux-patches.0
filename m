Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070D2EF652;
	Tue, 12 Aug 2025 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023666; cv=none; b=I47MaDFWPFp3+6VJwXNisPZU3HeMV6saVMTVzpycNh/rD69pWREIVY1Q7CYh6OxMP8F0LrZIRuWYorHPJAUrqqJotUlU6QlDZVpFIwhcZWBDOLF9eOlXGNvUcU+PhWkAh0029OSjD/wYLMb1WuzjTO0LvAx2Kmr4GpoCcwY13qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023666; c=relaxed/simple;
	bh=ox3MbYBpSyphXpY/OZSHX916SyUhUfqWNM1H+Zn6yOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVCZNu+EWFTXJJqUUoeDcDPt3bT/dKN8ER6qNuXO2yWOFgzwUl8nScnqCxs+/Sl6dwXgvqWjVnQd5bHEScFbm6sjItg+st0ms38AG7jfVKEz2k8QaNqG3ECbhqA7BmHIpGYrTSbAsjbb0KNCzVsMTtMaaMAPyoDrMl94d6ysAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHoBYCgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHoBYCgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85347C4CEF0;
	Tue, 12 Aug 2025 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023666;
	bh=ox3MbYBpSyphXpY/OZSHX916SyUhUfqWNM1H+Zn6yOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHoBYCgtgB1vsK8IkhTtV3Xn+ZqAqY8rFQSSvh1vGLte4LlbkDT8J7ovkiqxnXcKJ
	 aM44M97Qv9znd2XNsOWwkJbT2Lf5ocy1JqqnO5fLFOSIUbvyppmPIjL1Te5HQUEjcO
	 QeM43XQQfwgllKWJoU5UlyhrG4yeqNMkN4JtfbHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 147/627] selftests/bpf: Fix unintentional switch case fall through
Date: Tue, 12 Aug 2025 19:27:22 +0200
Message-ID: <20250812173424.892810177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 66ab68c9de89672366fdc474f4f185bb58cecf2d ]

Break from switch expression after parsing -n CLI argument in veristat,
instead of falling through and enabling comparison mode.

Fixes: a5c57f81eb2b ("veristat: add ability to set BPF_F_TEST_SANITY_STRICT flag with -r flag")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250617121536.1320074-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index b2bb20b00952..adf948fff211 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -344,6 +344,7 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 			fprintf(stderr, "invalid top N specifier: %s\n", arg);
 			argp_usage(state);
 		}
+		break;
 	case 'C':
 		env.comparison_mode = true;
 		break;
-- 
2.39.5



