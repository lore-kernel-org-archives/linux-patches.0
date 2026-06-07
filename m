Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7DA3382C8;
	Sun,  7 Jun 2026 11:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830210; cv=none; b=Ijv1hTwyDtkdGUGobxBLieJ9tdhMSJkZnZFV9ck5pheUlCIeMiZguH68OOmSEnFGmbAC/5qQLBf6XgKyeUhaMDg+Zc2RveroL/Hof07mXsYgNGtB3XY2y2h4gOjQ646khQTzapQvkpslFYyMN430dLYwwj/6pXoitRc8tQUm56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830210; c=relaxed/simple;
	bh=Yj/3rwJRWE8Szh9Muv7MWm4ELfhb52z8tb1d32BBLw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPN95SYUpkta9p9JH1qPYJgtaM1t7gipD6kCZCZdzdjCTNJro+zLG6X3HllBGeTgGZYBpkqs6qxT8fvi2+ofGblrSgjsqDO0ZUMaCX6SZNLtGL2a3JHu1swH1tZdzavSr5xhJmXRAZzBWFCbN9+66y4fJhfxeffFsDoKFZr1/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkuS9aUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkuS9aUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1440D1F00898;
	Sun,  7 Jun 2026 11:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830209;
	bh=QRlkKQYIqsfO+LLNOQlxSO5uVtH6nc+xnJRiujkHeu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkuS9aUnUv/cn1egVETJ1sZbPN5z9X2qaoEvc27avW5cpvf1VSyPcRCb8I2GkKnf9
	 fMBjtrQ69t4lr0lyzis1QWsvT+xWx9unYDYQRGwB2MGd9QaM1uG36fgTN0jkuaN0/6
	 0OEM/aKWYmWInCMr8FthnpMULJrfIGZHSC62cU/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ye <liuye@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/307] mm/memfd: fix spelling and grammatical issues
Date: Sun,  7 Jun 2026 12:01:43 +0200
Message-ID: <20260607095738.998125707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Liu Ye <liuye@kylinos.cn>

[ Upstream commit 33c9b01ed2fcbc101cdfeb497f4581e981e7c1e7 ]

The comment "If a private mapping then writability is irrelevant" contains
a typo.  It should be "If a private mapping then writability is
irrelevant".  The comment "SEAL_EXEC implys SEAL_WRITE, making W^X from
the start." contains a typo.  It should be "SEAL_EXEC implies SEAL_WRITE,
making W^X from the start."

Link: https://lkml.kernel.org/r/20250206060958.98010-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3b041514cb6e ("memfd: deny writeable mappings when implying SEAL_WRITE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -286,7 +286,7 @@ static int memfd_add_seals(struct file *
 	}
 
 	/*
-	 * SEAL_EXEC implys SEAL_WRITE, making W^X from the start.
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
 	 */
 	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
 		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
@@ -364,7 +364,7 @@ static int check_write_seal(unsigned lon
 	unsigned long vm_flags = *vm_flags_ptr;
 	unsigned long mask = vm_flags & (VM_SHARED | VM_WRITE);
 
-	/* If a private matting then writability is irrelevant. */
+	/* If a private mapping then writability is irrelevant. */
 	if (!(mask & VM_SHARED))
 		return 0;
 


