Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061638;
	b=hzNSm0/fZxf9noiOeE/BB1T3LzQTYf5U51L17eF/3ae6Y+ZA2bcC5+mX26y5rUdNKyFn
	 GtY+sxqdnKJZQv6bGnPo3KKXWojDXs8VzUlBlXr8JyZ2RvRpasHnQ3hJbbXru1Mw3560O
	 w587MNL705Tka/Hz4v8hz2MrNfHVKXvNqb3dXTv2E6jfX27O/9bA+/Ge6QsTJns3EQkwb
	 8+vBK2pukXarNAHwKUG9KmgQhoYknH/4JO7l+o6kAOF9UxtbAikQ45kunddQh2vCrhJt0
	 ngk7ob02PMUYoNlQtZ2UFX2UMGUkSq5/5ERKOqab88rs1Ck/FCQhHIvLB0HrTjbtQ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LbIqFpRWIGh+mitvNuipgxUf4UeYsg2T3nUcKtNGnps=;
	b=OLsteBZsM2m27zCAyMKp71a0uejIenFrLaDPUFb0aCSzrpC7ZvUhOCQZN0FAcCFOZAYB
	 Pmr5zeL0TWjHp8DnJtU1dN+EKa3iIVzdpmplDTULydKZNdz+pc6YSESROHEOOAT3n4Dtr
	 hGy9ySK4oS9g9S0p/GycFztQfW869tQJV36xRN9szVeigGc6gc3/pGplxi/izvxraohVK
	 nukNmZShUG4pDjAOYivLG4iHHC/QpGKZKpmbwt82kaPuUUSB1jp5mNGRfiwWiI26hyTwz
	 QeTqxmt3aacKkcFmM68RvCqapil333XsPhCA+DPOWLLycRbhDWxzIeWw7WulLNuD7Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OA+ZaAgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09800606A32D;
	Sat,  7 Nov 2026 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OA+ZaAgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF871F0089F;
	Sat,  7 Nov 2026 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061637;
	bh=LbIqFpRWIGh+mitvNuipgxUf4UeYsg2T3nUcKtNGnps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA+ZaAgBABCWPdPZ7Oo9/N/tx9Zsee5GBWK7N5P2spVLtInnMxiMJYGc/nJHWJhcG
	 mxoCBb+rPXsfAc/BdtTwR8xhaMdPXd986a/TdHa4Y22XZRlwxLSlhUfEMc/X2lqlpc
	 g2Al1a4z3kgQua/+d9ZFNX5U5yCSD+DpWxdf1ZCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0699/1536] xfs: dont pass iget failures up when marking ondisk inodes
Date: Sat,  7 Nov 2026 08:45:15 -0500
Message-ID: <20261107135017.125187336@linuxfoundation.org>
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

commit 7f5e8bf335e5e257fb82cf5b3521980ded60e863 upstream.

LOLLM observes a couple of problems with this callsite -- an ENOMEM
return is completely ignored and a subsequent run through the loop body
obliterates the return value completely.  Also, an error value
indicating that the list is corrupt can get passed up (thus terminating
the repair) even though we can handle corrupt lists.  Fix the callsite
not to have these problems.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1323,8 +1323,12 @@ xrep_iunlink_mark_ondisk_rec(
 				XFS_AGINO_TO_INO(mp, sc->sa.pag->pag_agno,
 						 agino),
 				&ip);
-		if (error)
+		if (error == -ENOMEM)
+			return error;
+		if (error) {
+			error = 0;
 			continue;
+		}
 
 		trace_xrep_iunlink_reload_ondisk(ip);
 


