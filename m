Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E441D1EFFB9;
	Wed, 23 Apr 2025 15:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421545; cv=none; b=tvxLGXuxA5iRxsflA509YVCnyFZKxX31e2Kz7tm8MgY2zNWKA1hD4tECv5iXAT3wkjMjfE+D/Jm2iy6Pev62yS0eU897b3woSnAgCK81+ezIWxz/PCZFxJB6uRqZjNuQbxeeAF2bHTU3tawgCmmq1p3tnRvX0tBV2cTbHdRI8H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421545; c=relaxed/simple;
	bh=10sMYugoKCKXgKWZgUAx0m2PwSi04HEsbjzBhyRVf30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC1Yz2XgXTrT09Db54tUuY9eOB/VL/vcWrhA11JSpRgIlfDJl7DkqPqP8cO3Jo1Nj6Sb4Y/BZYjw+9pPohA52Emhtv0QT1PSBBGCJ91rccmcDz77++RhJxuQV9Vt9+VblekBvBKtz9H5Mt3Sse3jAxhIHNbf0sW/aVvXTT4Hk/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0piyLWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0piyLWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751F1C4CEE2;
	Wed, 23 Apr 2025 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421544;
	bh=10sMYugoKCKXgKWZgUAx0m2PwSi04HEsbjzBhyRVf30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0piyLWgj4SB72RtHS5YfhnIURrlu4ePcZUmB7iSP3vqwHWBECtBmFRMAN9FyBmuf
	 sqvYn9ih7bRHWMp2r9xn9qMslKbEStXKciepLN9lQ4TRyabA8hEJdtM8uO/8E8RxaE
	 XsWVG96kkjS3WpboRjxoaO+jNgVBrKQIQyAlVWgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rolf Eike Beer <eb@emlix.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.14 201/241] drm/sti: remove duplicate object names
Date: Wed, 23 Apr 2025 16:44:25 +0200
Message-ID: <20250423142628.725858210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


