Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77033A5433;
	Thu, 30 Jul 2026 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421621; cv=none; b=IVFE3NLkRDPBEhIrzJoGqKgTqM+svha+tx0ZZjxcszv+b+cYRmK8kmC+EgxU6DME28WU9IwisIoBjoeUmLg9WdYszp8xt63NV2xMLiiFcGUazAzx+N62SYX9MPkmo4V+n2UqWuRD64Q//7iavgwlibEetRVWOJ6KZIfcEDs53zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421621; c=relaxed/simple;
	bh=YLEWxZ9VIA5halLWO6P4lYNPXFmdQQAZYnn8MWqL8nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqjfxgqbue//F/uN6qhUI9BrrRP4NJhGa0FO0zj1OZYYYWjscYM5Hode01AJdTiQ1t0R1TP86QimbdYsX6zpR9qsbt2Pe+b6Gs1BBCnmvtBYAw41oOLB1dPSyVArK94N4qAuBxncB029x57GGeK36ljFXChnEF4oqo2Nh/WprI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXoDQFrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXoDQFrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1133A1F000E9;
	Thu, 30 Jul 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421619;
	bh=01dD62t/q7rNtydBREMcEXAl8XcGgHmoOg1pFa4eTc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXoDQFrTN2/zXuj8AxdNt3v9kXvyhZZNxH1j8vTZmzcpQKOeyWN0oiXvCmuEZkNIg
	 4owow0dnJI9yzO/Yw0P6nAjRUd0LoLex/vmOJ7OGRuklcVp75BXzbOdDs233QyPJeD
	 fY6ZpLz6YLB7dt6RJ5t/6Rl46C73HSQ1O3EuJxVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 164/744] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Thu, 30 Jul 2026 16:07:17 +0200
Message-ID: <20260730141447.779347921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 994a42b890cef46cd576a3bf700f1dbd6bb21346.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 614db22d62f38b..00473c6284d5cc 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -502,8 +502,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
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



