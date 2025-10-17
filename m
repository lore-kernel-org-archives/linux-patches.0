Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93D32E150;
	Fri, 17 Oct 2025 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715142; cv=none; b=foxA/h7f7aX7+H2keW+1n2I23oZbyyEJUpMgTNvUM2f4MPSLynYSXx77DEAM8maJNCWLMDvaAu4rTJl6zEiMUZuuRMcfrrlBtyqWb2Ev5FsHL/sadxZ/MoiySkkEl0uUi6qa35TPtXx1pwyt5dRob/2s6kDv3u1VLGVXuqhJvts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715142; c=relaxed/simple;
	bh=FURlJWp7mWNwOANSWC8i6bjpHscoUENNlUQK+3SPsss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ip+XoDHIF9dbD77SG/a7zQfUE2UxhzzBO/k2Dtc8RUGuj5oprhhUo9AOPtL9DRI7qEvJ4Z0nYk7QhFgIxlg30wSbQJ3nWe5MNVtntBGfkfBugM1ULAWCi4b3FtI/7HNUBPXcQOvsdgeQZKL2wFMHkpJGJjgEO2k/df8/Yg/rYOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqICAKgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqICAKgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D837C113D0;
	Fri, 17 Oct 2025 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715141;
	bh=FURlJWp7mWNwOANSWC8i6bjpHscoUENNlUQK+3SPsss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqICAKgcCV8aK6IAJQYU9h4XhoTwcbzCuZXicI2m2g2V48qbK0tJ5gLTW+64qYJTN
	 IcZZFst2KsZ0dUMwXTlbpVcu6G7vs/LIoiaWUeFsalP4Uxqtq22Htdv+T29AkUX2Uj
	 kkZybon8E1zbROShzV3YabKaRUx6HdvyQDevr9YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/371] drm/amd/display: Disable scaling on DCE6 for now
Date: Fri, 17 Oct 2025 16:51:27 +0200
Message-ID: <20251017145205.990894323@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 0e190a0446ec517666dab4691b296a9b758e590f ]

Scaling doesn't work on DCE6 at the moment, the current
register programming produces incorrect output when using
fractional scaling (between 100-200%) on resolutions higher
than 1080p.

Disable it until we figure out how to program it properly.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index 53b60044653f8..f887d59da7c6f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -403,13 +403,13 @@ static const struct dc_plane_cap plane_cap = {
 	},
 
 	.max_upscale_factor = {
-			.argb8888 = 16000,
+			.argb8888 = 1,
 			.nv12 = 1,
 			.fp16 = 1
 	},
 
 	.max_downscale_factor = {
-			.argb8888 = 250,
+			.argb8888 = 1,
 			.nv12 = 1,
 			.fp16 = 1
 	}
-- 
2.51.0



