Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE54C2054F8;
	Thu, 12 Dec 2024 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018650; cv=none; b=i0RESTlbVReAWccApIzoI/IIJlIGUJbPehNLCk4cjH1DN4wEpzqvx59LNBO4bMxtit2NjEnqsjH2vuQphDqK4KK9eCsKxmu15RZbZuxaJ7lFR/j2dolAk/a3cvQF9O0BSKIbPx6QgmSCzAJH4hBKH8zaDtQii4Lk5f0FUHpLfqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018650; c=relaxed/simple;
	bh=uf9cLLDGv0gVy6926nM18+ZjQwS03lqKqYLeKe3kc60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd3Pfn68zYNDUPne0tU4kXHTqy+m/bSrLufS9v0g18TaGn2T2+Z9WZvOXYt2XiMKgNiZCDB4TD3VYAHfOh9JSjnPqQXy73ocC2ggiZtsipTt5BnnKhDqLieOhDs/c8Q4R5ybTcYXV8iVRRz46fJS4iCGutObvb35N1VL8pYp6io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MA9X32RN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MA9X32RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D7EC4CECE;
	Thu, 12 Dec 2024 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018650;
	bh=uf9cLLDGv0gVy6926nM18+ZjQwS03lqKqYLeKe3kc60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MA9X32RNSVi59nsqBwmAyk/Gss/Jgvks3JWsHcKYDyHnKjMEIEPpx+xKyM3aYmlOp
	 IDsmmviETy+oh0C2XT7g6q6oUW3wYmNHS712bW44zkNOPaIxmdvLEsw8SG8Q1BlPAX
	 Yx09IcwO8fA3mjJlzGrGTIlWfyBMCU5uOV2eKJvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 350/356] net/smc: fix incorrect SMC-D link group matching logic
Date: Thu, 12 Dec 2024 16:01:09 +0100
Message-ID: <20241212144258.396560447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

commit c3dfcdb65ec1a4813ec1e0871c52c671ba9c71ac upstream.

The logic to determine if SMC-D link group matches is incorrect. The
correct logic should be that it only returns true when the GID is the
same, and the SMC-D device is the same and the extended GID is the same
(in the case of virtual ISM).

It can be fixed by adding brackets around the conditional (or ternary)
operator expression. But for better readability and maintainability, it
has been changed to an if-else statement.

Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Closes: https://lore.kernel.org/r/13579588-eb9d-4626-a063-c0b77ed80f11@linux.ibm.com
Fixes: b40584d14570 ("net/smc: compatible with 128-bits extended GID of virtual ISM device")
Link: https://lore.kernel.org/r/13579588-eb9d-4626-a063-c0b77ed80f11@linux.ibm.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://lore.kernel.org/r/20240125123916.77928-1-guwen@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1889,9 +1889,15 @@ static bool smcd_lgr_match(struct smc_li
 			   struct smcd_dev *smcismdev,
 			   struct smcd_gid *peer_gid)
 {
-	return lgr->peer_gid.gid == peer_gid->gid && lgr->smcd == smcismdev &&
-		smc_ism_is_virtual(smcismdev) ?
-		(lgr->peer_gid.gid_ext == peer_gid->gid_ext) : 1;
+	if (lgr->peer_gid.gid != peer_gid->gid ||
+	    lgr->smcd != smcismdev)
+		return false;
+
+	if (smc_ism_is_virtual(smcismdev) &&
+	    lgr->peer_gid.gid_ext != peer_gid->gid_ext)
+		return false;
+
+	return true;
 }
 
 /* create a new SMC connection (and a new link group if necessary) */


