Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57212D73B5;
	Thu, 30 Jul 2026 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423782; cv=none; b=p9xVxEDfZh3HCbd2TCN3xybtdbjYYamghRKK+F1DuYjsVS0HEaeRhMoROG8/YLAfxaXRyLP33ebtOGdLaf/dTix9Z6FlVFlpiEofxXcLSe3UvB6YxWbXlfWZpR0YUM+IgUyxUBnY5446ggKCjCD42XEO73Deodxgn/xUKgfAWAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423782; c=relaxed/simple;
	bh=6qhK2ev//yKoYbqcjzVSr3GfbAhvyPmz7IifYEqD+gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3MjChcVecHQgxsW5iTxbzzlMCeHt/yg7wAThs1X/xvC/Yx8kzv1O1p5lHzvOwz6OLzmDMSf4+qK4YYw4Z/AbQ29pCMUIMyIYRwdLc/CBcsEIfxXmrLIq2EqsvmgbfhBvv4S0+xrU1T5+ZEKWSw/85myFym7gIbOXSNiR1Kq81w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P04RdPF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P04RdPF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1F41F000E9;
	Thu, 30 Jul 2026 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423781;
	bh=bEHGekWc/lcvRP8Q3FSRbNOqQq/sLScw1lsdMzdHMvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P04RdPF1YUCNcuJkJs/ryY25m3DVCgPDK7QSa3GwOwUd5aOvvL+ey7kPjciexe8ha
	 LyrjzbGgilBtdTQqq+U3kV/pom71/LTUBezXu5EZI+ecpiiFEujBdtY37NB4GI3q/a
	 TPFDZ+UselFiOZNH7JzTVI4mdg0sFCoSnkKHE7do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/675] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Thu, 30 Jul 2026 16:08:12 +0200
Message-ID: <20260730141448.580231777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 038a0f01dda595dceda8f0c9c5172b1297281929.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index ae858a43c35f4a..b3d55cac35694b 100644
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



