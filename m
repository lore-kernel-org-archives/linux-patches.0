Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749C036C9E6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302295; cv=none; b=aDaJMC+bMLif4fyKl8Qf7og3lb//rQgyY7Ypodlhp6K900vD8eNZJQWrirxvc5+KTdEIG2aRwyyVlvvRb4aHaN+vzYgXRNEzULwYNJwRgs6l4ypFTgd7v55FnKMserU7VIjZuWdPLjLk5JeLImB5vzV7Q0ADBkjIQ9wjUKi7lVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302295; c=relaxed/simple;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ+YHGSLiwbTHnBaEIUScta1gEpWKvRE4VL9mFvQhXJMx/5m9iqZYPAgRlHwVXPhAyMZ3kxosslQI0PZKsRJp+ZaQG3LVAYqLmSjWt9U8hbpq5oolf6DBa3v73GGum33FJgq6P8PMLZKJ8fqJNV2wV7xvaBLycZ8HLC+KTWSaWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjEeVolG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjEeVolG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C2C19425;
	Sat, 28 Feb 2026 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302295;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjEeVolGegDGcR1wOF5cbd+hoDtpk+bYtO2nVtaA+RkQyc5DEt8GLahYyRSWEQ/FA
	 aDu/Du1ehyaCfm5ABJIcfOcwaI4Janr0vQCoZtEa5/34MCDY5WBpuhnSUDHhY00scX
	 dlQaHP/Ius8qKGNgyzlicsHRZ80i6rz8IDOipGJChsPDWrz57FNG0b+exN566rnUum
	 ktT5R2jDKtZ74nK+fd7L76o6Xvld2ILreU4rKygDGqkeZhA+kKtjGlyEWkBdZewlR0
	 u7SnvinO0Yd8+YTbIZePo6rw94GbfQL8fV2sj15zuBXZ+xhNbaqyNRfJP8LJmCNZo+
	 DbHWhcb+ekItQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/232] fs: add <linux/init_task.h> for 'init_fs'
Date: Sat, 28 Feb 2026 13:07:41 -0500
Message-ID: <20260228181127.1592657-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 589cff4975afe1a4eaaa1d961652f50b1628d78d ]

The init_fs symbol is defined in <linux/init_task.h> but was
not included in fs/fs_struct.c so fix by adding the include.

Fixes the following sparse warning:
fs/fs_struct.c:150:18: warning: symbol 'init_fs' was not declared. Should it be static?

Fixes: 3e93cd671813e ("Take fs_struct handling to new file")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260108115856.238027-1-ben.dooks@codethink.co.uk
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 04b3f5b9c6295..0b0f88259cc60 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/slab.h>
 #include <linux/fs_struct.h>
+#include <linux/init_task.h>
 #include "internal.h"
 
 /*
-- 
2.51.0

