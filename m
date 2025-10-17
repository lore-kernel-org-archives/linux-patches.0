Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E44330B00;
	Fri, 17 Oct 2025 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716040; cv=none; b=WTkJPD2lzY0Ad6h9f0tB4G16AG2u6v9lR7pcH07Rr45EPiJJ0xr9ZSO8SaGJd8lw42hdaqIO7fvqtniZJkOdZ8Dwj0yq45Ky2RXqDDRyW5Y7820pF0rdT4mDOIx5C7HTff86XWQbyJ4OjX3vpr+QOAWfaaRGR9Ma3pVdAQs8dhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716040; c=relaxed/simple;
	bh=dZ0YrpOjS+qRqCLgOM09Uj2OLT7vF78ul235n06w1Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jq0z4zE1Qqcuz9IYU9r6DtfpSOmoXxMFwjpS83+gAC6H4OmIZoYgnB8xB1nwdUQ5nJj8o2kn5U6lQscTXDF4A0pwTHeMzSZQeNpGEXrQ4wo4VJ7isitV4JApwFpUoVLFEJtYg2PHekniG4QHD+5ASHXQu5djGN6z873RTsXJi/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Li2N/8R7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Li2N/8R7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D9BC4CEE7;
	Fri, 17 Oct 2025 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716040;
	bh=dZ0YrpOjS+qRqCLgOM09Uj2OLT7vF78ul235n06w1Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li2N/8R7U9bV9whOa7mcKuTrC5wsh7gcB8Thdi4vHb38tSr5BtTuDywpEwQKCoAQ+
	 gZlSVpNeDeg1IlRMQpIc3642RbqnlzGsMUUhsW6J8inB//LHgH2efszeXJ/lq/4OKR
	 5U9vybzyZCo7I6/lAdmOWNNds98qTIXU8FLu3nRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Brahmajit Das <listout@listout.xyz>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/276] drm/radeon/r600_cs: clean up of dead code in r600_cs
Date: Fri, 17 Oct 2025 16:52:26 +0200
Message-ID: <20251017145144.424178195@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 260dcf5b06d519bcf27a5dfdb5c626821a55c170 ]

GCC 16 enables -Werror=unused-but-set-variable= which results in build
error with the following message.

drivers/gpu/drm/radeon/r600_cs.c: In function ‘r600_texture_size’:
drivers/gpu/drm/radeon/r600_cs.c:1411:29: error: variable ‘level’ set but not used [-Werror=unused-but-set-variable=]
 1411 |         unsigned offset, i, level;
      |                             ^~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:287: drivers/gpu/drm/radeon/r600_cs.o] Error 1

level although is set, but in never used in the function
r600_texture_size. Thus resulting in dead code and this error getting
triggered.

Fixes: 60b212f8ddcd ("drm/radeon: overhaul texture checking. (v3)")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Brahmajit Das <listout@listout.xyz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r600_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 7fe2c49854987..d5e5f08deeec5 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -1410,7 +1410,7 @@ static void r600_texture_size(unsigned nfaces, unsigned blevel, unsigned llevel,
 			      unsigned block_align, unsigned height_align, unsigned base_align,
 			      unsigned *l0_size, unsigned *mipmap_size)
 {
-	unsigned offset, i, level;
+	unsigned offset, i;
 	unsigned width, height, depth, size;
 	unsigned blocksize;
 	unsigned nbx, nby;
@@ -1422,7 +1422,7 @@ static void r600_texture_size(unsigned nfaces, unsigned blevel, unsigned llevel,
 	w0 = r600_mip_minify(w0, 0);
 	h0 = r600_mip_minify(h0, 0);
 	d0 = r600_mip_minify(d0, 0);
-	for(i = 0, offset = 0, level = blevel; i < nlevels; i++, level++) {
+	for (i = 0, offset = 0; i < nlevels; i++) {
 		width = r600_mip_minify(w0, i);
 		nbx = r600_fmt_get_nblocksx(format, width);
 
-- 
2.51.0



