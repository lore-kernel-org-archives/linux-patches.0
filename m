Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814513F65EA;
	Wed, 20 May 2026 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297089; cv=none; b=gAnLnuslUX7L42eh9fq252oyLv/N0gdWZacqrkR3+sjbxw6jMRRH07ICaaSBeiKzNzzflsTw6/Oo3ge4NfJKRMC7Y17cy54ACHEsfNW5P5KB9Tnh48CPtjkyF/BjmE1G0oddMDVP6frwY9xAVKNuOgYXkYU2RD57S9W2IjC2Xig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297089; c=relaxed/simple;
	bh=6m8O58bwcUrCAT2XQTDSn4KC0ubj2FEXJ/aQXoIR3Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jnj/K58Ne34zyIoFadX9eS6+A8dlyLLUdWdEO70/d373aqZyKsxVtRNYDTm/TvzlHWQw36qPGcIqrWbOwFNmwKeCAavjJb+JtI3Eh863TJJvufhGV+ZIeYmrfF/sa2sxitbW2/Xfvojvqbuug5Xb5SnaQAQfgqP8yS+7X69nk/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2BxXpDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2BxXpDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E643F1F000E9;
	Wed, 20 May 2026 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297088;
	bh=hbMJBYFKaK7FNoIPrmNN/n/Swsnu1FKC49Ro0sD1GR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2BxXpDdgaUhnvELg4wBC5QwGuh4Fa/r1ojuweFxv2P/lm0VVrvKoEcZaqMKo2yRr
	 FohAHiyvu0ZzCo7A1aI3/FMD5hfmBWx45yN3QSsK5F9AXvBSRnzLXzAjYAZtnj9z/5
	 uQf0uC8Jpxgdn4hc6W/u/LcXscfIgnjxYMuVJ8Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1005/1146] drm/amd/display: Allow constructing DCE8 link encoder without DDC
Date: Wed, 20 May 2026 18:20:55 +0200
Message-ID: <20260520162210.978013092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 60af4605ef35ecb7ad649a8534b83a2f7c69576d ]

When the DDC channel ID is set to CHANNEL_ID_UNKNOWN,
pass NULL to the AUX regs array.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 155baf3038c1af50b602723022ed869b38e86a99)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
index 89927727a0d9e..42d0bd656f793 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -759,7 +759,8 @@ static struct link_encoder *dce80_link_encoder_create(
 				      enc_init_data,
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
-				      &link_enc_aux_regs[enc_init_data->channel - 1],
+				      enc_init_data->channel == CHANNEL_ID_UNKNOWN ?
+				      NULL : &link_enc_aux_regs[enc_init_data->channel - 1],
 				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
 				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
-- 
2.53.0



