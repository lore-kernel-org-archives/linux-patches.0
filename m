Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7B26D4F2;
	Tue, 15 Jul 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586936; cv=none; b=KkgE1DiMmpU2k+zRwH3g4VuU5OWqmUg90E6n3FoqLqMZEGWMcrh9nliK5U+3bs1MeD9RRcPJn5Qr2A7aikgiNlApgbBOpu50lhXCOLYn5uknj8ySeRd8lN1g34iUXGOeP9bzK6Us8j+XXBmD9meCxFK75FKG/JnOXzkVg5HvEuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586936; c=relaxed/simple;
	bh=0ZBJDQqNzBd3Dzd3Va8LLPCN0oaR8JB7wzG86lfjCrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp7DpSF2TrwYiY2yle5tqtZ42gCw467gfKQKsEskHs8l1mAFufe4TieXeABqV9O+sppIR//XuM1H9mz7/DYgNZONc/oVb4OtWUtvUT5z7Q7aG4+/GsukO8S2Q01ND+9lABzkpif2vK8FZghihyzeCr2EuwmmnUeN6A29cxhYBz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUlF6Gsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUlF6Gsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52CBC4CEF1;
	Tue, 15 Jul 2025 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586936;
	bh=0ZBJDQqNzBd3Dzd3Va8LLPCN0oaR8JB7wzG86lfjCrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUlF6Gsa2Vrk/SmEbrOE9v2GhjuoYKBA3LxYn6ciiYyDUvYC3/VgMRiPxEUbWmnpr
	 902TkNd3HvRzk0b7nMVOzaEXfObSjMGEH3v0PUaCdmpVBKXssrYZzBroXXXPbT7Yuk
	 6849GLMR/Sm/mE1SenSlRWV2ImfjAkGGO3mjCuGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Illia Ostapyshyn <illia@yshyn.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 105/192] scripts: gdb: vfs: support external dentry names
Date: Tue, 15 Jul 2025 15:13:20 +0200
Message-ID: <20250715130819.103733410@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Illia Ostapyshyn <illia@yshyn.com>

commit e6d3e653b084f003977bf2e33820cb84d2e4541f upstream.

d_shortname of struct dentry only reserves D_NAME_INLINE_LEN characters
and contains garbage for longer names.  Use d_name instead, which always
references the valid name.

Link: https://lore.kernel.org/all/20250525213709.878287-2-illia@yshyn.com/
Link: https://lkml.kernel.org/r/20250629003811.2420418-1-illia@yshyn.com
Fixes: 79300ac805b6 ("scripts/gdb: fix dentry_name() lookup")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/vfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/vfs.py b/scripts/gdb/linux/vfs.py
index b5fbb18ccb77..9e921b645a68 100644
--- a/scripts/gdb/linux/vfs.py
+++ b/scripts/gdb/linux/vfs.py
@@ -22,7 +22,7 @@ def dentry_name(d):
     if parent == d or parent == 0:
         return ""
     p = dentry_name(d['d_parent']) + "/"
-    return p + d['d_shortname']['string'].string()
+    return p + d['d_name']['name'].string()
 
 class DentryName(gdb.Function):
     """Return string of the full path of a dentry.
-- 
2.50.1



