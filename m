Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D81898F2;
	Tue, 30 Jul 2024 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357101; cv=none; b=HUJ6wINzgeVuVgI4dR2F+XVrt1JaSgL5WrXS16mLnzORY5VNC3WTEpay04BMIRE2jg+b+2wXjmSrOw95OXNqKPZVcQetcWg62xUrgx/SrKCKV59pYRhvOh0GWs9/qWXKtsRpz/m5Ahs2dYB9RRhxSSCzcZWyb4KhTiyylaL+a/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357101; c=relaxed/simple;
	bh=lB5EGpGPw7vA5X5uJt6kxpR83BHH32tJal0efzDQ9a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEYCMfDEt7DMLOCuyWSPe7eh5KmL5aXuWnXzQ/tWRDQEQ38N2qlyA15vW9nVWAMlShfLRUybLyDM5oVOTYfdQmLSCa4BmoKyOczTzO0Oa5ebi319eTb+WwjDcOqj+TBdu74uB2bq0bbZTDFyOBQHw4ignHkxUPmhOx3MH1vet8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFceg9yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFceg9yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B454AC4AF0F;
	Tue, 30 Jul 2024 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357101;
	bh=lB5EGpGPw7vA5X5uJt6kxpR83BHH32tJal0efzDQ9a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFceg9yb7qQOKyC0O3YnBOPRn5bX+agGc0RkFilVEMqAbJNJDJ73ZvkeAtDZ3MSHb
	 5qL4ArYeZJjgmbej62atI6IZYzHNKvqyHsqVRKN4oEClBYoR8wSe8GaXoJMmSpiVUD
	 h95iGy4oPFLGnqyobUfkaQSBuz9kuORgaK++uBhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 218/809] xfrm: Export symbol xfrm_dev_state_delete.
Date: Tue, 30 Jul 2024 17:41:34 +0200
Message-ID: <20240730151733.217272570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d531d2a1fae28..936f9348e5f63 100644
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



