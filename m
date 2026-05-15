Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CC42949E0;
	Fri, 15 May 2026 16:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862747; cv=none; b=O0GeuWbHS9b1n0yUWmb3Au5nfv/aY11PvNiCIDerLlD4jldsOd41ATfUUSuyEbp0Oqb/vIxTKiTplvHtHm015NaDVUG2IF35DyxSLA/+7eSsFVaVX0iGUTzpvrNuKLayoFoG0uqKOaWkLM7dHCTgZbHOiOiVpbgr8imgaxy1CYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862747; c=relaxed/simple;
	bh=/pz5Gb89TMFY/nu2z9kfQrlEiMwmNIpOTS6cvT6gKXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhM70hGdfRS07eESsxP+qYsARbl9ODuLK/gcR+UOc+wN9g77QouhkqRmpZ8BHj5iDJUIkY10RLpTgclUAUTm8gjDAqwcmD3GSzNPL2ltk7qgKDmJInWdLpPK6jRbwobPzip84PdzDZ1Ovoefp1VZTM/x98gk7m4LLlSwDmLrFIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo+D1zh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo+D1zh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1475C2BCB3;
	Fri, 15 May 2026 16:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862747;
	bh=/pz5Gb89TMFY/nu2z9kfQrlEiMwmNIpOTS6cvT6gKXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo+D1zh2uZM0vEiGsElFOBcQcPsE+IEomIZRZkbjmpB1gFN7P4YL/GKogDM2q2gtb
	 tmEVi4RkoGaYq5tHuIVnfa/i5LzWXMWQHi+AJ+kEH6gyWnbQHDHzGSi/Oc8Ur3saOd
	 WPyOKCBPCDhWwoESk3zigxW+Z51mU9k8kNgKdGHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 166/201] drm/amdgpu/pm: add missing revision check for CI
Date: Fri, 15 May 2026 17:49:44 +0200
Message-ID: <20260515154702.173081342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2a561b361b7681509710f3cfc3d95d54c87ac69f upstream.

The ci_populate_all_memory_levels() workaround only
applies to revision 0 SKUs.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1db15ba8f72f400bbad8ae0ce24fafc43429d4bd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1326,8 +1326,9 @@ static int ci_populate_all_memory_levels
 
 	dev_id = adev->pdev->device;
 
-	if ((dpm_table->mclk_table.count >= 2)
-		&& ((dev_id == 0x67B0) ||  (dev_id == 0x67B1))) {
+	if ((dpm_table->mclk_table.count >= 2) &&
+	    ((dev_id == 0x67B0) ||  (dev_id == 0x67B1)) &&
+	    (adev->pdev->revision == 0)) {
 		smu_data->smc_state_table.MemoryLevel[1].MinVddci =
 				smu_data->smc_state_table.MemoryLevel[0].MinVddci;
 		smu_data->smc_state_table.MemoryLevel[1].MinMvdd =


