Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A86FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AAEC433D2;
	Tue, 10 Jan 2023 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375288;
	bh=oy+DMRkAufdaLJiqokJo/MEPw2YGy1lJPKuoxg868ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJbXTyGMkWL0Ht6uCK8EBqOrTlMzpRIRqtp+vADM80Rjbt6dNGQaKyUaFdkUugt3E
	 OWg43oaEFwOjEE2lDxQ+REi3tPdTM4trWi9v+uuekVKBdlSCD++6DpXVOUNVjVzFN5
	 xgXvsXYq2PHoeRC1Y9nkgHe5fMxoo3b1cAtIl0tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 141/290] ext4: remove trailing newline from ext4_msg() message
Date: Tue, 10 Jan 2023 19:03:53 +0100
Message-Id: <20230110180036.709860745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luís Henriques <lhenriques@suse.de>

commit 78742d4d056df7d2fad241c90185d281bf924844 upstream.

The ext4_msg() function adds a new line to the message.  Remove extra '\n'
from call to ext4_msg() in ext4_orphan_cleanup().

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Link: https://lore.kernel.org/r/20221011155758.15287-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -412,7 +412,7 @@ void ext4_orphan_cleanup(struct super_bl
 		/* don't clear list on RO mount w/ errors */
 		if (es->s_last_orphan && !(s_flags & SB_RDONLY)) {
 			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
-				  "clearing orphan list.\n");
+				  "clearing orphan list.");
 			es->s_last_orphan = 0;
 		}
 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");


