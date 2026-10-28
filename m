Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208926;
	b=KeqtTBYyvAf6nFyf1/f/eWETYYqs0iLc8LhRCEwUTxV9WrHXbZbcTx/pYNVH472LXa+s
	 WAy7TF6D5n9YqC1zZb4NgrC+sabnbadtEauWdX6OizT0s0cC5EEVpVgduTi5HH94/YT7W
	 ixOo6pwdIwNRvGNMw/BJ7kLHypvUewelLpthKuPPi6V/Anb6Ai7o+suHdhe8Ea0V/yj8w
	 hroNCaxi8XHtAnOg+2gS/Xief7kbXPAWobIs8lvt2lvlQNugVjXedoJyigzGFtEzlONPw
	 NKzpRt1OBVUnzs5xNIvBbuMuVREn+RxeFuR7ryqrB7AfMHn417BMvRJUwNTxppjo+LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FvoGT+9dtXFrz4VdXfRefm8d9On0BJfFVFzkXPULbF4=;
	b=iDw7YVA2mNCpr+Uv0aMjhyOaRjo1hoory+a8CQqebvq1YO4xb8AvMxwmfRqOkD6NMd5k
	 pG/TckUH8nD/cIctj+wNAIM41zZ804W8fYmUr3lNKd/FwtxGVc0T4kWn5gTgXbzqI2TT3
	 RIcJ/701F5Xs3w1+6oM9UZbI9aNFrplV/l47tTpLmBn9xRU1HOpLsQ9liZS0ocrVekSen
	 nXs+owISxhdFN6gENThwWMJ0NSIVpdjEz5p5mXw+JGlnXwxw90YxGzp0TkgEOxNcN4CSx
	 AYwTL2+UcTuDl3pRcCN8taabkzJQY0KHUYuCU0tc10M3k9QV7lzSdKUtojHFTuAcZ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mYrhG/PI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB6E606A31D;
	Wed, 28 Oct 2026 17:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mYrhG/PI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACD81F01825;
	Wed, 28 Oct 2026 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208926;
	bh=FvoGT+9dtXFrz4VdXfRefm8d9On0BJfFVFzkXPULbF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYrhG/PIc8wUDwxFNlkCpbyW2GNFsZxGRjgj+fKHPlBV7MefujsIWfcPXEPV4kbqn
	 POCdklWGncU0YPyJRlO7ZaAq+r4o/XJcxOaT/Z4LW3C9DvC6vtMUR20hE912wmeJuU
	 GzYgo5/IqHKiN1ZL2JNr+5KbWXmayR0e0WYj4OEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/516] drm/amd/display: Mark DCE 6.4 as not APU
Date: Wed, 28 Oct 2026 17:57:24 +0100
Message-ID: <20261028170010.410689967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 3a52d587d1fc8e8bf94ba1b07374f7ec91aaffb4 ]

DCE 6.4 is found in Oland chips, which were advertised
as low-end gaming GPUs in 2013~2015 and then have been
sold as low-end workstation GPUs until 2017~2019.

These are not APUs.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-3-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1072aa811ea1e61d5f763e4ec1bc6d24bb61f14a)
Cc: stable@vger.kernel.org
[ sashal: adjusted context in dce64_construct() due to missing debug and check_config initializations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index bcdd8a958fc01..fd064a5196d26 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1359,7 +1359,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



