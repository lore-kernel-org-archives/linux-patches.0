Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617895;
	b=qyrIDAODUaRcsp/yANPIGE81qCi7mZ+SsDlSuWwUSw4tbj4iicbxAi04Igmfpz+mS68X
	 lwoKg4h/8XsTHSEOmwSxn7rOMPeOHBXYc2puA6AsC3Bn4oWRsuURmRXF5KloU8fK/FKAn
	 Y0ZuIRkWglWmf84o3mGqkoHwcCEY5tcM99r3CRiiiFFR0BlkViV1pIoBt4k4P52FKpPWe
	 klnjXc8PFiEm0D6hibqpgt/K1sjtRSENoNXuNy7Z4sVdYCOcyx2d8AnwPgSxr0Za2wpql
	 HSUppN8bQWQSKE9+Aem/F24nrtgY/pt8mJt8ogdqfgM/jFjGMB0jOMcGD/fU5Ic2Hsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkSJl2H8OYeEbbJVSUQjtUnW0XqRBw6/KI5ov44gWNc=;
	b=pYmRYQ9nUq9jlPgRrFEvdXXOc2Lgi9pMo8WgOMNgJT3QJMyk8FbqazPse0RxBvtJiNQN
	 9/oj5Qqk4xnfafmPgV4eVqRk9S2w1evAsvJQU1wkWW0dM83sarjVcD8kXH+YTpiMcNlm+
	 4ij/LyDZnPRT5RU5pSychFeNbSWOrdgWghkC5HAqRv9ppe5zS94/yYtK+ROMEgvn8D3sM
	 Mcf6CE4I/2gcDLvIywT18qAtGFBuxAOT0AE+sCnKF3RplLCaxpm1f/KKGdIW9tdzKOgQr
	 Avo73nl6ZM0eoas1sWTP0M0mlmg5zx950tTMFV1PQSwFRyXUsRhwwvC85/sdfTuNpPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieJONT3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C76606A321;
	Wed, 25 Nov 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieJONT3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794F81F000E0;
	Wed, 25 Nov 2026 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617895;
	bh=OkSJl2H8OYeEbbJVSUQjtUnW0XqRBw6/KI5ov44gWNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieJONT3aPo9Tw3YQ5rBwz+xjaOIQ0y2w+Kil0QMsvIJ1UJvRrNMr3MKDDGai677CM
	 MmMVM5LvEeyJRUwLQxXfy6HJF2ySBMdDCCPsOunvJQdtHZv/8f6wGwX9i9lQ7Dn1Du
	 z9cEn3tnHwTI9ZWZjKVQJwn02ouTqbGQjgc3e0OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0072/1005] btrfs: scrub: fix lost error return value when scrubbing raid56 parity stripe
Date: Wed, 25 Nov 2026 15:23:30 +0100
Message-ID: <20261125143823.428356779@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 387d5be169e6644a41dd5865e6a01c9489e996e2 ]

If we find errors we are returning the value of 'ret', which has a value
of 0 from some previous function call that succeeded, instead of returning
an -EIO error. Fix this by returning -EIO instead of 'ret'.

Fixes: fab0c0f03cfd ("btrfs: introduce BTRFS_PATH_AUTO_RELEASE() helper")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 479c0e037015a..ba2e27cc53519 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2250,7 +2250,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 "scrub: unrepaired sectors detected, full stripe %llu data stripe %u errors %*pbl",
 				  full_stripe_start, i, stripe->nr_sectors,
 				  &error);
-			return ret;
+			return -EIO;
 		}
 		bitmap_or(&extent_bitmap, &extent_bitmap, &has_extent,
 			  stripe->nr_sectors);
-- 
2.53.0



