Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3471DED47;
	Tue,  8 Oct 2024 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392814; cv=none; b=XUmZhRDcehwz5czJ4qpkNo1QtlQr75iy7pnzylYP17mjeEXX/9VZAR5ZCnz6xbW64NqVSrNZTmCMDqQdVmphJNWECoa6B7r+qBrMk9ZXmb7AjsFbjzHDUWilZ8lXLLiEHM/Nq+kL4xmyfFv1qcpEIlTtrffLg/hvrayjk7i0Eig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392814; c=relaxed/simple;
	bh=ipgYlM12fLo7XqoVCNqqFxVK7MFvodUh+bU+C8XWQ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT2nhy/a4XsroqcxL0vvTDkMdHi+c3jK+9+vBYGAI6frg/Gmn+1g8wFwLllfjdXHymHIbEWVPBxa30XHfF8Hz92+hVTkLiCqlDpTHru9u5hqjLZ25/hdv8t2F87o7p19YjKF2VrUccyxrZ8OZHWKR1MlkGn516wWzZ3hduzGRao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+uiH3k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+uiH3k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A6DC4CEC7;
	Tue,  8 Oct 2024 13:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392813;
	bh=ipgYlM12fLo7XqoVCNqqFxVK7MFvodUh+bU+C8XWQ5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+uiH3k+qX2E4W04mpGObPb1WMGn59iRV2sg5DtvSfiHPmP5Pu9dIz1FlasvGTLo7
	 mucBqfsH28FZXNqDEdCCkrdWpJhKaFvDT6hC25OcOUPH2pUgRJBIC7+zQj3vjcJWeI
	 69zn1u7GGn6241nJ77i6nyQO/4KQaZRgB2hM/85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 527/558] drm/amd/display: update DML2 policy EnhancedPrefetchScheduleAccelerationFinal DCN35
Date: Tue,  8 Oct 2024 14:09:17 +0200
Message-ID: <20241008115722.966598310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

commit 0d5e5e8a0aa49ea2163abf128da3b509a6c58286 upstream.

[WHY & HOW]
Mismatch in DCN35 DML2 cause bw validation failed to acquire unexpected DPP pipe to cause
grey screen and system hang. Remove EnhancedPrefetchScheduleAccelerationFinal value override
to match HW spec.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dad21f910fcea2bdcff4af46159101d7f9cd8ba)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_policy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_policy.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_policy.c
@@ -303,7 +303,6 @@ void build_unoptimized_policy_settings(e
 	if (project == dml_project_dcn35 ||
 		project == dml_project_dcn351) {
 		policy->DCCProgrammingAssumesScanDirectionUnknownFinal = false;
-		policy->EnhancedPrefetchScheduleAccelerationFinal = 0;
 		policy->AllowForPStateChangeOrStutterInVBlankFinal = dml_prefetch_support_uclk_fclk_and_stutter_if_possible; /*new*/
 		policy->UseOnlyMaxPrefetchModes = 1;
 	}


