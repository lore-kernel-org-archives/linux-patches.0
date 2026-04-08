Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134F3D8912;
	Wed,  8 Apr 2026 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674165; cv=none; b=Kc+HHVewKjFpHGP51ckDrO0FsaVDUmeR8Y6NLJvTIJdQueso1ID7oXTc4T6cpn0NYBwb/4gz23pngDCYRo5ZzNdDM9AhfxQqn4h3p1OAFGMj24fABkdkZc50YgkHGqY5A54F7+F8PGr7CHcxk5ZGKw6mOuFUiJnBpyIZW6sjJNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674165; c=relaxed/simple;
	bh=70syBfC2yJuvmgmm368JLQX06O/ZRvfoVERiVlQOHwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oolh3E99YMwKkgjyVKkWE3PiEqBl5wmh/HDAGQwc8b6S5uAE9cAu9188hHn+RtIq5smhOCbHpIDStJ9Zn2DXww9i7o887fejtkpBADlBNMPAm6pQnfcQ6JI2dY0X3mbZkqfb4DHMhOAssZI7uHjTQDdIZmn5Fj8Rmf33x+9aLB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMjqtQI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMjqtQI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B45FC19421;
	Wed,  8 Apr 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674164;
	bh=70syBfC2yJuvmgmm368JLQX06O/ZRvfoVERiVlQOHwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMjqtQI7kktF6cDz+xwQjRexfoX1dl1MHKw+9DWFWX2W+uN0XkCuPdH9ahOxcpp5v
	 7eKyPd6a+G9d2xt/qDoGeFzYi9iAlJQDJUE/7AwtPJ0t9EbsdeDYaO3QJTKmuytdB4
	 uo1ncrzBFWx7KMGq/gnum2H2moO/yp2R+BqDCe6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rosen Penev <rosenp@gmail.com>
Subject: [PATCH 6.12 234/242] drm/amd/display: Disable scaling on DCE6 for now
Date: Wed,  8 Apr 2026 20:04:34 +0200
Message-ID: <20260408175935.859432675@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -404,13 +404,13 @@ static const struct dc_plane_cap plane_c
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


