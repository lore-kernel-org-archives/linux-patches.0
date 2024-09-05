Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B1155730;
	Thu,  5 Sep 2024 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529821; cv=none; b=usuBogUInMs33U043UouwN1PYmvnK6ptdxZIsTfhRQ1MC8QmVCRxfL0OlTRlVos4yYT2t1y97WFBs9j3yqX0o9pZnOwug4+Bs5sJ+ofNMsUoemRo0E7XcKVspbAVBvt5GW785xR2eBsDIYMrZ0bWqUmNb/WK9+Unf6hRKU96nM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529821; c=relaxed/simple;
	bh=rGkPr+Aql9NiJovt83Jq6Wg/apu45CKCUJ95Pf3drWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy26by/BBgfpbQDzhwO0sEBnLoalzEuAEsozM9FC0B46s0AbrcgkLEKszWftAE2gbSWG41JRadffPURcR6C/2FEykQ23IdCzQjpU8TxbzXO4lr51eq6Vj/78ym5Y6sZIuO/8Xa5cpp5KvZu607P3FilBsyG5KFrjeGYUZX6U2kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/pHGpqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/pHGpqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF0C4CEC7;
	Thu,  5 Sep 2024 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529821;
	bh=rGkPr+Aql9NiJovt83Jq6Wg/apu45CKCUJ95Pf3drWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/pHGpqVrMErrR7OcTgkeZI3vJOiZ92ta8WBjONE1c2lZOl3tvMNTcEkMLXK1Ab7G
	 zRPSOwwtR8LJlvbKU+3Q4qmh1/qCnaFk79hCby/QVyzqrDSAJBCTF14Ipsb1yiS4R+
	 tQjZfBI1TaRpc7vXzaJNkS2yVhiN9/MbvFiBTSqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 152/184] drm/xe: Check valid domain is passed in xe_force_wake_ref
Date: Thu,  5 Sep 2024 11:41:05 +0200
Message-ID: <20240905093738.273201027@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 35feb8dbbca627d118ccc1f2111841788c142703 ]

Assert domain is not XE_FORCEWAKE_ALL.

v2
- use domain != XE_FORCEWAKE_ALL (Michal)

v3
- Fix commit description.

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240607125741.1407331-2-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_force_wake.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_force_wake.h b/drivers/gpu/drm/xe/xe_force_wake.h
index 8cbb04fe0ed9..a2577672f4e3 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.h
+++ b/drivers/gpu/drm/xe/xe_force_wake.h
@@ -24,7 +24,7 @@ static inline int
 xe_force_wake_ref(struct xe_force_wake *fw,
 		  enum xe_force_wake_domains domain)
 {
-	xe_gt_assert(fw->gt, domain);
+	xe_gt_assert(fw->gt, domain != XE_FORCEWAKE_ALL);
 	return fw->domains[ffs(domain) - 1].ref;
 }
 
-- 
2.43.0



