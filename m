Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2992F39C2;
	Wed,  8 Apr 2026 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674561; cv=none; b=rzaEAGbHk91ntt3R0cQHuP4pz6396n2+zrvPQjx+/xzbh+42tR/+rNAoEiTZ91hksIOpop4kYiHJbGxX6tmnKZ2gcFcR+VQLf3GJg3tILVfCic5/EnW4sHpeWWpQQuiNPrO3mr7ALlhmND2ovlEjYv0nrGCMMpU/69PSXO62sR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674561; c=relaxed/simple;
	bh=NRj2j4kMQr3Uc+g4TeHGvn8WPVBRB4YC7v8itj42n1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l51RQ3EXwGmLyKb+ZTv8GzUTsTp38tzmm6RlNIJga0q4rXs+Ceogv5ejSTmB3zIgpqwh53YTVwV0qufk99Upvp8RTG4y5ewYOZxJI8uJ5BNl0XqclCg2mtns3V0PR8LRqQBZXWX1uFDylqaXij46qRWTfktyfZRsHUct0TF/N64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoELR50v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoELR50v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D4C19421;
	Wed,  8 Apr 2026 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674561;
	bh=NRj2j4kMQr3Uc+g4TeHGvn8WPVBRB4YC7v8itj42n1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoELR50vYKRcRM14oqR/CIWU7I4lMzKDkl/ntQDEESk+t0C1sv6kBf1osWlQzQUeg
	 Lf1AiTEQngcDoHWzQwcF/FlkWVpCnAwyOjfR1f6MwdYkZXnbaNFPkTENnCXpo83q9D
	 hSD6Tsa7SNB9hjNWnDQC68u/UHhgzwqvpqaTjxcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 146/311] drm/xe/pxp: Remove incorrect handling of impossible state during suspend
Date: Wed,  8 Apr 2026 20:02:26 +0200
Message-ID: <20260408175944.863049985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 4fed244954c2dc9aafa333d08f66b14345225e03 ]

The default case of the PXP suspend switch is incorrectly exiting
without releasing the lock. However, this case is impossible to hit
because we're switching on an enum and all the valid enum values have
their own cases. Therefore, we can just get rid of the default case
and rely on the compiler to warn us if a new enum value is added and
we forget to add it to the switch.

Fixes: 51462211f4a9 ("drm/xe/pxp: add PXP PM support")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patch.msgid.link/20260324153718.3155504-8-daniele.ceraolospurio@intel.com
(cherry picked from commit f1b5a77fc9b6a90cd9a5e3db9d4c73ae1edfcfac)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pxp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pxp.c b/drivers/gpu/drm/xe/xe_pxp.c
index ba4d52001b853..fdcecc026e937 100644
--- a/drivers/gpu/drm/xe/xe_pxp.c
+++ b/drivers/gpu/drm/xe/xe_pxp.c
@@ -891,11 +891,6 @@ int xe_pxp_pm_suspend(struct xe_pxp *pxp)
 		pxp->key_instance++;
 		needs_queue_inval = true;
 		break;
-	default:
-		drm_err(&pxp->xe->drm, "unexpected state during PXP suspend: %u",
-			pxp->status);
-		ret = -EIO;
-		goto out;
 	}
 
 	/*
@@ -920,7 +915,6 @@ int xe_pxp_pm_suspend(struct xe_pxp *pxp)
 
 	pxp->last_suspend_key_instance = pxp->key_instance;
 
-out:
 	return ret;
 }
 
-- 
2.53.0



