Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6294B24EA90;
	Mon, 17 Aug 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976701; cv=none; b=QAAJPAMluRRlG8M5YXa7P4vOLSD1ERjZeb7jbls97zSJQAnPyr/xviwHtpo98Gj765IfFEjBjT6WXV4oEj2IqHGRRCOyA2rxng2BLWwoAEfVKAq8NpNsCEvX/CfJb2OTKsStB9grXoV8PxEZQeDj00FeXE8SmrHaFsboS1ayyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976701; c=relaxed/simple;
	bh=sHG0g2j54yrdh925m8pzFiJCqfkHXv7Y6qC8VSyeFvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjLrS1KbrdEwVGsEZlGphdaBG29ivw0KJ9WsTsIPRZyERCaw9oyR9a54HQlmH31fQz6MN2cb7WZRKNHmpq45ExOZ0maLdrHe4SP4Kgj2fNqw+eAY8FPCgNTWSfa9WAU6S/kJKVqZq51Od5W4tkzuwYFhVs9hBkMwcZXETc4i9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2iSVx0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2iSVx0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C2D1F00A3A;
	Mon, 17 Aug 2026 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976700;
	bh=r5FBBkcT/7f4vd+AfS0xQn/dXcqi+KU31iNYBvaItAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2iSVx0qr28PydCSX75l/MLr+/XOGLdgHdLJ9kaUJLoJpGXlKVagjwbTKYlf9K+au
	 8mffoleaBt7nhJfC3rs6otac730pwIT0yPj46OlZB1Klv4qVpIt5Z/pUP5GyuF0cY0
	 gvJ++kz/UnY5Sn2dA5aR3ldEk8Qv8DjQ2g7NAJyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/456] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Mon, 17 Aug 2026 15:27:45 +0200
Message-ID: <20260817132543.009705554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 904eed5c1044b52db948e0322a5f74ccaccd0b8e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index c09e86523e291e..4e075b01d48bb4 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -415,8 +415,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
  *
  *  @stream:      contains data we may need to construct VSIF (i.e. timing_3d_format, etc.)
  *  @info_packet: output structure where to store VSIF
- *  @ALLMEnabled: indicates whether ALLM HF-VSIF should be generated
- *  @ALLMValue:   ALLM bit value to advertise in HF-VSIF
  */
 void mod_build_hf_vsif_infopacket(const struct dc_stream_state *stream,
 		struct dc_info_packet *info_packet)
-- 
2.53.0



