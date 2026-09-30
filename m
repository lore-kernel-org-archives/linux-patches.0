Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0CB4E2F0F;
	Wed, 30 Sep 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790990; cv=none; b=iyXhpGXI9S1fZyMKuw12KRCNJiFRFlYlLD0aMSCc5TFLLxiiKwoXWn2VeP7wTperY2UjJwKkcJjY8XSny/HjoPwDWO4QtcDpvhUwpNBgtW3UudCSi1Zec3W4iPYP3hojBtBcw8vTvwy0tGGE8Rk/txQB4sehCXodTmcSHw6QjMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790990; c=relaxed/simple;
	bh=WdzFTU0e73nu15+xqsUf8pOyBQfcHkGDSiLN+j1Oq3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsMahu9hIjC8+koUpHCivh/kVTf5G3EHhm7VkMxNh+JYn8XPUzTjLmH5NWt8IAlcVAycvejkTtqcSchWHFXpt8tL4+1iXM1I3FuVmOvhtqcOTUk0p/2pH9b5SVuAvAOHbrG/csCjAjgDPNziB354+Usd0iHO7mce8lSjdTSigFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx6ckUSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx6ckUSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7689D1F000FF;
	Wed, 30 Sep 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790989;
	bh=Jf0r14590xgRxgDb1nS5cVh2goPda5hDEOg9lGj85nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gx6ckUSz/ADvI6IboP3x9N4TLcfC07zvXejVNVu79dsNZdmTa/4tiZU4HaFWb+TEX
	 86mBuuURUwH9Rxw8b5CMlrcIwmNGQ3oXF4Lh721uB51SkRnR9KOKy9vODfQjI0xARL
	 2867FGWrE83FR8KmX0HjzactLiPyKvwZarUpxtfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/752] sparc64: uprobes: add missing break
Date: Wed, 30 Sep 2026 17:20:16 +0200
Message-ID: <20260930152401.341716826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 5b0eee4cd812bd6547eea393cb9b5c0322f26c88 ]

Missing fallthrough causes failure with newer compilers:

arch/sparc/kernel/uprobes.c:284:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  284 |         default:
      |         ^
arch/sparc/kernel/uprobes.c:284:2: note: insert 'break;' to avoid fall-through
  284 |         default:
      |         ^
      |         break;

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/uprobes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/kernel/uprobes.c b/arch/sparc/kernel/uprobes.c
index 1a0600206bf5c..dbc51dc2bb4f4 100644
--- a/arch/sparc/kernel/uprobes.c
+++ b/arch/sparc/kernel/uprobes.c
@@ -278,6 +278,7 @@ int arch_uprobe_exception_notify(struct notifier_block *self,
 	case DIE_SSTEP:
 		if (uprobe_post_sstep_notifier(args->regs))
 			ret = NOTIFY_STOP;
+		break;
 
 	default:
 		break;
-- 
2.53.0



