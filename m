Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F79D46AA6B;
	Tue, 21 Jul 2026 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648109; cv=none; b=uiHv4QFu4PLy0EUgH42SQLGlPM7lRK8GwqRN630fzeAElxo4CEVg883FpEltgauOek/XkW0XEd2rvwWRpMpjcKgk6ehOJmi44M4+B+84FR4IXL3SzHt+4wazSpn6xMK973gOSgbYN0rfFwlNtjm9cUIFM+KVJgpQpBYNLDD7ZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648109; c=relaxed/simple;
	bh=sxgComtYbIW/XHhPIQj0pNblqUpH8ljXr9GuGqlYQNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRV4r37Z+2mVueKrmkDDrQlJ4oBSU3KvEMZyEiPdb3EZz0TEAgft9sEUTFlTt1vy9Fm6qOlohQTgmmO5SlGmOVV0xgv8oEfnvm9oSFzmH7ZjFSq9a4DrSjWKq5sGpQM0/5xIkCYo5Y3HKp6+qqtiicnbAYfjLVfIXHtPx9xRpTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsAZdZTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsAZdZTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCA21F000E9;
	Tue, 21 Jul 2026 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648108;
	bh=hf7AYy1HDu41gdAzbGQKMz7EjsB4EAiiauxNWmgv5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsAZdZTr6DjdaGtJNw/d5VUSJMfTgghPQr2SUtqfaebHt0w1wKEi/njyvXn4QE7Jd
	 l9C689Kt3IUQSOJVoAJ9U/yW1QZNHZ0fZy4DSm/W2z4R8aHkrDYefW0RVmtMUalD6G
	 oBLogWWeVvePWOgOUq5xAItrgc6tr5rrWBxiVGnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0074/2077] Documentation: proc: fix section numbering in table of contents
Date: Tue, 21 Jul 2026 16:55:47 +0200
Message-ID: <20260721152554.438765999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index db6167befb7b2c..3c6e4f52f3e4ef 100644
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



