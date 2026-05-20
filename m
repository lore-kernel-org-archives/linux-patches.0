Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912BA3FFAAD;
	Wed, 20 May 2026 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302852; cv=none; b=uYcaKznqy8fUOH116IX6/MuPsk2GONfqmVjDytF5JsDnAxbEqv1TyRNdxWPhsOA6UfEpqLxhctvmP6cENttvTs2B6WnvwlbEGbj74h96hsKUHWuvOhRCk8UoBZZZq86ACZF8IG50loBBI62LIz2LFt29idmR1f5oUBPc/8xPdEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302852; c=relaxed/simple;
	bh=cWqj9qmomywCZxLkRQ+n/yAQU0IgHapJmA4eS+bocAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSWI6bQB0n1VeZCjqo3G+Juegd78FJAxIb2ePhQaKKwaXiMJt4sTOgrffnpP3xsCf+/ri0uX4R4prwJ18lwRlOUHX8iS+LN+AIjrmqrfM6desL4BHwwdB0ELnsZbuOzW+5e+Kefo2IBhx6I8vuvWv2YSLmI24h/D78K4ScC6cCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWvCk6Yx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWvCk6Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034251F000E9;
	Wed, 20 May 2026 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302851;
	bh=Z3KcbkRaS+CHV1FzUqUPrVcxJP2+fAna2bYTCm+6kaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWvCk6YxZQ9hI78fL5mFboz/4E88GzOv7m7Sk3FoWVR9c67rlkdnnSjHKaboqqxgk
	 N+DPePdcVnVQZUqrShFGbInaReEpXMH0BSV0VZCvOtOtHoMyK61Xf+GRly59UdBFdP
	 K8KTlJ9K7/IpzZ7nk5gvzn/X8diC6d9igel4QXw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 423/508] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Wed, 20 May 2026 18:24:06 +0200
Message-ID: <20260520162107.768280424@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ac27e3f99035f132f23bc0409d0e57f11f054c70 ]

Allow constructing the DCE link encoder without DDC,
which means the AUX registers array will be NULL.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87f30b101af62590faf6020d106da07efdda199b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 0a33f8f117e92..623abdf7065e7 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -989,7 +989,9 @@ void dce110_link_encoder_hw_init(
 		ASSERT(result == BP_RESULT_OK);
 
 	}
-	aux_initialize(enc110);
+
+	if (enc110->aux_regs)
+		aux_initialize(enc110);
 
 	/* reinitialize HPD.
 	 * hpd_initialize() will pass DIG_FE id to HW context.
-- 
2.53.0



