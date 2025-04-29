Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F0F1C6B4;
	Tue, 29 Apr 2025 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946482; cv=none; b=bo5SLHBeOiCl/5KTu+fq8vAlJyfwUjIlMtOTHgDDETl28Xp7FGvPUsUZm5wWEIN2PDu1AmVwmNTuODuu7xq2DJij5T1HcVsI4YPSq4xXy4NMPBWwANBIiYs0+ZjbkVoIdGUBKf7hjJnBpVv7cmhf5T4XPQAdRSl7XOecBUGGuOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946482; c=relaxed/simple;
	bh=Xb9LsUnChG4R2FBg8sN/zVNtdMWLlSj550pwUeYPOic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InCk4lXqDHXXb6eeWAoNZPMJEujOoUFO1wR5xLkPIyBuBsJFzXqy8vdMoAQmtTjJmrJQu7xNimm6LuncuzXCbRiXd6nHaJqY4fw7NlSJSoALo+arDBlsJ8Fgjrkk5vZ+MuNybmV/LsDLGHl/ZBoCWP0j7iV9MpyB7z5Zd81IKic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROeoLn4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROeoLn4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFEBC4CEE3;
	Tue, 29 Apr 2025 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946482;
	bh=Xb9LsUnChG4R2FBg8sN/zVNtdMWLlSj550pwUeYPOic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROeoLn4VbCZTHu4a5CZTvVFrv87kZ8OCAAU2Te+FFo9DtXl6p6g7vmT0Oui1apr1/
	 mk++NiEPwYwgEdrxrgxNmwl2Td90U/XFa69xP6W/8+Qj6nLtX2yIAH1BlK7IlEt414
	 oL451DoDWAjzXkMgJL4pwlRquk+LeRPGMuD/051s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 252/311] drm/xe/xe3lpg: Apply Wa_14022293748, Wa_22019794406
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161131.350987779@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Filipchuk <julia.filipchuk@intel.com>

[ Upstream commit 00e0ae4f1f872800413c819f8a2a909dc29cdc35 ]

Extend Wa_14022293748, Wa_22019794406 to Xe3_LPG

Signed-off-by: Julia Filipchuk <julia.filipchuk@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250325224310.1455499-1-julia.filipchuk@intel.com
(cherry picked from commit 32af900f2c6b1846fd3ede8ad36dd180d7e4ae70)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 40438c3d9b723..32d3853b08ec8 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -30,8 +30,10 @@
 13011645652	GRAPHICS_VERSION(2004)
 14022293748	GRAPHICS_VERSION(2001)
 		GRAPHICS_VERSION(2004)
+		GRAPHICS_VERSION_RANGE(3000, 3001)
 22019794406	GRAPHICS_VERSION(2001)
 		GRAPHICS_VERSION(2004)
+		GRAPHICS_VERSION_RANGE(3000, 3001)
 22019338487	MEDIA_VERSION(2000)
 		GRAPHICS_VERSION(2001)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0), FUNC(xe_rtp_match_not_sriov_vf)
-- 
2.39.5



