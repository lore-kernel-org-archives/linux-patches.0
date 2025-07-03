Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A115442C;
	Thu,  3 Jul 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555363; cv=none; b=b4wXvICrSHjtFCCeS+mgdkFKqXPYyh+p7l8Ee7hn99jow9NlDckWW4fU7O5RDk0uNoaDEGhyrjGwqXP1wN7cLtUbNdkhTJb8Zrw8KRZfzUCdXkonEQIpLxjerUD0Vp8vSGSocWMyIdhByWo+/2CXp6scmG5hK4I8Q1tMRrm1JgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555363; c=relaxed/simple;
	bh=nnBT51rKHl0Zceea4Tnzu9l7VJDF5YmdG0PnyjnNVHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyClckyPps7A6ybPV7Xb52JHLG23gnjIigNDzPZzhtmdw5ZgdsLMjAO5wYIv+qVYrKDEmJTsjvytYOT1vvsoXthrU67FeL35LtKxAscFubYaBbdTKvzr3H/aJ5l4z4CoxQ2w16DTcPLu0AH10i+FN61LWhia4/4YpFJPAGwfuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1lnZZT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1lnZZT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80F7C4CEE3;
	Thu,  3 Jul 2025 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555363;
	bh=nnBT51rKHl0Zceea4Tnzu9l7VJDF5YmdG0PnyjnNVHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1lnZZT+OuCpY/ClaOB5DT+qdHoZHf1MFbihEHYEo1ATIW1VEtYn1G9XqBG8LIlaa
	 LUHA6baHDVXVCXxkuY9YXRj1MXSfca0CjPflgi5NbSUesnTfoG+RoFs9r6+0PbG280
	 KYsHghxs0rz+zWt6QKwXmrYzvAFB0DNuR5OyNezI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.15 226/263] drm/amd/display: Fix RMCM programming seq errors
Date: Thu,  3 Jul 2025 16:42:26 +0200
Message-ID: <20250703144013.448040340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

commit 158f9944ac05dafd2d3a23d0688e6cf40ef68b90 upstream.

[WHY & HOW]
Fix RMCM programming sequence errors and mapping issues to pass the RMCM
test.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 11baa4975025033547f45f5894087a0dda6efbb8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -4750,7 +4750,10 @@ static void calculate_tdlut_setting(
 	//the tdlut is fetched during the 2 row times of prefetch.
 	if (p->setup_for_tdlut) {
 		*p->tdlut_groups_per_2row_ub = (unsigned int)math_ceil2((double) *p->tdlut_bytes_per_frame / *p->tdlut_bytes_per_group, 1);
-		*p->tdlut_opt_time = (*p->tdlut_bytes_per_frame - p->cursor_buffer_size * 1024) / tdlut_drain_rate;
+		if (*p->tdlut_bytes_per_frame > p->cursor_buffer_size * 1024)
+			*p->tdlut_opt_time = (*p->tdlut_bytes_per_frame - p->cursor_buffer_size * 1024) / tdlut_drain_rate;
+		else
+			*p->tdlut_opt_time = 0;
 		*p->tdlut_drain_time = p->cursor_buffer_size * 1024 / tdlut_drain_rate;
 		*p->tdlut_bytes_to_deliver = (unsigned int) (p->cursor_buffer_size * 1024.0);
 	}


