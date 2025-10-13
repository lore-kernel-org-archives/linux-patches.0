Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFEB309EE6;
	Mon, 13 Oct 2025 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367192; cv=none; b=okDRVIFNmCWxEWIoJA3x3IohO7IrcLnJH/2dUcVKvK5PtaN8nR0hbWkPAIR+zUklcyAZhgwIn55nxJvVTrj+NcQQIShnjHfGnLbW4zS5D6S1GKj/wSlFwJfqlbt3KBtEiLi152XSNpSkHFLFsbzg48FHvf3h2hk0W0OOLMirG7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367192; c=relaxed/simple;
	bh=K67+G9JejPvHyxsqNKTmvxotVNZDzAAfFKlIp6/CB3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fi58LGnIc/NGbRgwIPHYy+yf7wb/7MHz8I/s+cM0Nehgk6GPY9ETgpekVKZDejmOhYEUKJN1NI8+M8nM0WJafUqKOnBmBgQWEF9WoxFwL5JfciJtBEcGv7F+8Ng/dGaiofHdRXGK3h/rwpbUhKBAhXl95sVexwlfpBm6clMb09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKFuxSp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKFuxSp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3DBC4CEE7;
	Mon, 13 Oct 2025 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367192;
	bh=K67+G9JejPvHyxsqNKTmvxotVNZDzAAfFKlIp6/CB3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKFuxSp4n0LO2GBEazJ3gbmMHY/mgJWyhhtbFt2y/UxXAXgILPyM7NKdomE9+n/Es
	 b6I5ferFe/PxdmHOsdf60wvXJvpE65LfMuARPLC6Mjg2NZ4QpP0fcFdewbfCNJ2iVC
	 gXirRAuNQOGSS+EtgS15DYT5Z7QShl9QpcILJch0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Brahmajit Das <listout@listout.xyz>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/196] drm/radeon/r600_cs: clean up of dead code in r600_cs
Date: Mon, 13 Oct 2025 16:44:24 +0200
Message-ID: <20251013144317.862871648@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 780352f794e91..b63d935391dcd 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -1408,7 +1408,7 @@ static void r600_texture_size(unsigned nfaces, unsigned blevel, unsigned llevel,
 			      unsigned block_align, unsigned height_align, unsigned base_align,
 			      unsigned *l0_size, unsigned *mipmap_size)
 {
-	unsigned offset, i, level;
+	unsigned offset, i;
 	unsigned width, height, depth, size;
 	unsigned blocksize;
 	unsigned nbx, nby;
@@ -1420,7 +1420,7 @@ static void r600_texture_size(unsigned nfaces, unsigned blevel, unsigned llevel,
 	w0 = r600_mip_minify(w0, 0);
 	h0 = r600_mip_minify(h0, 0);
 	d0 = r600_mip_minify(d0, 0);
-	for(i = 0, offset = 0, level = blevel; i < nlevels; i++, level++) {
+	for (i = 0, offset = 0; i < nlevels; i++) {
 		width = r600_mip_minify(w0, i);
 		nbx = r600_fmt_get_nblocksx(format, width);
 
-- 
2.51.0



