Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA220F090;
	Tue, 17 Jun 2025 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174717; cv=none; b=ZnJtfcKRHAx6QT/S4yPM1Izvqq4a1mAKKFEZTR+ZpDoZ00SmB+sH52HqYLPuM/UT/fZNYfyTuTwSGFa0Vtz4CGyIhRdFW6hf6cYTV9eqG8ts8n+tgpzrwfNrcjHBUjzrGZsCpltxISl/nu+iNl5nmauN6MDpZgrPo25zhRA9sl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174717; c=relaxed/simple;
	bh=wH9NhlkLnVtRne9h6EYVjfcak2WG5TzDXZRlseGeLvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0WWIMEDppKPFr8cQ614fZVwvNiVHUbxYipLH82yHwHuEbyar5cbjMq0BCnA2fgf94oqpifbbRyhRRfqgvEZRGEDiWAMBGuu2vG7kaQAsUxVFBxCoHrVgGfUA60ikxmArRHFv57YledexiWgUvkxAHWmNckjvEMG96pfM8/+ajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvwP1pSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvwP1pSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D2BC4CEE3;
	Tue, 17 Jun 2025 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174717;
	bh=wH9NhlkLnVtRne9h6EYVjfcak2WG5TzDXZRlseGeLvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvwP1pSceIbUknIJjxbxlUfHqO5qp0XWpc1sMdVzsgWABkDzCz3u7E9ONa6SC4KUm
	 fzzD44/EE4YI9QdAfVemEPRcX+6q4IL3SfL6J6Xb424NS+NGgwvw0Diz7LlB/8DepF
	 8fLmTqYjYQVzCEA2xdu2FPQPGqt/OjuQ1SzSo69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 011/780] perf/x86/amd/uncore: Remove unused struct amd_uncore_ctx::node member
Date: Tue, 17 Jun 2025 17:15:19 +0200
Message-ID: <20250617152451.953807546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 4f81cc2d1bf91a49d33eb6578b58db2518deef01 ]

Fixes: d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore management")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/30f9254c2de6c4318dd0809ef85a1677f68eef10.1744906694.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 49c26ce2b1152..010024f09f2c4 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -38,7 +38,6 @@ struct amd_uncore_ctx {
 	int refcnt;
 	int cpu;
 	struct perf_event **events;
-	struct hlist_node node;
 };
 
 struct amd_uncore_pmu {
-- 
2.39.5



