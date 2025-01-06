Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A08260890;
	Mon,  6 Jan 2025 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177745; cv=none; b=a/gNfR9R/QmcW7E5ain09sgGjO/W8dxXK+S/Gb+3viuoJu2MImFMEchJZMJpldvKXzc4YN0t/iU3ZvC+vi/SMrDXeOhGY2SIwpk0hAQujnJP3ZJgvkRpn2Xx7m3J0T8fOM8rDOjZup+OwEAN2/MLWCRcVaY71bXC0OS6AjdFryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177745; c=relaxed/simple;
	bh=oYQlr4Q13UVpOno/aY0rmk9VBL5Mqra1cyi8WtPsL5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2Y92OWjciOlr2DXoW8WKYb0sGYtovV222VtID2Qo3ec/iY4VXMua2rg1aQfoxnnOO8V/3mkAIuTAG50vplb9twiYLd2cu8NA4aZsnSAUOnW8DpUCjkhKinNOH8Plt/2aB+bD+kKzh8m4aWeSUdO0wjq8vnlg6xcYHXL2F57Xrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aD2WEaqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aD2WEaqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83663C4CED2;
	Mon,  6 Jan 2025 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177744;
	bh=oYQlr4Q13UVpOno/aY0rmk9VBL5Mqra1cyi8WtPsL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aD2WEaqSOVU/sy9Or4Gld2B3NuhmQr7Dil8U8ZV1heOP56W8AOEHxnR6b5VSn/NgE
	 ll3ZoUzGSDB/Cc5oXS/xf8rrn1NQwsz+XyTwO/hxxx/5T5xtZWCLTmJsBUT/gfJzkX
	 +atLw6/4AEYyAxPIJYSgkSn4wuT+Tt9quqknqg0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/156] drm/xe/pf: Use correct function to check LMEM provisioning
Date: Mon,  6 Jan 2025 16:15:28 +0100
Message-ID: <20250106151143.320657737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit af12ba67d09ebe2b31ab997cea1a930864028562 ]

There is a typo in function call and instead of VF LMEM we were
looking at VF GGTT provisioning. Fix that.

Fixes: 234670cea9a2 ("drm/xe/pf: Skip fair VFs provisioning if already provisioned")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241216223253.819-1-michal.wajdeczko@intel.com
(cherry picked from commit a8d0aa0e7fcd20c9f1992688c0f0d07a68287403)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index afdb477ecf83..c9ed996b9cb0 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -2038,7 +2038,7 @@ static int pf_validate_vf_config(struct xe_gt *gt, unsigned int vfid)
 	valid_any = valid_any || (valid_ggtt && is_primary);
 
 	if (IS_DGFX(xe)) {
-		bool valid_lmem = pf_get_vf_config_ggtt(primary_gt, vfid);
+		bool valid_lmem = pf_get_vf_config_lmem(primary_gt, vfid);
 
 		valid_any = valid_any || (valid_lmem && is_primary);
 		valid_all = valid_all && valid_lmem;
-- 
2.39.5



