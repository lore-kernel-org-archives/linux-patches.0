Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7092D5436;
	Tue, 21 Jul 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655614; cv=none; b=M2K44CNMUrYGCOQqXrIL3UZ5w3Ja6u7xy3jxydJn9Gqan9BwNZhzF6DGNJkwvGO6xH7vDfi1CkkCWu1WCXaZy/Tq9X+1JxhlDvEkCULux9BDXbB1myl0oRrnTYvlEGV8dRphvhT5Dzle9twJz4L/qnFWIbxbqrbYbWSOlz5WFbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655614; c=relaxed/simple;
	bh=lT5LRvDQYMmTmNNei8CTPwOQ3gUtawsC+xCwnviFnrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJuDxkcxSMvAP1U8jnvweYWNE+KLKADyleyRiTFCYRBkQnJtZX5kcT+vZMpBpZBmKXnT+KLvsTD1ug9OkyHgJgFbew2YvrOE/U3aiqqQ+Nyr0mXO0uNVYsEDMe+Gaauad+qQR2LjU3H3RxCP6h0PxFxvjKSisYNL6j1Khbf+Rdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGd/Rk93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGd/Rk93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6321F000E9;
	Tue, 21 Jul 2026 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655612;
	bh=tjlBSs/uNCgWW1I4ytp2rJ039dgpnXQ3A+r4KU8li0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGd/Rk93JRdElLDEdP6vXrCrqtC9wLJ4CEg5VMdE5wMu6Fjp+wilxtSHVQV2KI8Oo
	 1MID07FrDfMDbDgCVh14Ph1syZf9VmKe42wF/Qv9ZoWH8XIXglSpYqERp00gwVugSi
	 kBWjFUc/SqFbyuvg8soTg5tvfxlyp8SVL6HpXI8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0075/1611] Documentation: proc: fix section numbering in table of contents
Date: Tue, 21 Jul 2026 17:03:11 +0200
Message-ID: <20260721152516.524333578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8256e857e2d747..cf7eee2d9b61d7 100644
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



