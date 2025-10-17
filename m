Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEFA231C9F;
	Fri, 17 Oct 2025 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714319; cv=none; b=R0HRJkKT5zkTHClY58gKd/ksL1fU0O/gtCpG9/qgGSkgrbCmp7yBF7HIbYAr+Bb2z6bFG6vyYbascKH6GbLEp4Gwv7fBcg783lrs9L3je3uwhvTfWltO5O7PTklaaKt0WejNXg1yuzutSbRo9pj+hnefdbV3paiHE/7L1eBldK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714319; c=relaxed/simple;
	bh=lbKk6LnfqpIPH19BZaIRYZ5klqmBbaD22e+VlOFNb8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOtBoIOgi/zPFwVAgujecYNTxBRSQd95xxUaMjkTKI8uc20gR+/uMHnieH1wJrau2ivcDqj+dYja8s8mhr572o/4iZmi42DuU9JSdcMzSkJdYywzuPOXKwHdVpajxIE+JrSqHF68dppt+3wU52nBbh6y5HkIf5db63Y2GxSxPRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGEW3jWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGEW3jWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00CC4CEE7;
	Fri, 17 Oct 2025 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714319;
	bh=lbKk6LnfqpIPH19BZaIRYZ5klqmBbaD22e+VlOFNb8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGEW3jWUbVdA6RMGppBxQMCTvdp2LBCPuxvXGarRKCLl/YCvRHhIEDzik/MV/f/rT
	 hJwl1t/Pou+UqBHoQf6bjui8fdPwQjbhmTYTCDhI6mi124cNF9DOJiMbnD1x3/k3JQ
	 cRN6SYyUuxc5wDSCxaiBj6zt61hvWyaSUhLvBhcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/277] drm/amd/display: Add missing DCE6 SCL_HORZ_FILTER_INIT* SRIs
Date: Fri, 17 Oct 2025 16:51:17 +0200
Message-ID: <20251017145149.697986104@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit d60f9c45d1bff7e20ecd57492ef7a5e33c94a37c ]

Without these, it's impossible to program these registers.

Fixes: 102b2f587ac8 ("drm/amd/display: dce_transform: DCE6 Scaling Horizontal Filter Init (v2)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
index cbce194ec7b82..ff746fba850bc 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
@@ -155,6 +155,8 @@
 	SRI(SCL_COEF_RAM_TAP_DATA, SCL, id), \
 	SRI(VIEWPORT_START, SCL, id), \
 	SRI(VIEWPORT_SIZE, SCL, id), \
+	SRI(SCL_HORZ_FILTER_INIT_RGB_LUMA, SCL, id), \
+	SRI(SCL_HORZ_FILTER_INIT_CHROMA, SCL, id), \
 	SRI(SCL_HORZ_FILTER_SCALE_RATIO, SCL, id), \
 	SRI(SCL_VERT_FILTER_SCALE_RATIO, SCL, id), \
 	SRI(SCL_VERT_FILTER_INIT, SCL, id), \
-- 
2.51.0



