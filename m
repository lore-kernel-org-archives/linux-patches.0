Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C352F242D9B;
	Wed, 25 Feb 2026 01:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982814; cv=none; b=aRiX9d+6eXwgthm0Cl18tPWB0UM33Zr4MiVMCvlAvH8kb0tsKlYUi/2dIlOytSXP9oQbaRrlIpYY+Lg1h6gzksrO+pygn2I242aNw9c2v06wkW8Fx/dhEiUXCAnL1pPOPK3Wd9G1ALWVzWq0m2TbOzdsqfF5wY8j/68K6fk6IuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982814; c=relaxed/simple;
	bh=ss05e6Y0K3+h/WCt0gYGEU/VngD+RN27LG8IBkEdncI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+ON/Pr8KahiMegk/z6zz8WdJK3PtWW0sEbvTMgHZX/wx5l/NNz1wz6anvKH3Gv9mnVcp6g2XGWgQ6aQXSsnHIIePmikgBPbFfAhOSBu9P9Yx5NPdRmmE9yqh6S/vHGwStadfCGZJUNyEu+09lsR1ouXPZcv3l23dQhS8HtQG7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oO+w+fW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oO+w+fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B4FC116D0;
	Wed, 25 Feb 2026 01:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982814;
	bh=ss05e6Y0K3+h/WCt0gYGEU/VngD+RN27LG8IBkEdncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oO+w+fWI6vAYrWwV+w7k/QMNidsThTNG4fyQuo+Zq35EzlgpE2f+4qgIKDtuYoQE
	 p5AEN15FX7Q2Ipffm0okEEqdHhAR2ydLAQkCkOX19j8iuCjukIW0i1BA5yX3glcaTq
	 ww9Dg2Mb3v9SrSx6ZGwVf4ELO7FWRHrzM5/TFlVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 012/781] fs: add <linux/init_task.h> for init_fs
Date: Tue, 24 Feb 2026 17:12:01 -0800
Message-ID: <20260225012400.005271668@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b8c46c5a38a05..394875d06fd60 100644
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



