Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061729;
	b=gHLjEluymNDZzLamIMrz7PNXxmVY9ZgVhB2/D/48ytfxsje9mScTtODod3b5ZpriD1jZ
	 Sk7TwSjmJr1H0boBndGZ4uIGpbclPBQAxxUFMi8pYvXP9P0wjvvJv096/XJMysHYi9FsD
	 zfqVQbJ5IEqJrOu1FpZKs4IFQlNRCxcCLcJyFRw/Fg/pMIVfeA0bqlpC8p2tZLZWo01JG
	 PrA5CtXrPjP0H5oKu/zSsIIElRtLcu4NLVYOrS18hitIFcdfLG7BYeZYXSgV8QpBN+wvk
	 6BMeD7sa6u7YaV9FZl41StX0jzQR4M+u/JlJeyYwzZ4E+s9pyfnEHMGbcH49egz6LdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NuMYdD0yZy7lefyAxmMdDJDQOlG+EUPo8mjUtdsWVQ=;
	b=yw74WV8qISsxSMLbfhcBmMku30F+mL5wL+OVvbGADXGBO1RneYshlq4R2quFH7YVkpfN
	 I1hRgq3InF8IdA6AVN1FJoHYZjK5fgRrP/Lj2NBDEril9+SzthxsDgH2EgtW6YT2RARr1
	 ursmMKjmK7Py7P5BxAtlxQkkemCP34S3eyyI52zgEyZ37+XBiyv4PIM3rLm0gBgVV8nT8
	 pB2dsfKOW+ndHsJCx4Uztfua8DBE25paemkr/H8cp+/9EfsF02a2dRlYz2piBqBcYcnFQ
	 7UNvJDKgyu/ZQIo0rPJBSPW5IPQsbNb2PyqohQW/rFo4uVDF4FVx7vV3uJwxzyRPK6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWwJ5atP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54969606A32F;
	Sat,  7 Nov 2026 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWwJ5atP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025EA1F008A1;
	Sat,  7 Nov 2026 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061729;
	bh=+NuMYdD0yZy7lefyAxmMdDJDQOlG+EUPo8mjUtdsWVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWwJ5atPggBr+uBZLmHYGLQRCAzGm9PZJsvGuVC5GYY7a/djIETHwQla9sFLn5IuP
	 RB8b5DnngQN1yF8qEBfCGP9sYwUdaG4Afaq7xe/utm9ICYMd8iELgdUbkN3te8MTv+
	 zhHf1H92V7D+ASlnJSNiC6kk6IhgpEgKtbWxiftE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0745/1536] xfs: propagate errors while checking null siblings
Date: Sat,  7 Nov 2026 08:46:01 -0500
Message-ID: <20261107135018.452892955@linuxfoundation.org>
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
@@ -257,9 +257,10 @@ xchk_da_btree_block_check_sibling(
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
 


