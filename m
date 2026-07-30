Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEFC440A0A;
	Thu, 30 Jul 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422197; cv=none; b=Ln/lOoR45zSWE0o5fOLD0SoBod41W0r2dCz+bt/lI3jM6fAtYCUz1io0NnBw+qgLW6D2whtu4g8+PG0L5gBT6MAVP6bAbH6cIvd01KqTBjouizJU3YOjEoWXHlImxHNXzqWNebISGTeYLzgikQhb64k/pfxZ+w154613i7KPH1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422197; c=relaxed/simple;
	bh=nuZupZP1bPCJ8zJyJDB0d1nclFplVDX6jUvEoL/YKPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWMtyvmjjijvxJP5Le48yAPs9ZNxJxHuf9DOeHjhegVgwozgkL4vWixaJGtfPNh6aaJZLSeHphrpFvriR7oPD3mFYF81OTMvZrXoIiZ41qkVWrQJhp7fLD3w2cWjOX1fKx0ANLSPiwU1qZLS9RLjKi9l9ER2SFaBW4cmKYBbv4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v52/kQHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v52/kQHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE171F000E9;
	Thu, 30 Jul 2026 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422196;
	bh=M5HqrvrPubffvWx8tXFLz8KB59OWJ0edKIInURhXCIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v52/kQHJDajGgD0eljATvn8bAFR5C8Kb5WQ8xmICx4luwUC3Ygz9fyDBkGgV40XDh
	 vi9Xg9lcQCukyFZ0fFrA8XEKONM+ZzDXNhc75ZebHXHPp6pc7kEAtDk548eEd5FChb
	 Uxus96NYLZPBlgL4ktWNMw7uRrjzq0P/luzwLRXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 355/744] pidfs: make pidfs_ino_lock static
Date: Thu, 30 Jul 2026 16:10:28 +0200
Message-ID: <20260730141451.830028829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit c1d04c1bce98f9dd984a9c6657278a7761854c9c ]

Fixes: 87caaeef7995 ("pidfs: implement ino allocation without the pidmap lock")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607231547.ehCQxi0L-lkp@intel.com/

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://patch.msgid.link/20260723160114.291515-1-mjguzik@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 143d0aec16af10..33874c891d285e 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -107,7 +107,7 @@ struct pidfs_attr {
 
 #if BITS_PER_LONG == 32
 
-DEFINE_SPINLOCK(pidfs_ino_lock);
+static DEFINE_SPINLOCK(pidfs_ino_lock);
 static u64 pidfs_ino_nr = 1;
 
 static inline unsigned long pidfs_ino(u64 ino)
-- 
2.53.0



