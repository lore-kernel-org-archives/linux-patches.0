Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382C746EF95;
	Tue, 21 Jul 2026 20:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665619; cv=none; b=QIkZexjFBLkvEPstdPgwDSxzIPrgEPtLZ90dYkn6XxzRstim7fyAvTyE2nWQeTw8lvfNA7NpVPHhMJJElgrZhx4YreVr2bR4ACFJWZKuq8IKwErjemI29gNRKGPCH4q6SHDRGfyinMi7rOrzJq8T2GKh3vMv4w3XTKfQmj6gsb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665619; c=relaxed/simple;
	bh=jUGL8lMHPnZ0MIYRSKluJDYg8Yoe2LzoEbNXUSTDK8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbdpOn/DVcM62ooXuMtSBna0Pkp8xEQqAQZYLEDjjcixXXZ6cQ6g6lf37pm0dKOAXRhj7Dpnp4pGq2OXIjkEh1KPgmc6i+/cDgqsPvq2OZfJu5RdwGtlpQbnrOWVWqTRzktKBlNVpP4kwVNBdGUfSwxcLFpzsYdUwZurn3xV1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vz5nHgGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz5nHgGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C71F000E9;
	Tue, 21 Jul 2026 20:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665618;
	bh=a2icXd2nBuNBxQc5LCaNFDQKnNCLu81uPBw0llEMarc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vz5nHgGeMy2JknKh09UytPN2tWyN/+vgzF24jTf4PmgY2sZrLDyUfj0EPryMULWBV
	 eWsaaFV7tnVZ7J1nLuov4H0irRL00uG6cngWMZousC7x9TliidZBDJmFhULO56bWZ1
	 D2Gce8yuWFk33uL7SMQrj465IV+6IEHs9JdgN1Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0365/1266] Documentation: proc: fix section numbering in table of contents
Date: Tue, 21 Jul 2026 17:13:22 +0200
Message-ID: <20260721152449.994552113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b59cff8be1798..0a186efa0cec53 100644
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



