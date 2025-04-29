Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C716021772B;
	Tue, 29 Apr 2025 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945432; cv=none; b=K0Bs+nbLk8LoWfKbOe7BXSbYrFrEA0OvLR1EiES2bJoHIOwYuniOhAsy0cBp6fZlmTumiKmQyU/44ZElj4rnAKFl4Q3v4M30yTt6IRtSkojGqQLlagWrZRnpdg8JWOAAAgK3Dxsygrp08DfvTJMH4eX1VXTZXWAFNxr9Qo1LV0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945432; c=relaxed/simple;
	bh=2qjodBvlacIlpCk+SQKswSe0qzhUq0g2QDJdjeCz71M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf37kGU19vLnSxf/C8EzACihnC7z8r8g2HJjuwS+B72GxU5sqFMsZKVl2LjLkF2XNiMnm2GnatouTVumEY0rVAwiQjYZ4K0z7IMWOuOnrRaWSy/ghP3GU7u+xskJFCnUTbSbZA6QhRrhUmyb/CqWNiGBUp61mq4l760q1XGXf1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZx1Abgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZx1Abgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43940C4CEE3;
	Tue, 29 Apr 2025 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945432;
	bh=2qjodBvlacIlpCk+SQKswSe0qzhUq0g2QDJdjeCz71M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZx1AbgrheHUnNWIJLOqYwyvaUyinwdE5Y7VXGx+Zk9RER7gZaTZUgZDoyuHJqE57
	 tqzxCODLgZezHnbnVwe+GkPsyLdRdB+zR/mlE9ruPbz4++ytkWLzZtBKCBGyRPSxTe
	 hXD/uw8F6ZVW8A+20rx2SfaIpm2QvsI0p0izCgZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rolf Eike Beer <eb@emlix.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.4 110/179] drm/sti: remove duplicate object names
Date: Tue, 29 Apr 2025 18:40:51 +0200
Message-ID: <20250429161053.855852526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


