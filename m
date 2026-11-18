Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037643;
	b=Z3Uylap859v8MbpwPZyzNZSBahcrjWjdsP5leK3yL/4Hg8R8IB96mLraEMcUejCIkp5o
	 lR+YtX7M+1uw5LANaVQepUlF9wYGRAPOdozWxJyGGNjySC0ASSY/U/A7UFaiFCh2ccZ6p
	 luZVM7ToudOcheEH7e93YtsBIVj7AboZa6xIQ0Xg0uX7eQU2bpcQojpTMxSbK4B7pMvNY
	 Q5DPLmCTOSlTbB8bDRDoMlF5em7qw0qqpoTD3Na5SDMD384D71+/dib6ztEBEc2JAd2Wj
	 BcvXcncOS+BkViMpZGyFBUgA6Zi0g9NrtqAN4vieDrHtY82og7E8BWChSbbCi/4Dv0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITkaY3FItuKM0tlh7CRNj4DAkLNXRH3q3iNJvmcbSBw=;
	b=UMYUXWdXj/3pDV34T46OW9NEn+143kmkvKDs2A4uqP/b6TTJ17eRdqVO5J5kLM5iEZKH
	 0qwadaThUDjixetjaUhrOmZ2sQ9LCM7NtmzPaW9Dp+UbJz+bDayQMXL1eBWRUKy98Q2vL
	 WYTz9iBn/0g3pPZ4c8g0PDH4VMG5L+Oa52vptRlzDfILbtykTBiRQ35jRuFKPxj4D5/Y9
	 kdUHWa+UixGeRSsK5qnRAMmNHBf7pQ1jP6uHLlztJm8cDP0JpbNDFPsGLBWXyC15zpQ4m
	 O2XLhrFBF3auO04/CWBm1hGms7I2xJu4/s5CvYd8BsP95z9Q6s213CcAkGOLNjrDDFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wo4DLN84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A93606A31C;
	Wed, 18 Nov 2026 21:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wo4DLN84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33B91F000C4;
	Wed, 18 Nov 2026 21:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037643;
	bh=ITkaY3FItuKM0tlh7CRNj4DAkLNXRH3q3iNJvmcbSBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wo4DLN84ifNC/IE0tendZqcWHi9Tu7Maw6H6no+i1tTIPipQ2et7YiVojxJBLoWKq
	 bWnvhbj4ZXUAH/E6wbceIlaADIigOqb1ZNdROQyFN3j6ByCBFYiyrc1XtXw3qm5Htg
	 wZBvRfuMJRM+3k9MkHzGddS/pwov+bERoeSDdgEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1427/3318] drm/loongson: Fix framebuffer selection in async cursor updates
Date: Wed, 18 Nov 2026 15:34:09 +0100
Message-ID: <20261118150403.538777934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evanshenf <archwse@gmail.com>

[ Upstream commit fa66daafbb6d5c984de2502809ff533ab66f6573 ]

An asynchronous cursor update swaps the new framebuffer into the live
plane state. However, the driver reads both old_fb and new_fb from the
live state before this swap. When an enabled cursor changes buffers, the
address-update condition is therefore false and the hardware continues
scanning the previous buffer.

Read new_fb from the new plane state before swapping the framebuffer
references. This updates the hardware address when the framebuffer
changes while retaining the existing behavior for cursor movement.

Verified on a Loongson 3A5000 with LS7A2000 using 32x32 and 64x64 legacy
cursor updates. Callback counters and read-only register observations
confirmed the asynchronous path, the stale address before the change,
and the new address afterward. Same-framebuffer movement and cursor
disable/re-enable also passed, with the primary framebuffer and mode
unchanged.

AI assistance was used to investigate the existing report, prepare the
fix and test tools, run the build and hardware comparison, and draft
this message.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202311152357.4KFS0M8f-lkp@intel.com/
Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Evanshenf <archwse@gmail.com>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Qianhai Wu <wuqianhai@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20261003090006.4e29fdce9913-1-archwse@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/loongson/lsdc_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_plane.c b/drivers/gpu/drm/loongson/lsdc_plane.c
index 0d50946332229..44d710e86767a 100644
--- a/drivers/gpu/drm/loongson/lsdc_plane.c
+++ b/drivers/gpu/drm/loongson/lsdc_plane.c
@@ -228,7 +228,7 @@ static void lsdc_cursor_plane_atomic_async_update(struct drm_plane *plane,
 
 	new_state = drm_atomic_get_new_plane_state(state, plane);
 
-	new_fb = plane->state->fb;
+	new_fb = new_state->fb;
 
 	plane->state->crtc_x = new_state->crtc_x;
 	plane->state->crtc_y = new_state->crtc_y;
-- 
2.53.0



