Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ACA18801C;
	Tue, 30 Jul 2024 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356405; cv=none; b=hHyVkGg1Re+AfBCpopUlSU0O3spl/PIhoapvn4+OzpyEAOIj5f+yKGYPr5seUqQpLfW8Z72tihFt/BH9xqQPrW41fjTYfzjHQXrmK83KJs7xmqLdLc8rsYOZ+idwOEgOTeot9wXZvGxz+bWFiQNqp0Oq91KtwgZjNGmxjtwG2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356405; c=relaxed/simple;
	bh=oz+XLSIGacZXkoeJVVUcpjOC1pX2YQuJA9Vavjupnc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk1RwEWjOsmk+YIPG7GVG6+AH0c3xcZPy3uwh5wjM1E9ceatFz9xnii1/iNbkutkNldrLVkuXLYBnc0Onp+8I1qtxRJ8cFq+Sz2j2GVQVezODkwPrWuIlE8cDiSXuP4mv16geaCVEoI/LFYgWrY+eRQPIDL/uPojKKs9VurWRGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUeIfART; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUeIfART"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519E2C32782;
	Tue, 30 Jul 2024 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356405;
	bh=oz+XLSIGacZXkoeJVVUcpjOC1pX2YQuJA9Vavjupnc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUeIfARTOKjh39I0W7mJyxFcEPNrLinXZGLe5YTi1TYATdJN3ZAUjRtTDWrDHj7UT
	 8K6ShFhCX70yab3m2QDNNaoNwwtIK1G/EeNpQsJBFAyol2kvxm3J7BghQqqqyqWEba
	 Ck2nPo8FaaSZG+XNt3zVNAMtyEi8eyGGRvrVfRvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/568] xfrm: Export symbol xfrm_dev_state_delete.
Date: Tue, 30 Jul 2024 17:44:12 +0200
Message-ID: <20240730151645.545675691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 2d5317753e5f02a66e6d0afb9b25105d0beab1be ]

This fixes a build failure if xfrm_user is build as a module.

Fixes: 07b87f9eea0c ("xfrm: Fix unregister netdevice hang on hardware offload.")
Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index e5308bb75eea2..7692d587e59b8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -698,6 +698,7 @@ void xfrm_dev_state_delete(struct xfrm_state *x)
 		spin_unlock_bh(&xfrm_state_dev_gc_lock);
 	}
 }
+EXPORT_SYMBOL_GPL(xfrm_dev_state_delete);
 
 void xfrm_dev_state_free(struct xfrm_state *x)
 {
-- 
2.43.0



