Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061633;
	b=GPiVDvqFERgcClcWyxUQ0JmHPpR30/fvs045TqFHwqoiDKAdFE3BKPh2WX+IrQQpli61
	 gub163mXwAbPuBs7J5ZyPXzCfJVcdLgP10WFnB5V9/8RyocoCFqY5z+evTvG/JNECQrqD
	 MzXquPIQfjookLunOn4mLELCBd4Iokw51aP+NiAH0mErIbZm3XcQfcBGl8pEdeqbKFn5K
	 85qiskq1iPrGM9iGKjx9qwSu84KipfTvYppN54NRWs8fD0sTuDkpk4CyEktdwBRwxRjVq
	 T9wAiXOyYzfcgEstXaTEL0W/ZY/RrgREFJZ1U/w+u4rNyQiYZLVqd7nUVAou3oRRasA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KiWXAzlvVjvj4N1sjEed986+RBIFoFxjiKyzq395GMc=;
	b=y+f3ODY86vYYrdjzwW1guxApt15potmqEkTbzROui3ZqaM7nh6q4pwLSMtr1UUkdvEa+
	 RCc4rclwy8W2IzloIjeCdKCC0IVIGx8U2s0Taqrpsr8CI4v54U+3EoTQX2bCFaCU8XohD
	 Hd2kSrJfgRzwpIfw8QsRtistOJM74z+6wzfWUzdfyb6jVs41GV5TTk5ETw+XYW/ChtCwk
	 JG9J1ZUNJa5KoFIRQ44zOTwqUUDQOiToBf9Aud1Xzmj0zh1uWQyJUySCGis/ZMrfD84g+
	 P1BxOWX27EDt59F91y2NTiI3IoZEyFHwHDhugMdB8ro3HSMRr+r2a0Vf94wLZthvhdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMekdGXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD28606A326;
	Sat,  7 Nov 2026 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMekdGXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006B31F0089F;
	Sat,  7 Nov 2026 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061632;
	bh=KiWXAzlvVjvj4N1sjEed986+RBIFoFxjiKyzq395GMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMekdGXYTup50zATInK++cKux9hHYhCaIeHYYY0BJtgCO0Gf3LrHQkvlVRcJWvOwR
	 ag3nhohgVitXAexoS1VhCca4aKwiD1j/J5kRYBHTz3iCgLUbHXvV1/tBxXhOZxzHQY
	 iex0SLLWNN15tiYUn7i2MX+o4izCZZsADnzB+zyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0696/1536] xfs: actually report corrupt xattrs as XFAIL during cross-referencing
Date: Sat,  7 Nov 2026 08:45:12 -0500
Message-ID: <20261107135017.039736120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit b339cc253019518c61b8b150fb7ea727fdae59f4 upstream.

Some LLM reports that xchk_dir_parent_pointer really ought to report
xattr corruption errors as XFAIL (cross-referencing failed) when a
directory scrub tries to find the parent pointer for a dirent name.
Let's do that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 61b3f0df5c2358 ("xfs: check dirents have parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -147,6 +147,8 @@ xchk_dir_parent_pointer(
 			&sd->pptr_args);
 	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+	else
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error);
 
 	return 0;
 }


