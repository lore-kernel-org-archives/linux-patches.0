Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F243EEAC7;
	Tue, 21 Jul 2026 19:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661445; cv=none; b=XwbKcjzwOSr/ldMOwwCEDlZY8rVG0GHv1zqhCOG3OMDwUrV0+CO/GwxbKgST1NdP2slXVTJq97pIXaiyr2IKaFeaBTvvBB7GHj1hncp43igh2AAp3SWR1fBMQfjl4AE6qX4hr+NQmuezYRGLxYbdIEYjwODU52UaFhijichuUg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661445; c=relaxed/simple;
	bh=mObt0y+F4IGnM9/XDwcEsiOv7JJ5lAvSmmyRURvE5CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eITcHodK5MtsRSXO20mdezmKvj94QnU+TEEBsFq0tLNHOXS/F3Vow+aqhuatDlGhnR5P1xYmwLc9o+4sXCfSJEedyoSlynVjCgM6hnievljI1vm5IauGhfM9ObRuAJlYlLqDjpvpyVxS5EADkmI446+k8Nbjj3AgfL1ENrw6a6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng0kmL8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng0kmL8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B841F000E9;
	Tue, 21 Jul 2026 19:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661444;
	bh=SW5IDLDGtQWN2AlYuoZIiLSZMuy1w/NnW0JlCjcSzv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng0kmL8sJ0wE4RQTdKdLKnjgGc4ulBkR3D9JCILovZlD3yYO4mWKtJT/CPUR0VfbJ
	 wIY801wt0cSZWklTcttyX9Q1JIoNF9LmzymjMhQm9QhesKTbuWmGoiFee6LOYfrCtt
	 neGjWschtOYo05fiauqI2WzeC5mNaK6glOHyJuNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0069/1276] Documentation: proc: fix section numbering in table of contents
Date: Tue, 21 Jul 2026 17:08:32 +0200
Message-ID: <20260721152447.634135498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e834779d961153..af6cfb45b9058f 100644
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



