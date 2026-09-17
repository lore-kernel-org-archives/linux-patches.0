Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73ED5372C1;
	Thu, 17 Sep 2026 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664536; cv=none; b=sfDDny6dMyg51GV9hMwaoLVVc/0rckay5kqItGDtNfPs/CJDTvseX3gzzvR2PR0DeIJjBKlEDTrZXiUZWCQVwMXX+QiGa9o5iNSCacCfmWRcKSuAFNREm0hLELA+TnRLdAl6Eep/MW2NnPDBVOgoPQkC4cocZ4ZtHJ8O71OIvuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664536; c=relaxed/simple;
	bh=wW1hyOip4KusyQOulUPjqNrtek/Cdidr1khjLP2W+Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZabAzDOKUhk26UVv7j72nnNh1h2UxkNCN+raWK0O7ijfrS3zzI6eFHHIaydONONJ+Nk9N7r/mSkOS7ewLGONg1nZRLBQ2L7nWXXulrFwmfAvwatReCEjy4aiAxI7clZ1NRebO8AHBvJIpgHyOX/7UqINZVMeQBM4Yt5WuzWdwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4jFHVSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4jFHVSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12211F000FF;
	Thu, 17 Sep 2026 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664534;
	bh=sya0xLwlWtwpuBpLYpRzt+Kg50rmfbJNNN7Jv+Vaf+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4jFHVSwv/1VfW+hvHr5gpoCeY2/Ehi5pOFdi837W3jg6V/IdKz35/fX2nzZlBxKO
	 6bwldhXUhMJLW6cMvtlaekmeRQ21vfYYoeW4izenAyF8RJoZPZADtsbDs2O2nY83lC
	 FOpWr337Rd3EhUZMIepkwG+uJlPfG83o9ChR2sLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0405/1250] sparc64: uprobes: add missing break
Date: Thu, 17 Sep 2026 16:03:20 +0100
Message-ID: <20260917151603.005865212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 305017bec164f..c8cac64e9988a 100644
--- a/arch/sparc/kernel/uprobes.c
+++ b/arch/sparc/kernel/uprobes.c
@@ -280,6 +280,7 @@ int arch_uprobe_exception_notify(struct notifier_block *self,
 	case DIE_SSTEP:
 		if (uprobe_post_sstep_notifier(args->regs))
 			ret = NOTIFY_STOP;
+		break;
 
 	default:
 		break;
-- 
2.53.0



