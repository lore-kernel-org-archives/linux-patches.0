Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E515A853;
	Tue, 18 Jun 2024 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716739; cv=none; b=iWk1Vp9QEWl0PY8B1ny9Fl4eaFX6Q5eLOp7991u6I6rkktnb6/I2Ut8KHWnAtlh2NV3SC5S5VggEeC3DY+9bPrtu4aEbt1RKo9XTIqHmoA8Fd5Zei4ONUxaIdN9WHbvPt+8ys43c7hla2qwNCbzLA9Iz4WyrbJFvKHdmOInzsUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716739; c=relaxed/simple;
	bh=Az+rgOnDpBp0nt4pE5X8NIUwTvnLrSH2EaT6wx51Las=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEW9BZlT0PR00alg3YhnVI0ZIOcYHe0wEURh+HwnPlXCkZXi9kCOzZqdSaO8eTk1KaTBkXBtj7Z53ZxLDyIBblb1L7XgPNhd7ktyQslrLJp3/YWlW9Cu9+SsJOyhT/nrOnOPYfe+Y+tXTYQg2Ra6gzo3h4ktPiHMLOLonvIaD4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQ9IxnHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQ9IxnHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA02C3277B;
	Tue, 18 Jun 2024 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716738;
	bh=Az+rgOnDpBp0nt4pE5X8NIUwTvnLrSH2EaT6wx51Las=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQ9IxnHazAgF7etuk+NUYO0Cui+l3AYefsL4zdFyg7YACTNghiuyFZwZHgBT1Mj6n
	 ByWTDJppduk/jFPK4sr8kW69jZkt6zBZzzzIE/umZF/gpPZq5iCPgO9Oo7pBFme0LD
	 Rp5ekMRGM0AcLMJh38J5+H+4eOVJZZrCuYf1CDps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 746/770] nfsd: simplify test_bit return in NFSD_FILE_KEY_FULL comparator
Date: Tue, 18 Jun 2024 14:39:59 +0200
Message-ID: <20240618123436.064006118@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d69b8dbfd0866abc5ec84652cc1c10fc3d4d91ef ]

test_bit returns bool, so we can just compare the result of that to the
key->gc value without the "!!".

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 4ddc82b84f7c4..d61c8223082a4 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -188,7 +188,7 @@ static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
 			return 1;
 		if (!nfsd_match_cred(nf->nf_cred, key->cred))
 			return 1;
-		if (!!test_bit(NFSD_FILE_GC, &nf->nf_flags) != key->gc)
+		if (test_bit(NFSD_FILE_GC, &nf->nf_flags) != key->gc)
 			return 1;
 		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0)
 			return 1;
-- 
2.43.0



