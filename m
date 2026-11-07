Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061641;
	b=ba1Sjj9Rw+gQx9491mLPxSgNCt0D6Kmg9UKgTCNpEqezidMYxvboxR/xnpE4DFi5lJHV
	 eMG9oaQTA18B42X9XGqRhDhNdyK3ScuD9WUuVlKh9sU5eU5veWBucFbtWfxKkh15fBRhV
	 /Ke/VMzOWuzol7uYhWTgYDONw6HrNKL0s/jGY33BBRcdAanFqRsSNWfGC/vFVsP6h2iUE
	 gK76NvKj4AlkbFTh//1XgL4Czan303ftLfII6T9KdzsfkuQmsOXHOpeklRy2MSGMpNgni
	 1ljUF4cq6nwvPxe1SlKvtMaRFlxlslb0O/X9THBoiZkUkmVJ+F+kS7wGYjZWu1fawAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+WHcsx/JTkUhqu5/O/gmTorT164usPDMlUtUkmzfDds=;
	b=zoNFc5WoWnBnlVli+RhKUOGEzM3rdc6Bghe5QmOkhTMVIiLG1QKuoKpWLNx0nCAOR3vl
	 qeYHxl3UFiS6MDVfEcNhD5JyHENqQFqb2hbnzV2xOBkoaqkasoKQ2E3ElBzaK9jq8zyII
	 7a4c87RssGhAg4NPwOKCwa9uO3/U9cK+1B3ydC/cNg60pHP7M8FwUvtizImhFxuVbwEyM
	 vMU33rbemvU+yHS7wIZmJyeaNm5upVUP4qQ8jaR68tWEZ6cIMssN7PGSsmgBQDB+z+hNt
	 KM1yh9pJ9vHoIuja8t7rcTtm7Qq/eWr4X6EA4FkCCubmFWFTuZEyQAPTtTQUQbSBomQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxMM11jA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2D606A32D;
	Sat,  7 Nov 2026 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxMM11jA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211901F0089F;
	Sat,  7 Nov 2026 14:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061640;
	bh=+WHcsx/JTkUhqu5/O/gmTorT164usPDMlUtUkmzfDds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxMM11jAQnZgc+cwXhkXpFsGEXop2rffZqSKwoI/3ZiaRbsDyc8ysFL8xkXCWk7vx
	 ixRVbbb67lJ45ikSvtXztQyy/RAL0dC9u6ZphUwbvfUlgDoIXhkO1gLOG4mHJ4hsCt
	 uN+01CCBYP5a75A4pHQDSwChJDekVABwN+Wt6qUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0700/1536] xfs: dont fix the directory tree if live update fails
Date: Sat,  7 Nov 2026 08:45:16 -0500
Message-ID: <20261107135017.153976579@linuxfoundation.org>
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

commit c8226f3d1a7eafe472addc232689e9c9a0c36a1c upstream.

LOLLM complains that we don't double-check dl->aborted one last time to
before committing repairs to the filesystem.  This is important because
the live update handler could have set ->aborted if it encountered a
runtime error.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -427,6 +427,11 @@ again:
 		error = -ESTALE;
 		goto out_trans_cancel;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans_cancel;
+	}
 	xrep_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETING);
 	mutex_unlock(&dl->lock);
 


