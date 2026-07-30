Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808A0453A5F;
	Thu, 30 Jul 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427274; cv=none; b=ByrwZz39PcAJWDKWO03Fr01DhMk1MBwOp8clBNScCh7DTJoaat0QaH6wmWxLq2tBCF7higsuWSMLVW9yrwZbH1fBniWmrUqQFF3e3pPWtzmHdZcl5Nrm+6Uj0icF58sgQ504B47+mChXhSArq8ckmZAxB5s5IQNTS3vqwyWM/LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427274; c=relaxed/simple;
	bh=gYH5VmaBdCZ7fBuNrP3YJ6wRP8iUC+esa2wWPHoFvW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsN9LyX9L3XH29xKtA3AXMgmLzZMpL1NkKkpvHXqNGioA6F77WRw+WIK6iMROSgVFP4D9CAkcCdRDz6shI1fY0smXY5emX6gM3ZVOCpi0vww/oD4kxFhCyDQMqBaJWeGoc9ayANnDCnhFogyO/czv4xELKDMgsxLZDhEdjA6edU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6GU4sFA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6GU4sFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B14D1F01559;
	Thu, 30 Jul 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427272;
	bh=0JxgOvVEQqbJUzEwoIgqYjJc+rQT+Awz6FMs3NohNLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6GU4sFAe2XmyJ3lYVrZPKnuOuCwNXuEZ0uVnAUluMJQOfCFgHsTYjoe42T3S/hRC
	 tn1P2OINxdr1oZv3Yu0J58/mKdJ+o+2RGNTfwAx8wts3a3Zm3f1iPdPcyBUzpFvzw0
	 vyYNxm2mjxLs9CZfn2M+Op++nWikc4SpWMzfTCjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/484] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Thu, 30 Jul 2026 16:10:09 +0200
Message-ID: <20260730141425.895147529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit bca364c4c75796650e53837fbec174a866141511.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index dbb62b911c75c1..84f9b412a4f117 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -447,8 +447,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
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



