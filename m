Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FDA3749F6;
	Wed, 30 Sep 2026 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784535; cv=none; b=Y+iJs3eDbRFAlFHSEKD6T4xWEJ+BhjQCdW+H9W/4Z11ZALc4vX2zOQlHB//sikP0Zk1RQwqXdmLzhrO7Pf3bQ1gIkjAr8jGXYziACoXJgUuvCw991t5vSm1OUl7T6aLcC8pm7KuKM8LejOubsZYrjQIJlG8gA3t9JUx6APtoP4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784535; c=relaxed/simple;
	bh=oZdhMNdko12BN0QDAfpPZzHOwMXHzjFXd9GfbMjq+4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTQzxgiTXdXhuCcow+GLAvfQeWxVERDqPADDV2RSV41AD0S5dAioiI/+v6HaPuKkSwpqhmTHlfaNwbDfI5cPkIEz+SEJBLCZTxH2qEmeHR0vxeBIc03/PAzKJcubyU8lERXWgcoiwWtijXTzIn8B/kZOQkhGOkpfErKNwBfdK9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmrC35FE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmrC35FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C461F00893;
	Wed, 30 Sep 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784530;
	bh=Ga1ARxAqHMd7SeGKyDLIHWlKXf4hrzZmXrN0SZrc8dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmrC35FETcL/fbWx80ylSj0g4s2JQcOA1b5ywKNUoH2ZTqryKkHLsPiKgHEADXk7w
	 u7qk1Hox2MtUqpkoQcpeRte6bjOKN1HnAwEtm9RRcyYmZZk5HZod7QuxTfhWwSD7yT
	 r/oAlaqO2LKk4eNqAmxWsXiS7w837jnzbKHb5yo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/982] sparc64: uprobes: add missing break
Date: Wed, 30 Sep 2026 17:15:24 +0200
Message-ID: <20260930152420.854612063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



