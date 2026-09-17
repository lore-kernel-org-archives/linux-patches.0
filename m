Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89F24FC359;
	Thu, 17 Sep 2026 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668059; cv=none; b=o7BuZlu8KTx+ZaPlukBLuO3dEj64Jy3Dcd9f7tq2VTSMhrqB6eSpVGmXNxI6t00QmBZK7aiOilymvslrck3g4HO3X5g1xeeGneKHZ/FnJj0l4SK2kxJZzQu+T7ewy9cS1dsZxDpiai3sD/zVjyimhQfZbvT6fnUBA450u2LEceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668059; c=relaxed/simple;
	bh=ildDKqsUUcsKWNoZFM+Oi1N8mnyd0LHnxQs1PRDpwX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAnLLwR08/HjWOQaFNOjn6VNk3gtFJSyI1Swt4GxdKWZHk1wBUZsfrOSU2iUk2vtpwKYPGIEcVKNPpk80ZiZtyeAZL7gBkJartUkKLz25SVZ7x1iunjghcu5oxH1AyIG4owM1ZFbh/T4sVmkPTFsGWEIf5DhnyWXn5iYb60XeYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2z1caKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2z1caKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8C61F000FF;
	Thu, 17 Sep 2026 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668057;
	bh=ZBpyCqoY+NeFjY2gFQBCaAjwFh71kIidrlG/MlJ+29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2z1caKygNx8RCzAnY7ILzrn0jaW+wMI1OgU9F02HHGQbp4kwe3W596YIcHBlydzy
	 lT+AL7Wyx4agVNU+OvvthfcTdfEQ6Fedh1+M6gcu1kE68QlSzpbMM6EChxXRaC0O8g
	 SYRzDIKG6ds2tNNUJ/Ecryuj4eWeDi1p6onljXj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0300/1102] sparc64: uprobes: add missing break
Date: Thu, 17 Sep 2026 16:04:03 +0100
Message-ID: <20260917151547.149948770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



