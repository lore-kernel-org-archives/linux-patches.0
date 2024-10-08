Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62211DED69;
	Tue,  8 Oct 2024 12:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391960; cv=none; b=TTKHXwJot07bxnrvqn0VwSvgxMJTmp/ARBmsp34gwhmYVf17HmwsQRhjW3oMhXVny9kGZ+mCTcd9w7MP18CzSoibpVMkBwUESwWLaUPToHUNiSD0CzDan9Jbci8xaYjzU27QiCFpryNBhTJdM33cx6+hpR0Nf0fxqOy9dyt0iUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391960; c=relaxed/simple;
	bh=xsTxAIasgCzVdNh5cglxfTYREQh+D/S0NbL1LlwXa20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mil5XaHZ66quP7UM7Hr8UccADZg97Ldo/sRqU2cCabpOc69HAiZslCFFD44sj41gvZT2NzY5wyi1D91/JhYbNn26C3Sv79BddbDPpb78D/2rNKy97+W2ZCg5uP4EHltWCekHJpifEj7Kl9qL3vkRkFV7Oy6u4XNN+TPFPN55+yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlchapaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlchapaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA65DC4CEC7;
	Tue,  8 Oct 2024 12:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391960;
	bh=xsTxAIasgCzVdNh5cglxfTYREQh+D/S0NbL1LlwXa20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlchapaIP+RglzEdxwgeg6qONx3nmeZ2L+4l31i+Iut5sS3+ym2sen+F6dywAASpo
	 s9LZ8n6WzgPolkRfqo64GkjIcabZRtuOBEgIpT9swe7wDKzqsXWX6MG9zdM4kKI701
	 F0jRmlZW1lk/ppfyEBy5M4TjorpCZTsoRikdMAKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 243/558] drm/amdgpu: add raven1 gfxoff quirk
Date: Tue,  8 Oct 2024 14:04:33 +0200
Message-ID: <20241008115711.902585231@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Liu <liupeng01@kylinos.cn>

[ Upstream commit 0126c0ae11e8b52ecfde9d1b174ee2f32d6c3a5d ]

Fix screen corruption with openkylin.

Link: https://bbs.openkylin.top/t/topic/171497
Signed-off-by: Peng Liu <liupeng01@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 2929c8972ea73..9360a4425c4ae 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1301,6 +1301,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
 	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
+	/* https://bbs.openkylin.top/t/topic/171497 */
+	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



