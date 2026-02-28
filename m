Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910BD383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302040; cv=none; b=ML1S+tH+b3/3XypER6juDxJaXvWDDm21JjAy66dR/n5xh/xuoN+c9zeVqBRny8g96VoEWvHbC534yz+F4AudNu+B2l54Chi9zWueIdwhgBYg16e3Djd5bB6IBO1AcjlQTqKdo1fi4jpPaLvp8CvqIlltxRMBwx7ZBHHdPWxQSUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302040; c=relaxed/simple;
	bh=uXDZBFBlCh9JEKa0Z6uBDUSQ7GEP1F5gk/R6iPyXv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG/Q48IXQJb8FCpdWALrdBJ+eM09TbKg/nGw/pDhT6JLXlKDCzNHv/xQdWKcmFyebABxD6nQc547sIAyQ1003da9yq9yjauPHm+GddidddFnpQbJO4Akk7LpMT9FQlLbEnhVbqifjJDh8tTDm8ugfSrwkOFtt1r+vOFSpgGJfXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IY1sbib2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IY1sbib2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D435EC19424;
	Sat, 28 Feb 2026 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302040;
	bh=uXDZBFBlCh9JEKa0Z6uBDUSQ7GEP1F5gk/R6iPyXv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IY1sbib2IcJBxVqdWmOtk1D5ZBJbCUKwl+ssAkFzTaOZuT3QCvd71Jms/HzIMWPKC
	 bSSfeof+5UaHMVN/RWKhep7NSq5j2FLF3BswgaI036HAPdecaNq1HsI3QaAY835tNQ
	 Fq0qWBCldYDx7gojblgwgeo4OS+1TqNrkQmsXvooBZaJhluJX9h1psjfQ6ckZ00H+1
	 1K9gZjITZEw/XmdsVrLcU0135Su9IQ6OhFi4qFKP1DVPCrAXnRWFoMtINcnRiV6lvr
	 2FO9bN/xCSDMJIDiSVT/hglOYWM3u8UUxGyi3wzZFaKhImc9MNSeRu+tejHZs8YI4/
	 DAj4YkztUj6Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/283] fs: add <linux/init_task.h> for 'init_fs'
Date: Sat, 28 Feb 2026 13:02:34 -0500
Message-ID: <20260228180709.1583486-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 64c2d0814ed68..100bd3474476b 100644
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

