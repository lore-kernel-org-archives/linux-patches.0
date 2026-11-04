Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831588;
	b=5WndGChw5r9v52jlt0VPmpIvRfelWtFaJbcozSfei2l8r6qwZrEp+YFd/aBSwbainIQZ
	 DYoyaq8lsLlFSSgE7PgtaWTfUNdCAJec6RTRW6YYmR6/XxtqmETSX9AASIiey+0qGo/iC
	 vhcNAiO1fkht3m1FNR2u6dS5gkdjHMaXzCbPoZNYPfgZdFddUGiSC4w3s8eCajS30AQqs
	 ftAv5rjgzarIWeWeLCuXWzxxrxnDWd7F00lNxmmhO+T3H0uZ6O7ZVRgYs9TFrNzU72spU
	 BMfyZXUfo3N2DIotWrqYav3HP7Co53MtMCE2B6tR1fBlDptnrpWVgMyNMFh9/JZZXVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XMqCvdzgHoTppuDRBzaoowtEk035hNEW/FmbtP2B+84=;
	b=XCIEF5o2CLXtSpkTEq+qYEU7rkFxucIlMpwQvwgcEJKrubWpYSQ6MsGD0ak6SOP4mxqv
	 Lg74RG07TXEhnzyz4cSFDPcFL0HwCSoZXcfaENwExc4TNZWqyGM7XgZYGlWl8mwPO/6eQ
	 GM4B8EAp9s0I1YwT8FpWV7XgmG2b7LrXOVzAZQ5QvEYiKjI0fJK+SHoJPXeND7lMEbMo9
	 TcXUJWGfxh7o3q+bRj/66xq7tfKdMoPcOMa9tWH2270UO3jNkv3ZkuQIYKVS1B2mTbYkI
	 jWX38DccV69oCoVOZdOGoYyS23GNW6TLGqc78C/rvnag9Buxrylao01+mJc2BrEnC8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVHWbFD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F772606A844;
	Wed,  4 Nov 2026 22:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVHWbFD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BECF1F00919;
	Wed,  4 Nov 2026 22:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831588;
	bh=XMqCvdzgHoTppuDRBzaoowtEk035hNEW/FmbtP2B+84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVHWbFD+PXnjN6LzB3vivdv3h3PBMiJH+ofdS7sxDaS0/dcRSXl6i6Je4NaicwSLj
	 efNJEJ1d0MZv74KJ+1iHjqnYdM6/bFb4NljJhdJXbACizSR7pEPMYPxPP71keIR72a
	 klPR6YdqyCUQjjcdnQmw6YikH55eoMptG5b/P640=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0793/1005] xfs: dont proceed with xattr repair if the live update fails
Date: Wed,  4 Nov 2026 16:08:46 -0500
Message-ID: <20261104211105.556783071@linuxfoundation.org>
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

commit 833f98b3be45bc7c6ce4c87bdc4892f546ab72ee upstream.

LOLLM observes that we ought to make one last check for failed live
updates before replacing the xattr structure.  Let's be cautious here.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1477,6 +1477,9 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
+	if (rx->live_update_aborted)
+		return -EIO;
+
 	/*
 	 * Exchange the blocks mapped by the tempfile's attr fork with the file
 	 * being repaired.  The old attr blocks will then be attached to the


