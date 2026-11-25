Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618909;
	b=2Rbbft6H/wBGOV+vk7GDdI8T5MsS0zMAiENRQ7fRHJ14I1P4besjFkZuSwucEZxsWgpI
	 GOTIZau5wL4lgbZq+mGjFS02oNS+K0EbwOnDJe2hLC4oNuCGFoUdvD7UrBFKrEzJys8a6
	 wUxC+NVW2qeh4tf5+aE/vZQeEoGIFp7IlQtn7RZlOq6STn85ECa8E3dlIvG54Qn9cqfUR
	 wvcBsSeb4f7bSCZhUxGMF7QgPDxvy0PWUIlHxZktF6lMx8bFZfE8O7NgNfzB3toOhsw+J
	 tUcmDWkt0PR5lkfokPG60lOSfa9eXNt6in2ygzeY7+tLYA0e2a5nnVYdunlBGsj1Qyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0SOBLM2Llf3IseQbq78DV56G2NgLZXg+k+WP9jPMEsY=;
	b=HBZF80PnR+8S1HJZyWflHght+oY0yyrSaxNWoAqXqipTSplDyvbPjSF44dptEJM4CLM1
	 6SMNIHS2CrGbdemtAJQ+rV8ajBgxXk4HPHeuA0IdFD+7wOcoJ0OgjAqT+kEq1OzgbwJzM
	 YT4DWDkVmASnoppsOz7VH5/S84MV/dVhoywOM8dFVEJhlIB0Wpi72OuxT3MICqmo3wFKE
	 05jW79HHtSZ7LhfJgkg/t546ODgXHEBHYG5u48173Qza4BMILAVS4cEZOoAYwXo0StOSF
	 1hC70ZgAkPzys1HSemdFK1YkOMIcHfMCOrxQ0qjbV+loGSnQRXear2yaz6pJGY64awA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqU4Oh7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7344606A321;
	Wed, 25 Nov 2026 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqU4Oh7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0D21F000F0;
	Wed, 25 Nov 2026 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618909;
	bh=0SOBLM2Llf3IseQbq78DV56G2NgLZXg+k+WP9jPMEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqU4Oh7FodGYiwAiwDeZ6poXjAg8WIarlnpsdoyVb46iArzmUeQk5hmdDL3K90Zd7
	 UaD5oAaXHOICNTefHtDPOGNPLvLheQB1p9/RmPpvSxNJInnYvkVToEjqR6VrF2oe3w
	 k7xv5HjKM1O1D39OWswWaILTkRhf/JerBDFHi5HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0427/1005] NFSv4.1: retain MDS I/O until both thresholds are met
Date: Wed, 25 Nov 2026 15:29:25 +0100
Message-ID: <20261125143831.755475595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit eab627dcd18a18a44a2cbee47df3058d3637ba0d ]

When both size and I/O thresholds are configured,
pnfs_within_mdsthreshold() uses size && io to decide whether to
keep I/O on the MDS. Both variables indicate an unmet threshold,
so reaching only one threshold returns false and may trigger
pNFS layout acquisition while the other threshold remains unmet.

Use logical OR instead of AND to stay with MDS I/O until both
thresholds are met, as recommended by RFC 8881 Section 5.12.6.
The new RFC contains the same threshold selection rule as RFC
5661 which is referenced in function comment.

Fixes: d23d61c8d351 ("NFSv4.1 test the mdsthreshold hint parameters")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 0d51be32b6380..ff85b82a1e222 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2071,7 +2071,7 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 		break;
 	}
 	if (size_set && io_set) {
-		if (size && io)
+		if (size || io)
 			ret = true;
 	} else if (size || io)
 		ret = true;
-- 
2.53.0



