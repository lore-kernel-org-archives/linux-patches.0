Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CAF3A3E60;
	Wed, 20 May 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299591; cv=none; b=LpliexQlVjyOKowUsUQ8bGo1nYAkAbfnl+A5SG6SMn8DDx9VrfFKtig0Gc6ZwpDEgzlfP5ynHq1oyE82cYiIyV2n20GtPmvqvgUKL74MrUs/D31Fj/Hr9GlqAaGRHDYfU1hhu0PKTBTrILIbib5BVnGOr/snYdHmJ4VZ4a6RZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299591; c=relaxed/simple;
	bh=4zvqorGa2afhGieSwThk3g/TMH2fXavKDSt5SMp6V3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DD5Oqx8tUPGemldx1TWxBPh0TbvKfXNUxre0GlNFBFrnNAVrhYLjG5Fu24OirflHVdwBFFOQzziL/AjbQofS5EMBnOLoOPa12x0+GNNibyUG7cN67R4y5sYAcge1E/DkhjtUCovd7DEHqh7C6RhzyAw01kAvCzYOL0RiUFlG47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFgIY6LH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFgIY6LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887411F000E9;
	Wed, 20 May 2026 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299590;
	bh=1MpVIfJxDkAm2LgmPIuhMe5cPeLBpxnHKCDHey1pI2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFgIY6LHqPfZU9DznSnCbegnhXtwRFl5P785Q8fZauwmzFBw/H9iMiMMIC0oMrVZT
	 IGjx0wOtUZBOKQoX3sK3CnZs+LOlIAgyWBpKDpAWTd1yorx4e42Ya3HxVC3hKlu3Cc
	 b/nLfgWgx7U2Vr3X42ziMFdIhywGdaJP3NFwVkZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 829/957] drm/amd/display: Allow constructing DCE6 link encoder without DDC
Date: Wed, 20 May 2026 18:21:52 +0200
Message-ID: <20260520162152.545552665@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 880498a1943f865529819f778df3b9945ca57262 ]

When the DDC channel ID is set to CHANNEL_ID_UNKNOWN,
pass NULL to the AUX regs array.

This is necessary to support embedded connectors without DDC.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 38a70e50b22a188ff601740d64dd75f46213121f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index f2e47f1ff4b33..e94af8522083c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -728,7 +728,8 @@ static struct link_encoder *dce60_link_encoder_create(
 				     enc_init_data,
 				     &link_enc_feature,
 				     &link_enc_regs[link_regs_id],
-				     &link_enc_aux_regs[enc_init_data->channel - 1],
+				     enc_init_data->channel == CHANNEL_ID_UNKNOWN ?
+				     NULL : &link_enc_aux_regs[enc_init_data->channel - 1],
 				     enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
 				     NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
-- 
2.53.0



