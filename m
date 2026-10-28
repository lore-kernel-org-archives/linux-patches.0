Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213013;
	b=tLCWmIQkI35bW7vTejJXw6k+DbJpJ6dD1zu+6RvyQlYM8r/vTfiG10hH8oPbzZavOgOW
	 LrH9Rzo2PmoY9vRPIJ32bGa3vQZD9fCeTv3OXJu173v8aEp+vJaXmOw2dCb14E/aTHjgr
	 nlh8Cls2Q6bcLAozm1IKRPl9N/z0YIRWva/Uu3m2S5FwXrBWJqPepXdskUk/rWcTNMlcj
	 qjDhp6xVBm6pBPc7KHfM8AOCbvDYXo99cag9VH8lAOePpDwd/bOQWDLvNkkpe+FUPjuOW
	 GM8LvtIO+YQfks7rKfpBCC97Gjpj2nmU0jeBOXbFSzcvPmLUd3iQp2OK+Ko467AXm3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBDnXDn8ZvJ6twLr4l9aX7GA0l9gWiV71vga1x+uFWk=;
	b=y+j8xa+qY6/gKID8Uxxran2k8Scaf9lYpG9R4bMgmjAso2aD0qel8Qh5h3p4E+6K97ab
	 Y+Dj35IWtRVxAgOXiX7yQJ1d8SD3R+3HC4Hh738Qg+ilrNX8lVXFJgeFu0tDuQ76Vypj5
	 34SFm+ci6x2/eUGU1TH1Q2yQTJYzaZbwT7wy1EFJuqWrrjpWxogv3CMCMO0QmSaoqoFC5
	 L4Aq9tKNJqRViKESQRJaw6jCX12vN6GHAFbAFAblIUjMjes8kfnWMaWo66j1xXkxDgQca
	 HWK8P/4IibT9G6FvmYjoJXaG+OBp058DWLE1yAnNWoWOBdAcC4xnOT1XRN71ao9ODeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="en4T4Gz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430E4606A31A;
	Wed, 28 Oct 2026 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=en4T4Gz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E701F01825;
	Wed, 28 Oct 2026 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213013;
	bh=ZBDnXDn8ZvJ6twLr4l9aX7GA0l9gWiV71vga1x+uFWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=en4T4Gz/JyHBJASuOyMBX1+97458Kwg7irk1SYVL8OnZUMoRDiXLZg1KJKwq/GH1Y
	 CLkLd14FLLmU8pszd1BcqvhF0M6YfyCf96UttU3Q8UEDstRSaMXAyw6MlgSR51kFWw
	 LLHbybcwCeOXJhQiGkQUQ2IfLEWxdx6+O9bi/viU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0357/1887] smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races
Date: Wed, 28 Oct 2026 17:40:53 +0100
Message-ID: <20261028170507.356013869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 19465a9aeb664f1d710d0d22c07c31bfb7c85446 ]

The invalidHandle, swapfile, oplock_break_cancelled, offload,
and status_file_deleted fields are stored in the same bitfield byte
in struct cifsFileInfo, but are updated in different code paths that
may run simultaneously, and are protected by different locks.  Since
bitfield assignments generate byte-level read-modify-write operations,
a modification to one flag can overwrite a concurrent modification to
another flag.

To avoid these races, convert these flags from a bitfield to
separate bool fields.

Closes: https://lore.kernel.org/r/7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com
Fixes: 3bc303c254335 ("cifs: convert oplock breaks to use slow_work facility (try #4)")
Fixes: 4e8aea30f7751 ("smb3: enable swap on SMB3 mounts")
Fixes: ffceb7640cbfe ("smb: client: do not defer close open handles to deleted files")
Fixes: 173217bd73365 ("smb3: retrying on failed server close")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
(cherry picked from commit 19465a9aeb664f1d710d0d22c07c31bfb7c85446)
[ status_file_deleted not present in kernel 6.1 ]
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a5e9f79c10f90..c37f10eedddf2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1337,10 +1337,10 @@ struct cifsFileInfo {
 	struct dentry *dentry;
 	struct tcon_link *tlink;
 	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
-	bool swapfile:1;
-	bool oplock_break_cancelled:1;
-	bool offload:1; /* offload final part of _put to a wq */
+	bool invalidHandle;	/* file closed via session abend */
+	bool swapfile;
+	bool oplock_break_cancelled;
+	bool offload; /* offload final part of _put to a wq */
 	__u16 oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
-- 
2.53.0



