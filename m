Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035337;
	b=xHZeOWrChGuUXPn8oJv/tMY9EVDujcdaVrFDEJTOcFZoLxistNzyK3LZq9HDSPqHqk3s
	 vwvzKEEtq7HcLyvClt5K2qLBlY6evFeV3k2lzYBuPMD6rgvD1uFIa26Ammqk89SL8y1Qg
	 oDZ89G4lA9FR+BvD+pGVO5ixVazE3IypHfQQZu2Ll9YL9v9q5/Jz0lSW8BbfvDl3XoJSi
	 EUF2i4xBtpxHwGWWnvbir9/p8Z9BEUMv7YPHpJKQL8dj3wmcnVTVkhozsr5FnkdI/pjRG
	 2jWw/7+7Uc2Q9xQb1GiknklMOcYh9+iJmS4OUBfsMpUrcnPyghvObJlVqOeLTEEZQLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0mGquHD834CRRuMcpsuK78pLYzMrmrxUAIsF0lPvDY=;
	b=BOpWOd3ip/Jj4QkHnD0b46KFLUHqYgr4wBf4zr313kOXHWmpeXaYKg1qVrRO847QVCaU
	 gXBWu523S/79J6p6juCLKVHg0u99wnezsyGwWgF5ycDM9IeP604y2gg8mb81G3rRg3hfv
	 zsGCOsxydu3g5k3FgZxAc6pNxCHUGJ4wpqSQ2A0WES7Eqws60uHXQQyGn049YtMSbIiGD
	 Fu0FxMtLpkQVK5BpA97abNg8/ts4skA3/eAGnVxJx8FFaONx02MTxJhtFUKGp82XQUfkD
	 +NYG54EAM2kKi05yqJB8ZvsE79n2DU6arFmrhYN2hHxGMzINTYvvmgR+NB3s3KFInwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2zKNcMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA9F606A31C;
	Wed, 18 Nov 2026 20:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2zKNcMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142E81F000C4;
	Wed, 18 Nov 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035337;
	bh=+0mGquHD834CRRuMcpsuK78pLYzMrmrxUAIsF0lPvDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2zKNcMcB3k+dHJE1V2osa4pLVDSTYlIJsBTYpvXy0aKz7Ef5adHzkOgsLZu7i78i
	 DNagOFLFSTBRVXWIc778zW7dEbUvIA7dGD1DlVNU+vgbBkGO8Hr76uzkVJE9kBNTTD
	 jsE36Fg7O6o7Smw+EY7sUAd1KOgnEYYUINqPlAuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0668/3318] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed, 18 Nov 2026 15:21:30 +0100
Message-ID: <20261118150338.148949009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 15ccd92a782a0253f4a17895f3d3f71e5c1d1973 upstream.

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -295,6 +295,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


