Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C1D44AB9E;
	Tue, 21 Jul 2026 21:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668726; cv=none; b=fBa7u4LsClNk6to3KxkuZ9OmAc/CfQH+zeR0NpHaf7DuPS75vnZvzGgZC63qY+x80wnJqy3VOJ9299nQtNB12eKkni2/iIT6rUaxBLBDq9BwMyPqSdgyNerFEspsOoyPFTz6EikG88B3qaEfd10aL5sw1yET6uDpaKDjwnSvcog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668726; c=relaxed/simple;
	bh=IMlqzIAkQJdjmGCigmQtKgaDKcREQXRQ7PTwcI68HKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvsvtdF/541Bug2zg0I7Uu/mg75cLYEN92fq3iuPYCjUTk7bZabRFQqKa13fQtKyE47N5aUj5Ti7n/dH/8IOcSEhzHiaKjWAHDT960AzmW+j1S0OGsZELWa+6TQI94a97h67UvNDS2hlxqLx4fKvZGB2VyTqCBC/VVwYkD/yR8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb6sD4R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb6sD4R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424991F000E9;
	Tue, 21 Jul 2026 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668723;
	bh=kyLgGxgQ3wE/KqikIVEtzu2cGmTlIYL/pNM5FXFwDmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jb6sD4R+ynnrpr80+7Z2PGO7tymX/md8VVotyhzYSlCawz0M1LUM8C+QrV5n7aG2v
	 LZRSWeZZMmk3sA2dDU/GcBTewWhGoysW/VQk/ZP/p0Q+9XV3B93D9zNiFOw0hEQHMc
	 8VFs54S8+llqq3Fzfy6xlBqa0j8k/9eynJMknnmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0282/1067] Documentation: proc: fix section numbering in table of contents
Date: Tue, 21 Jul 2026 17:14:43 +0200
Message-ID: <20260721152430.909465801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 97a7bd8c2c58a6d820df563d1d0f68aafec45477 ]

Commit e24ccaaf7ec4 ("block: remove last remaining traces of IDE
documentation") removed the IDE section but left its table of
contents entry behind.
Fix the stale entry and renumber the following sections.

Fixes: e24ccaaf7ec4 ("block: remove last remaining traces of IDE documentation")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260424090654.19229-1-liubaolin12138@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/proc.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 898c99eae8e446..2efadcb651bc3e 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -23,13 +23,13 @@ fixes/update part 1.1  Stefani Seibold <stefani@seibold.net>    June 9 2009
   1	Collecting System Information
   1.1	Process-Specific Subdirectories
   1.2	Kernel data
-  1.3	IDE devices in /proc/ide
-  1.4	Networking info in /proc/net
-  1.5	SCSI info
-  1.6	Parallel port info in /proc/parport
-  1.7	TTY info in /proc/tty
-  1.8	Miscellaneous kernel statistics in /proc/stat
-  1.9	Ext4 file system parameters
+  1.3	Networking info in /proc/net
+  1.4	SCSI info
+  1.5	Parallel port info in /proc/parport
+  1.6	TTY info in /proc/tty
+  1.7	Miscellaneous kernel statistics in /proc/stat
+  1.8	Ext4 file system parameters
+  1.9	/proc/consoles - Shows registered system consoles
 
   2	Modifying System Parameters
 
-- 
2.53.0



