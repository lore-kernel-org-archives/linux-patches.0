Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8630B38E8B9;
	Wed, 30 Sep 2026 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794459; cv=none; b=p+wnkSq6yGrF10NBolPVWg2SP6NKtDQazE4XtqmgXa7EXnqXqEv6HnHL57qeK9cdu3QfutYyxv+cRHpbfEAy2tVBORvZO3xdKGrnxj310e74aiQLEsRm38QA9djPrZNcaKgngabezvWvezXwsOpsOCNYLxhlOEFfB6BCWiiUqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794459; c=relaxed/simple;
	bh=SUPKDRbdosLL3FCxszYhH3H/B0l4WAX+9XeJILbEyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5p4mEeKEMDr9NdI2LNsTXLeQxCqpK6YBYP7ITukTHT9AaiCvXQy6nJX8kftVHWm7/yQc3K3xUnIDiLrKj18MI8LVd6ycFzvtqnovyqDxT+DJ01p4opsNvK9IWR4nMxjrbq/d1E0gqOPP4I3aTY5JUF/ex+EEzx/kLE/xBXwWuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/86dPOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/86dPOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D81F00898;
	Wed, 30 Sep 2026 18:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794458;
	bh=HCSiinvxD/PQsVHy/J+XhrIdjzJYw6ZIFD40W8q1Awg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/86dPOHWJtAl+TCNhBA+/vbsAWGOTQ0bvi6J8i65gx8Sp7suZS4PYevOOuqzbE/D
	 DmGkskYb9GSdLdJp4cqIMCUmGBuGKQUQFnqbB9+iBsOiud3Q4YBp7ugsj4I746YP5B
	 d1seebR0XFYmzlGxU3PeAPyMcZZJ0biJvUeqJzwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0218/1193] sparc64: uprobes: add missing break
Date: Wed, 30 Sep 2026 17:15:02 +0200
Message-ID: <20260930152439.043588190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



