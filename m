Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA161F758C;
	Tue, 17 Dec 2024 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456002; cv=none; b=FL3ntqWpqYSPDCiggbsK6aBDr3zdiUXb+JaGYb47+2LDuJ8+p474Esvb27nRZXR51oKdblL0cHo4JubqYfzp3J27xYNrf0tdI8OaCKI1PA73RcaVO0P6XmX5aF0odRwWd/7Mi8UgDKOu+XGyg7VK3PGRHLuxd8cGMexcI4kq3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456002; c=relaxed/simple;
	bh=F9H8iZCf9WE6gkeQuO4iGeHXnRDN4JwZstc3fK/M+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rztEgYnkjwypY5xmkKI85fYLedmDNeUW+ApXdRuwIS4SZa1AK9Rxpy7FyYOoYe3fShsaanJm81uHQxc3Zr+W63OP4awD4MKjBs9jTwAWnBVYptPp4ydQWkTlRauxXoiB5E4uUwoZSFeniTBTc9p+Vt9+hlDiH+FzoJsDPwdaQds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbwYdbqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbwYdbqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0ECC4CED3;
	Tue, 17 Dec 2024 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456002;
	bh=F9H8iZCf9WE6gkeQuO4iGeHXnRDN4JwZstc3fK/M+C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbwYdbqyOUHyg4+j/C50xYX+3EcSCEvFx/n66wCysGTI/Dmuc34pHmN+S/rOQ5QHs
	 MnfzjWbcjiXRz/U27d4R6WIN6ziFQ59W8QPMcqs850UHZ7VbudirTSSSYC6pRS8Lc3
	 IODGO+nL/U4HeKJz0OsgjmydzwDA6FXpe/L35Yko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.6 027/109] xfs: fix scrub tracepoints when inode-rooted btrees are involved
Date: Tue, 17 Dec 2024 18:07:11 +0100
Message-ID: <20241217170534.517242559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Darrick J. Wong <djwong@kernel.org>

commit ffc3ea4f3c1cc83a86b7497b0c4b0aee7de5480d upstream.

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -506,7 +506,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;


