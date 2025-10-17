Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE5F5695;
	Fri, 17 Oct 2025 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713085; cv=none; b=KXrBuBkS5hdSEyI32whb6aA+9HX1/RxItH0e9yeCk7IpOEQKY6oVN/uPrUKtrP+WsGcm9E3NTvSpCwOB/mr8J8E2gq9X8RTkdPXSb1BFSb7TgMWAOPeUFX6sMpiNCL1U26uDDnVyt6TZwCsphmskicMwMSf8TCtYrmJW3YIsT2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713085; c=relaxed/simple;
	bh=7F5IIJ99fyiv4PlZHk/bictfujfLw6g1FB6XEVowUW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gb++Cex4WSLLYl4DBYqeJUbGjDYxl+9U2v5/nPHjSqvs0FHdOstOscAIOq/Vw+qa7hJKlwkG5QRKlum3EYXzEQEw+I82NJcv0/RjA+ZbPJ5qBvxPsFEZv8hGhN89NwlnfoC1yrGCNdCs2GOI/WOg5UYUCsfyalNp5btPC8Sdjys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgAX1qff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgAX1qff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D2C4CEE7;
	Fri, 17 Oct 2025 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713085;
	bh=7F5IIJ99fyiv4PlZHk/bictfujfLw6g1FB6XEVowUW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgAX1qffxwxPCVRdMnoIa3HnANjxhToPLCQr1KD8Gq8W4b8c60bfg4gBQTY7/zyan
	 QtPn1pczX+saXUyvEYIks35rIjPnvVe49JK8y1RN8X2SIEkZMCZ6Z3rA1L7GU2V+q+
	 a7oFL9PKsMNYCIyJXQ55X/KvxEHXD/FS+MjSPd/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/168] drm/amd/display: Add missing DCE6 SCL_HORZ_FILTER_INIT* SRIs
Date: Fri, 17 Oct 2025 16:52:01 +0200
Message-ID: <20251017145130.567452777@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



