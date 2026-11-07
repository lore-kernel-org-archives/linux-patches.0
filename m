Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061682;
	b=RpiT2Wv3cNaqS2Lz5EfgXZ5SxpMyChldsuVP6b8jcQHbdN0apkf1BHdVQ9d5YExivGkV
	 P+Rdgs7JbTsF5h2knAHtrRxneC9gpKUtnFLm1UAy/eKuYr2HZn4gIMytL7YkYDzWJCRay
	 mhpvyv6CeB4hUFl3aqrygKET8AMkCkyFqNTu00wSzXioLGWxJKU5KSDvp9YLyT4+ouFdl
	 e3iYbL8DkApGCToVRITDdSP7H0uNpUyT0I+adGEs9jr79ZkPgZTYd9F0hlB37qrCwQh3q
	 mKpeTJrvI5b7WzjkVp9813jqjI9PEqUmHaGrzc7RKNkOj4gxxjGv8dlpF8nSX4Zv8Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kkMFrhgv6Q+gB51aymxzd3Jm9Lfzl/HEoiA/O2AEPmU=;
	b=Gr7AwjVvu70avCrsyOrCKI9NGxZ+wZ6Pdd367PmVATZ5gfj+OFLVh0M9B5aco/XbQXfP
	 YSsulYAMr4kgo37YH1ijNI3nopu/ehwEhvAPd8PFfRvyXFOfq2xEBnShBWzEVXAIMUzjV
	 kVlbTzzeAmMkF4c+VINvgGnMTzrVKEhVSAb2ewSZkbzNN7kY3cn6bUeKKZjoxI7xC4tsb
	 1Mn3hrOuouWk1Ym6a/JxgodU93fbqYntoK3vQz0NRNdGt1CsGy+8AKIVxhWk1AJYduSOZ
	 8CHWaP66lShWAMnWaO4zLMUYaT14ChAnhAd2w2gYZ1Gvsh3h+k27+o49MMu3Z/cG70w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEuGq+mg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E90606A32D;
	Sat,  7 Nov 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEuGq+mg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857821F0089F;
	Sat,  7 Nov 2026 14:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061681;
	bh=kkMFrhgv6Q+gB51aymxzd3Jm9Lfzl/HEoiA/O2AEPmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEuGq+mgGhHUttFvXdUANxtGGSBo7mdEFs1IttZzZS/bRBJcDibyqNYD5gjV818gq
	 w+eU51AKau8ZECGDEjZylSg0b0rfId/1BOxkgXZTzUx0wJfYUv7lw+6KilkbZCnTyY
	 07Eg4Dd2C4nVYNEAg4dS1jouQcTBFOVTbNg3lGc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0733/1536] xfs: check for termination during rmap btree walk
Date: Sat,  7 Nov 2026 08:45:49 -0500
Message-ID: <20261107135018.099098390@linuxfoundation.org>
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

commit 1fc241cdeab276dc6c3ec14840faa706ed7712ff upstream.

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -228,7 +228,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {


