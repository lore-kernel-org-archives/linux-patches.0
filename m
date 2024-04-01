Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008E4C60C;
	Mon,  1 Apr 2024 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990443; cv=none; b=RubwpWXT94RkqJOtg2XnG/MPLqU1xu7M0XWYqITle2sIOdPU4Pdf95RRE4LTsJGJ32/nkXeyzNOC5w7Wlcs/UjyPlI17BtDM9kFRFCVO8s98MAZOqulZS57GkxVBJYkpavhK//unYAh4b1IogMAPx34VA7Crs6IISATvYGfmapo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990443; c=relaxed/simple;
	bh=DFh01i2s/ozI67DgPhoDj0W4jyAaveeqyAGehYibEgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnFliedBhmH2CkXqBxyXYCkitugAL1h062shfQgWbb8OiPGMRHEoBd2UjwYiBexi/zEZ6zfGo+MG4sQMJuIfOSJ7okhwwCPwZvvy5hK+UBAu6QObNXi91mbaubGMB024+SMl4P2oUrEZtf0MLVE4Pk4YNU6ZD3nIGMUO6/5BySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUQj3TKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUQj3TKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73205C433C7;
	Mon,  1 Apr 2024 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990442;
	bh=DFh01i2s/ozI67DgPhoDj0W4jyAaveeqyAGehYibEgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUQj3TKnVufyVldCPrkEy27NRGJqT9OQAnqYsgeOmgPXI/kqUs3CnKW/hAj1BVhNh
	 YFhhG9F77pBONknYOm0JCSfGu+vONdqRZi1L+JI0WA2ZOdinr/UeMl0jQ2BTTlA1R5
	 6uaRHNfjIPWCkY7WCljYGKrciEZ1DNG/+4z/7+Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/396] drm/amd/display: Clear OPTC mem select on disable
Date: Mon,  1 Apr 2024 17:46:43 +0200
Message-ID: <20240401152558.478316342@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit b4e05bb1dec53fe28c3c88425aded824498666e5 ]

[Why]
Not clearing the memory select bits prior to OPTC disable can cause DSC
corruption issues when attempting to reuse a memory instance for another
OPTC that enables ODM.

[How]
Clear the memory select bits prior to disabling an OPTC.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index 93592e8051fb7..e817fa4efeee5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -149,6 +149,9 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 			OPTC_SEG3_SRC_SEL, 0xf,
 			OPTC_NUM_OF_INPUT_SEGMENT, 0);
 
+	REG_UPDATE(OPTC_MEMORY_CONFIG,
+			OPTC_MEM_SEL, 0);
+
 	/* disable otg request until end of the first line
 	 * in the vertical blank region
 	 */
-- 
2.43.0



