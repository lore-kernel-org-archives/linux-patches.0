Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831607;
	b=aM23mxlbXad+0H1M/q7ss+eA18P/rHeHJBYKYZZXyceKaChlSrF6Axd8i6BRMB9bOl01
	 q7BJZaFB8y2KrFIC3qTRqX0vbC8x3ngnFpVySVNIX2cO/vneLzFKlQ2RYsKq+TszmS21y
	 /sfvZJRo52CqXivMKSesdij5aLNWMBARQMpPPZum7nL5JYXk/V0stt4SREw/vBQ3vItT4
	 DVmyyNQajX6FW991/7QfQR5Z/qRpDHYD6YaNK4bENjxw+1pIzhqfTlrRvJVqAOGitSAsQ
	 2VmvdhCGbYBVUwzCEeILtTq2uJygcXBn3Cz0VFWNzcnyC/wLJq3ANG75kcd0rV1nKmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWWufKAt0ALubScIViFzeO2CkSZuykpdgY8vIPET5PU=;
	b=egFFnZryYM4swGyh172RqDECVkzwEaLvhE/xI5TQCms2MFFYnv7/LOT06RCEEnPAa9zn
	 aadFcdmhzCTs8nC09inbV0DKNXOwc+gGkgdipTZ1admVxYyH74vqseroJ12J/NSaQ4gc+
	 Vt/v4A32R6irpewQxmJFI8Rzj/gdonM3kIqD8mgS4EvO2rVSOgVX51fqBY3kNSdyp7Kno
	 yXi3RFSrs943ZClJk4BSUBnhDfOTadNq1coLrqM4bZ54JPgix3knfN8Na5ty7y7W0Wpmv
	 2tB9cGWI5ouVxkTyVP4vKGHfRnkt5r/Lro7WVM3z4lFMVSQUszmfTj5TT/PpPH8T3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wR+jRyMU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D81606A843;
	Wed,  4 Nov 2026 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wR+jRyMU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6CD1F000C1;
	Wed,  4 Nov 2026 22:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831607;
	bh=pWWufKAt0ALubScIViFzeO2CkSZuykpdgY8vIPET5PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wR+jRyMUAY80q3mjDXQ8GI8zpw+vab9Ue3i5MohvT59qXBS0pAeqcdyPHoa/da3LF
	 NPu9eLiRG3gJnbD5FmAgtY5ZUUhHMIgxeDvVAymKrY7mjmE3fsd3lb0v+gy7WyTlsX
	 QspolC/9DlfFdUwsWQyWUHQ4fdlI0H2LsqwmIbNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0807/1005] xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
Date: Wed,  4 Nov 2026 16:09:00 -0500
Message-ID: <20261104211105.959412473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 436ae68743a6974021fefa21fd3093d9bf8e66e4 upstream.

LOLLM noticed that xrep_dinode_check_dfork doesn't require that the
inode has the METADATA flag set in flags2.  Add that check.

Cc: stable@vger.kernel.org # v6.14
Fixes: 702c90f4516223 ("xfs: support file data forks containing metadata btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1014,6 +1014,11 @@ xrep_dinode_bad_metabt_fork(
 	if (whichfork != XFS_DATA_FORK)
 		return true;
 
+	if (!xfs_has_metadir(sc->mp))
+		return true;
+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+		return true;
+
 	switch (be16_to_cpu(dip->di_metatype)) {
 	case XFS_METAFILE_RTRMAP:
 		return xrep_dinode_bad_rtrmapbt_fork(sc, dip, dfork_size);


