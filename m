Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B58750255E;
	Wed, 30 Sep 2026 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782663; cv=none; b=iZGrKwpz/l+I62WjUiV3bXKiKHPnMC7VJWum7kscbowkasTtp3dRQimsTdPtvIEQCh5wApyDI4iCNx7cvUznO73bJJ0tbyYTHcIQDEKMpWfuLoNZImm2ykfDcs1krL885kSbhexVOWtRq5avvkxZRZGRqapZVtiYqzCM8/jhaCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782663; c=relaxed/simple;
	bh=kNyjGRtd8maySxvtt2k7q1MtlkW7xT1NlYNoF8oCAlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dueh6pgUZQ9ev+UEPEdOR7Q/oQmj81XGqOEiIfInZkT5Ggydz1DxWcsc5GJ7Oc+NwioYR0nKWjdjkU/cTXi+c1PzHGMVI0XW2CKghM1e2H2zOvCfm/VWfNOfJ4TUWg2CDWxZ5gVDRHdVtbevgwCgOgvVebfcG9lMvZcnEwQbf0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X89zfDkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X89zfDkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF11A1F000FF;
	Wed, 30 Sep 2026 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782655;
	bh=L85vR57+QYzs3hyo6vptHvUBxBJUZYAyMxnXZ8eBz6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X89zfDkp9ckb1ynNwQ8Oiz4SuhWpC2wi3YF/LK3WObMJ3UoKCKiuwwF9ZRB25RVcW
	 Wc38VGrZ87UwB8zvcx8JVUo/s4mTTyDb/WZLvthcXzBhMKMuvyft9Cw1k73X8wn+Yq
	 IOPJNUqcFGCZIb6k4DJlG26HD6AuLVApkKiW/0Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/595] sparc64: uprobes: add missing break
Date: Wed, 30 Sep 2026 17:20:17 +0200
Message-ID: <20260930152350.406666391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



