Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E43289344;
	Wed, 23 Apr 2025 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420921; cv=none; b=TVfhVzUCDhDsqFOzphPJsuRDaTbRGNpNMqsY6FSs+jN5yxFaGPKLloQQ66vQPcqfdQjTAy1G4QyzLoSpadY3OAMSg6zswmFoOcY01KQ3SF1hZMKFXQ/UB8PSZErBXx07g9CPJawwwUdAJxblVbfWSAz/I5LWPr+WhV4C7Dg/V24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420921; c=relaxed/simple;
	bh=txE9+Evako5+ncPA5BS4umDqLRL6LWvcRp8NI0Pbih8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWcC+7JZOskSIfqOlLsd3klECe7PiOF5BHBsvno3U6T7F+yvosomRSn+PQexUvmt8vXQjV8s4h1+BfHS8I6ieTYE7FuIKnCD5XZlKh1r5xZqVUbcd4bFpHYBPvJ4rRo8oqa5R1nJH5eNavWGgv8Jnolsi1pATmrsIorvLmwB8V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mecVSRNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mecVSRNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB5C4CEE2;
	Wed, 23 Apr 2025 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420921;
	bh=txE9+Evako5+ncPA5BS4umDqLRL6LWvcRp8NI0Pbih8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mecVSRNzEkrgK7UUJLdYUiiYzuvo61QJb8H5lQvqFl34e0TO++vJ0PfG13D5KiRG6
	 ZsKu8ilmLBMny6qniU1V0JLFEatvruRFR3YPUM/nKGzpZPDRYePs3DQXgGiv5BaIrU
	 S54jOPoWjmYfqss1hXgPoOhqYhTLFMHDxH5DJvqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rolf Eike Beer <eb@emlix.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.12 174/223] drm/sti: remove duplicate object names
Date: Wed, 23 Apr 2025 16:44:06 +0200
Message-ID: <20250423142624.250804436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


