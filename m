Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057861;
	b=3brrPq+4O8QLu8f737APZgGcTNxw42M6SGTRBy+BSIbnkXQ48vZXZFhXdvTp+4lWZ6QS
	 +9EOJwk3URs/RdAcCzZjExlAlMJ/a7RGonIgxBn04KB6/pDZ9E24NrGFaDLRmNNwWfpQX
	 EQ5WgmEYXqoMuOVjdBzKFr19E+0nAFdf/WlBAGBOKAC4fodJJX6J+xTJkzbPBCpIfovlP
	 RwQAP/l5zgV89LmH5uT1zHtyDtErJOWuPKbyiQqHVEE0GlYtYb3FxiNDXexTK7XfjJZ8z
	 LWiNOLZs/clgv0BZqIxPtayZYm2uBB9OIIN2lunfrZI4nxn95ghFjkWsSslAd6YnPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ii3NFjZrSEk0tA3GuLr2dJVlIvqElseYYjFHLkeDJAA=;
	b=ztW+VTjlFSQAyOiJluVdaEetpGQb2h1alDKp7ohRHiUQ5isIDttSoV1CCtWiU6/GSzAM
	 yhi046DZGv/9QYEsG7Av+Zjhw0aVL7Yb78yjVc1mzj+tsGYp6XTCwqka+TsnZrF2camoq
	 lj1bBWV6oiMhAfFkEALdoiL7FTU+5z5jw4mvvcJ8souJPccYOEP7DBZprKRr1sPn6WKsH
	 V6SNED6qOwsgq8BF81imwucXByEHqvj/bDVzrxImhZMwzsu/FU0imGX7oDGpuK6QR1f9L
	 lSUTYTb5+XjlBmnRLrHu+wVGT9d4TrpDrHAN7JXP7A1zunzw9OB6x4IkjP/OjZ02t/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqirNRct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510EB606A32A;
	Thu, 19 Nov 2026 03:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqirNRct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33CF1F000C4;
	Thu, 19 Nov 2026 03:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057861;
	bh=ii3NFjZrSEk0tA3GuLr2dJVlIvqElseYYjFHLkeDJAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqirNRctbVHRcriUjy7o2YDVZBeToGGWhuvomaNG67uyYbeeEjEIaSO/2x2QfIu4t
	 5mu9HRcbKmSgN7lSkT0KHv4rMKShbL04JuvVdsmPC2rXKojnjxG1v30eKNmTJ7f3/e
	 ScvoNCmZOSe8givUVYicUfIZr53GsvFG3f5Nc0bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0281/1848] xfs: propagate errors while checking null siblings
Date: Wed, 18 Nov 2026 15:38:39 +0100
Message-ID: <20261118145923.960506232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit e5bde75a816b3549942f4b09a8bf09006b7ea9de upstream.

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -236,9 +236,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 


