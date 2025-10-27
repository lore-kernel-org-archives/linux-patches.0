Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03980329C45;
	Mon, 27 Oct 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591333; cv=none; b=J3ablbHOK7YQGN6yTJaZ9k22Tij9eLewVN1sl0SV60MXVidM6eY8LATcVARcHa/mlr/cD7lm9qbYbb+CyNvaE47h2/hHCgyTzVfKuLr5pHpNcxfm98cwgaHI1IO5iP4wWuA/z6rViJ5GSuRXzuos6LLaubbegMbKPduOXzG4FYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591333; c=relaxed/simple;
	bh=RgDffYKXPDGxU9lMjjln+BIknwtnS8an92HtPixLVWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9ljTl29QxV9trBCa9Lr7VRiogTmAIizgCk5Z7b52w0Y9gwNo8W+uFHdkGCvPADeSZ5Xot2uLdOJk0uqtWz4dGkNc2wcoeDM50MqTjzp4ej6zmEAET0u3/6rm4OIDcTwQwrUq68T7uSmLE+OfkxcOBUBw1srfBayr0FkOSWow/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcOyO1Es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcOyO1Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3C6C4CEF1;
	Mon, 27 Oct 2025 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591332;
	bh=RgDffYKXPDGxU9lMjjln+BIknwtnS8an92HtPixLVWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcOyO1EssAQ+Pzyx5TIIYGEny7xadT1i8NXrtYzFJqBWuGPXmYbUhEXj2kye/tCJj
	 w8ADCg8puWcRSQAM++4rE7I7BV+oV8YqQzf/fQ0MK0svl1Ca9mtNbNN2UQ7g8rFEvE
	 JrksIe+e6p4ZDgbapl5E8ZM+BFT+7KOxdHpHl3w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/332] drm/amd/display: Add missing DCE6 SCL_HORZ_FILTER_INIT* SRIs
Date: Mon, 27 Oct 2025 19:32:53 +0100
Message-ID: <20251027183527.782206830@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



