Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC622FFF8D;
	Sat, 12 Sep 2026 07:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198709; cv=none; b=l7B81q0kjan++fl4t1eJs1wDGxg9kRDNf/uLr6+kRe4K1NxNmH/IHUeY3gj4VaFlSQz2uJfKRt76bRX6k2LJ1bQQBuHM8ZEsejsnNV6uyL+qVHOnZJsl1eUGoWcaIMJQYsQrX5ESW8qki+TzjezjD5vpG/2mqwHwdw86AXtZENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198709; c=relaxed/simple;
	bh=8kG451ilDwtZK12P01wCGLvrvk5XnvzPnxs+WiZSZd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0X29oLXfgVx+CEfS6mpgCtq5UO78Yx1R8d2+OIpP5M8vCI5gzfKYT73xf532mf0YvTNQR+rRo7N6sFB1fIbZK3WP5tDM73uKCeUx1914/NeGsnBB5Xa2wLHHJJW7dF5DzTFxCwj8oSKK3yUeG8GsiVFEbwJeu/qqKgqK+3hHiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVZldjX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVZldjX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109321F000FF;
	Sat, 12 Sep 2026 07:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198708;
	bh=TXkgE+yld4BONRPQ2+n10DYZyUi4YteG74NpJbMDTOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVZldjX+50cjvJ0kJqKrSY6fbmuWtV+UM+FUl6TqkY5bxhhfELTABxAxr9xAHymMC
	 Ep4tr95SNYoIPCtYl5FzdOZ+Hlmeqd40CjNdKjZAEvPfGC+tP/MQf3TNeo2wBIvRmX
	 +RYYNI/RqQPSYfAwPaZh0K54NaYNQ2q1GLjhXqj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dyllan Kobal <dyllan.kobal@zetier.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0436/1815] drm/amd/display: fix wrong register field in dccg35_set_hdmistreamclk_src_new
Date: Sat, 12 Sep 2026 08:36:26 +0200
Message-ID: <20260912065659.128364808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dyllan Kobal <dyllan.kobal@zetier.com>

[ Upstream commit db9c882f83d3f3e08069f52d0d2ebf9d131c9ae4 ]

dccg35_set_hdmistreamclk_src_new() updates HDMISTREAMCLK_CNTL but
passes DPSTREAMCLK0_SRC_SEL as the field identifier in the second
REG_UPDATE_2 slot.

The current behavior is harmless on DCN3.5 because both fields share the
same bit layout, but it is still incorrect and could break on future
hardware revisions.

Fixes: d36771a03412 ("drm/amd/display: Add DCCG DIO, HPO, OPP, and OPTC support for FRL")
Signed-off-by: Dyllan Kobal <dyllan.kobal@zetier.com>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
index 483cd9ab7eb76..42066b8a03623 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -572,7 +572,7 @@ static void dccg35_set_hdmistreamclk_src_new(
 	case 0:
 		REG_UPDATE_2(HDMISTREAMCLK_CNTL, HDMISTREAMCLK0_EN,
 					 (src == HDMI_STREAM_REFCLK) ? 0 : 1,
-					 DPSTREAMCLK0_SRC_SEL,
+					 HDMISTREAMCLK0_SRC_SEL,
 					 (src == HDMI_STREAM_REFCLK) ? 0 : src);
 		break;
 	default:
-- 
2.53.0



