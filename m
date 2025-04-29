Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5946221DA7;
	Tue, 29 Apr 2025 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947011; cv=none; b=mwpr/3yGTZcMCdXUXt9TtdRPrdCoQj75qZOUWlYiJJ/ePY9zcoLxcfG30FsWLamlruBBtynDNDiB2faLSUK1wsVpdO4Xhcqes/FWVP1IXvdBKbJedN3WmA8fDJQLkMYpPGrmOflr3sihknq3+Dlia35DBi8MQG/eNaoeftAx9yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947011; c=relaxed/simple;
	bh=W7mYE3B4mmsa5K0sxjRjk1AWWkTDidf29HQR8EfsYd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxJinXEmyHpV0x+A8KSGS3JEAyPjcaHb8WcN1G/d80YIEZ2wOpIhVPe0ZGTJqIbwFyX8IzUXy2B3D4wyf8BpC4VgXzn8VNGHgdIAlYsXHfIekF3pniNJ0NGw5fWdcA/PKCEq+lEiqi/wcNLSPKpELV89Epp0+FnUglxF4mBKsko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALLZkxQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALLZkxQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F4C4CEE3;
	Tue, 29 Apr 2025 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947011;
	bh=W7mYE3B4mmsa5K0sxjRjk1AWWkTDidf29HQR8EfsYd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALLZkxQrF5n7qTRFI9oqLQCKit9BEWfhDAXMu4dLsfTPcYRs3/86W4KVdoRXXZbCd
	 Tg2N/03mMwCLJBec0iYqRpL36or0Nro0a6XAd8EfuJMhGOq/uZ/mZ/Uw+is2Zjn30J
	 +sA7CB6Mhm46xYFbHCpUZad/WDboc9UPMcid3sbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rolf Eike Beer <eb@emlix.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.10 143/286] drm/sti: remove duplicate object names
Date: Tue, 29 Apr 2025 18:40:47 +0200
Message-ID: <20250429161113.762777430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rolf Eike Beer <eb@emlix.com>

commit 7fb6afa9125fc111478615e24231943c4f76cc2e upstream.

When merging 2 drivers common object files were not deduplicated.

Fixes: dcec16efd677 ("drm/sti: Build monolithic driver")
Cc: stable@kernel.org
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/1920148.tdWV9SEqCh@devpool47.emlix.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -7,8 +7,6 @@ sti-drm-y := \
 	sti_compositor.o \
 	sti_crtc.o \
 	sti_plane.o \
-	sti_crtc.o \
-	sti_plane.o \
 	sti_hdmi.o \
 	sti_hdmi_tx3g4c28phy.o \
 	sti_dvo.o \


