Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11373A2AE1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302662; cv=none; b=PfG/QOStZo6AklCqjvTig0uBvI2LaiXkFo2HW7XbZYJ6Yvc63xr/XQzjVXf9FxAiSGNMI5X9PusK9Rv9lD1+P6qiukAfx4vNGuxuWXhNKRyBUTomw4Cy6ShrlyMRZL11bCumAFLaHRehSK2a3FbuK1NS8uHGEuzdFdhcSC39Muk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302662; c=relaxed/simple;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KF98/lgIRCqBMAYn85uLEzTISJVyS7M+nZIc+Dpg4QpIO+UDzhq3dCs/okaGAjqZP8lZmFem1QBoO3QZQZ44siiZfGBgrLwdbi5L+UwsG/EW6iRTxY4rC39Ed/l50E80AwphtTgVyfoZoZaE+BqHJRVR2r9LqtKmNKfkpym6O3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/g6yEHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/g6yEHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1921AC19423;
	Sat, 28 Feb 2026 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302662;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/g6yEHsGKUBii9J91EWxkz/xfQOmhr4OqXsxCh1fbSd5Osf+8NX6p2uO7V49ClHO
	 FpZJvADjTSTb8FkqA+J+/0SoRpy90pwu7E91XqOcMFAz6DE9pnkf70ghhGRnjiToVo
	 j6FZ9qV94KdhLCP6JMngfltKeBA3pUh7aNujXkd/Y+yzxAfPFBnbSAYWwtNQ6O6RTx
	 Gexwyzdqda5gJjs+qHJRTpFi7TgqQPWINWjMkpNHunz+slvqEwU2rfEy9geMJmJMAZ
	 +ZKynvrReunSuL4aqoGN1EnjFmPW6a1E1nFe0+KQyQ+rTOWzp7QtFk45Brn7AA3lb0
	 NfB3Dmyx4cXuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/147] fs: add <linux/init_task.h> for 'init_fs'
Date: Sat, 28 Feb 2026 13:15:15 -0500
Message-ID: <20260228181736.1605592-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

