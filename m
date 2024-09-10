Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651E19007F;
	Tue, 10 Sep 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961523; cv=none; b=UORa7nrJI+fk0qfIDnXfycRBndStZPlVFlEhDxFgexLnzgQlXkOK/oRABjLT5QwFWDbOJbNdGGMBnKfzB38wat1dWvjXnC9R1VTw0UmvhdP5HfIZ8npgCjnDXzUpsqFYE1yVR+U2iTJO1nuhNGh6qG2Vhd5CtAbRXJv6Nk25Oj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961523; c=relaxed/simple;
	bh=weHNWlHC4w/keoq8WwoMAR4Oywc/PGrzNN4zwoBe9ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUsfJrKaMW6WykRx35aQQuALHs5n+e9nJbO5m0MrJ2w9ZCYFZ7gmrAQgZVYLr0ujv3l094FPlr3rzwlpfqINshc/gmRGpVJQhPXBGaivnlt/1Z7Sfb0RdbYnZxqNSJP0iRI4rklbVPYeVMs94PLqhbpSeet6Zt9L93VSfmdYXZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AE0Cni+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AE0Cni+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE4AC4CEC3;
	Tue, 10 Sep 2024 09:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961523;
	bh=weHNWlHC4w/keoq8WwoMAR4Oywc/PGrzNN4zwoBe9ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE0Cni+0rQu8O0QYiYd8i4U+WeDv11cf5EwONyCBHaWhcisCXsTqjyiEXji5j80Q2
	 L7uj13czDDNQnsMhnG5ZNkyDsQRgHDYmg2DsuAdtfXE0aJ7iEyw0DgHFqgtJqcVqsP
	 KBUG7kG73XL5Fp7EBHRovu2f3qKqs955Sy9TCwb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 098/375] drm/amd/display: Check UnboundedRequestEnableds value
Date: Tue, 10 Sep 2024 11:28:15 +0200
Message-ID: <20240910092625.532840451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit a7b38c7852093385d0605aa3c8a2efd6edd1edfd ]

CalculateSwathAndDETConfiguration_params_st's UnboundedRequestEnabled
is a pointer (i.e. dml_bool_t *UnboundedRequestEnabled), and thus
if (p->UnboundedRequestEnabled) checks its address, not bool value.

This fixes 1 REVERSE_INULL issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 3e919f5c00ca..fee1df342f12 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -4282,7 +4282,7 @@ static void CalculateSwathAndDETConfiguration(struct display_mode_lib_scratch_st
 	}
 
 	*p->compbuf_reserved_space_64b = 2 * p->PixelChunkSizeInKByte * 1024 / 64;
-	if (p->UnboundedRequestEnabled) {
+	if (*p->UnboundedRequestEnabled) {
 		*p->compbuf_reserved_space_64b = dml_max(*p->compbuf_reserved_space_64b,
 				(dml_float_t)(p->ROBBufferSizeInKByte * 1024/64)
 				- (dml_float_t)(RoundedUpSwathSizeBytesY[SurfaceDoingUnboundedRequest] * TTUFIFODEPTH / MAXIMUMCOMPRESSION/64));
-- 
2.43.0



