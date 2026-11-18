Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051814;
	b=g71XpybVdU0TLsM0m1NbypXjJ4CbjOOQsg2Z3RqlHJiaoD3eTwkQcK8XyUUV+7glbgwt
	 eXKuEkwYseT8EJ4tjjQ5ynq3Y2Ytmeza6FHD2bQRjtInG06yqTEF18ZcX9ODD16lT6ulp
	 aMYi4qKItJ2JLO1p3rxZHQgPNj+GazuhQL56VjAqwZkXY8i+U0cm5Vdwbnlo5vHYCHOcQ
	 YgzEaCnI4k2lNrcT6BTbYv+PDbyYf7Xu1XqBNfp30R3lqp/x/y2BmaZ5kRS4Xpczljsfh
	 PwS34qCkPBG+wJnHaMMVM45audbZM9R7VqyGl6TvwworimRWLLif4VEqNJcZ8lDB6hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Quc+hMPeNkuP7Jrzu/FBDKufMUfxbbVaz2Sld2xWQx8=;
	b=FacqHmBB2Uvj4W7eRkNuydh3C8zdfTeReJaj1esz8Oy1GWFYY0f6mQHUfWNOAyCInyxG
	 YkoZr1xg7B8Uv769wYw5+3eD3gSBtlf6o5VVIi225HhHzbq6Xf/VuuEsH0+dobWKkDOKB
	 Cku7RccVfDRl6EBUvBv3HIyr+jpRJ1qGAPxWqqFR9jJej+5w6R/e+3bmQzxcYhJdsUJbh
	 4twYwVcGuipwvcwdi7dolBPg8YH0zhmGzlzMqSmTUvZaFpNy0VFJAsR91baWyaIGiK04x
	 nrgnQw5IWB2H/p59Kn9WfALgpjw8GqeAZm5S1kRjf2vnU6Yv3AQ+Stdk3rmlSklmqIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmH4K+V2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE7606A31C;
	Thu, 19 Nov 2026 01:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmH4K+V2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7031F000C4;
	Thu, 19 Nov 2026 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051813;
	bh=Quc+hMPeNkuP7Jrzu/FBDKufMUfxbbVaz2Sld2xWQx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmH4K+V2TNhpHd0jfy03TdkqjBb6PvV1hcawLi3QE2neq48jJN9J44pt/anJK3/A8
	 aqtv58eHQfCG4OmxbxwtFCZBVzL7XFIdJi4ro48Ym8ET1JXRF3gusRxAKZWXTlXYn3
	 m7NiXbTbiLsmXBBikCmKEz0ffn6eEqWj3vLjcveg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0341/2214] xfs: propagate errors while checking null siblings
Date: Wed, 18 Nov 2026 15:33:37 +0100
Message-ID: <20261118150024.285150185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


