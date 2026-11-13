Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585496;
	b=FFzNer4FiJnVY7a8iU+fgCuhDhQfKiqxCCHdOV/azZOvlaDREcT9LmnyjqdMD2hcNF+A
	 +UxNnncKBW9TWAcpfYyd/zs1RCVoMAQNUMKhpu5IwYPARWfCiQT503abiHk2tQkWQnKm4
	 DWuQsoymqFqqioG35ILieux+vyz/Rx7iDq6gfidtN8OSuT4HfD1CcyxLRXMQmWyaN+FsQ
	 zKuoiAC0fmOVwXR+Ni5/JsPcnk1aBrqfaFSzDkcU1ext1aTWtl9WQzZQ8Qv4fJMeSxtmA
	 Ndc0nDsYwhI+Jr79FUI4cMPczbkYRV82X93JNbhEFKoCR6rFlUY2sxnKWWEjtRuMHgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xSQHz6ZUleY7ZhIptDU8BqoWayjPjHdATIKTJ7s8oQs=;
	b=cubNPp6mXMAqPmJhTp/VLJ9i8THtproL0UY+nz8Ma9GWLiiqN6jKKpJ4DbDOjaeNEST6
	 6uqFT2N6Odn8G+FIvYQJwW1IV9ZiuTUfV94PXV2ZMeIpazn7BgIvsABOymW6xsZeMmGq9
	 Yglb3yQ/ru6jyvot9YWrwNMUGwcYeJ6Xac6wD3TlZEDN+y3lGGWP3grCwW9BzElsVmp39
	 uCmpVFxJksrp31THKUoyZhgP2xsYfq05YJOKMwHzTh/e12aZ1IxULXYeFXaNKNWCDI/Ql
	 MW+2Iop3mQAfChUaDpcgKvMgrcckwp7+xqxopDMkCwxFzCLB5pWH1iKGSQ3T/kcKONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8UDDdgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4D4606AE07;
	Fri, 13 Nov 2026 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8UDDdgW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0891F000C5;
	Fri, 13 Nov 2026 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585496;
	bh=xSQHz6ZUleY7ZhIptDU8BqoWayjPjHdATIKTJ7s8oQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8UDDdgWUvFjCZ5Ga9gSIiDGx3mj/2iZD3qnXe/6BqPZcJDshpz1gg1q0P4RNkOHC
	 8rzWlouSTSQ8P572jZNnoCMcSerJh+a0xPdF4yEIFZYF1PTvc9yjHR1cL5c7akt57Z
	 LuZlKVbFxdfVSOs4NE+W0y7GBhVmXRDjVShi7EcQ=
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
Subject: [PATCH 7.3 103/507] drm/loongson: Fix framebuffer selection in async cursor updates
Date: Fri, 13 Nov 2026 10:46:47 -0500
Message-ID: <20261113153757.812747553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bcc0ffa17bdf2..7b9c65c30a9d1 100644
--- a/drivers/gpu/drm/loongson/lsdc_plane.c
+++ b/drivers/gpu/drm/loongson/lsdc_plane.c
@@ -230,7 +230,7 @@ static void lsdc_cursor_plane_atomic_async_update(struct drm_plane *plane,
 
 	new_state = drm_atomic_get_new_plane_state(state, plane);
 
-	new_fb = plane->state->fb;
+	new_fb = new_state->fb;
 
 	plane->state->crtc_x = new_state->crtc_x;
 	plane->state->crtc_y = new_state->crtc_y;
-- 
2.53.0



