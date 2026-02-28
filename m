Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C65039B948
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302512; cv=none; b=dZQkf3Hkq3MIHKxN8qBedSmX0BeC3aVVkhzRy+Nz7hp8LeduTEbPRPnFLS8FwG5a4x4d5mKEZAMfJ2XGHPzlRgW6uaWOlBCfaenxDMhpZKB4n5HEeoy+GG4mLCNpgXWkZOIzDS8F7UaGbUx2i41+Y6sa9u/PtjATYtM9WYekPv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302512; c=relaxed/simple;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teYppRAL1Oc8hsHTvMHA0n1+cUXcUgWWsNo1SPZCMfospK7SV/27DK98yN0fk74HCLLBsHN1CwQHNkv9usha7zPugxw57iXJaeyWLJqd/tbTu7XBp9nlZgbNvFiZm7xVuPJvP8hMLrHX2w/2zMyR74Xh4uYBIvBHVn3eYimpXHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDn3skK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDn3skK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C95EC19423;
	Sat, 28 Feb 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302512;
	bh=mi98M0NtUiWOAzTxHoAUPCHLfOuTIf9vsM+ym3LXw3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDn3skK3uauWxQH6/iHYFpMetzl5UNQD9Uz1T0IkOI5chr2VLdWsetIIt3pCkUxOx
	 cenEEvAu8RjWve9mjwvvu7iUIBXeMWkSkfrN6m12+pxabTGTGY5IfyztF98vEeMF9a
	 S56E6TpbqxF5Oqqj4JY2XJxKNfPmdZWs+BiGzQeSMA+op82HZWtawG4e+QxdYEtnnC
	 909z2oEgb74ESrRjziV9449mRNC4ElQRwaIi2nmkGQcQbOmwWRtTVZUZwRYEQ+CKs/
	 N3x95BoHoS9MMmahrZJwQDhfx2qswmds2+Yjdp+0ZY8o+RdOx36hX2lBJDVKxD2kP2
	 2cSVG/LjbVxOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/164] fs: add <linux/init_task.h> for 'init_fs'
Date: Sat, 28 Feb 2026 13:12:26 -0500
Message-ID: <20260228181505.1600663-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

