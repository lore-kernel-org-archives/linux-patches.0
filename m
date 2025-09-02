Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24F3128DE;
	Tue,  2 Sep 2025 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820013; cv=none; b=OX16CTDPG27LxbVRIBTO4KBv/slmRd1JkHwJCLgeJV+6/TdQxxdFax6WxBG+cat54pvTM0Mzrws2NMP5HaNGX5LgNo/UjPQ03DM39TCIlHfKbqvu7qow0CV2ZzUu41LM37nIhLaNPLXfoJIjAYhfUzcfgYQVC7V62Hf1RRHuXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820013; c=relaxed/simple;
	bh=GOIPOWCIYEQxtKMZ3gf8U2XovWdCKrLf48S53bgMa9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsOVZ5Dx7lA+OoYJ88oLWfg3x0hqtyzkwTRzArOmWT/ioW4doJ+jLcVt91sehaGxIwdRlcNPiV3iS/4vNNDXNEWiKiEhXnhnWtCJ3XfKkSUc5dj/hIT9cRqntKHkd1iy9a+T6Ci1jDfcrPTnIrt+PwFtS6EnV16PDJrI66FawaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjz73BC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjz73BC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237A3C4CEF5;
	Tue,  2 Sep 2025 13:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820013;
	bh=GOIPOWCIYEQxtKMZ3gf8U2XovWdCKrLf48S53bgMa9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjz73BC8WRk6dnj86SlAuyaoDsYOV9gpLoaskshWb1Oz5XHQD1oijqGBQeZgEyJpT
	 WV+yDcD1UCQ/YhIWfE3f2ikpbiYyVIThh6Bct+JAbjK7A+DgbvmHpM5bU9tDSBSHxP
	 SCuL/ojFocewdsoNbX3eBdlFdH5G08TuEFna3MA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 34/95] drm/nouveau: remove unused increment in gm200_flcn_pio_imem_wr
Date: Tue,  2 Sep 2025 15:20:10 +0200
Message-ID: <20250902131940.919140551@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit f529b8915543fb9ceb732cec5571f7fe12bc9530 ]

The 'tag' parameter is passed by value and is not actually used after
being incremented, so remove the increment.  It's the function that calls
gm200_flcn_pio_imem_wr that is supposed to (and does) increment 'tag'.

Fixes: 0e44c2170876 ("drm/nouveau/flcn: new code to load+boot simple HS FWs (VPR scrubber)")
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://lore.kernel.org/r/20250813001004.2986092-2-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
index b7da3ab44c277..6a004c6e67425 100644
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
@@ -103,7 +103,7 @@ gm200_flcn_pio_imem_wr_init(struct nvkm_falcon *falcon, u8 port, bool sec, u32 i
 static void
 gm200_flcn_pio_imem_wr(struct nvkm_falcon *falcon, u8 port, const u8 *img, int len, u16 tag)
 {
-	nvkm_falcon_wr32(falcon, 0x188 + (port * 0x10), tag++);
+	nvkm_falcon_wr32(falcon, 0x188 + (port * 0x10), tag);
 	while (len >= 4) {
 		nvkm_falcon_wr32(falcon, 0x184 + (port * 0x10), *(u32 *)img);
 		img += 4;
-- 
2.50.1



