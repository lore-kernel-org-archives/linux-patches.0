Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039111;
	b=VdVI9QlPavOR6ZQD8LLvwQw13+DQ2n0/GnWaYove6WTq3YGwkpEXLqoAKTpsV7zy3aVG
	 NGPgw9C+AAenl4WEyr7gwPaVh88j3CK3ZykCF5Sb9WpOjPMbJB2M6kuTDo1wN+1Ao1C/l
	 dPv58nKIWon7DxjuTKRd1xORq8ry7NKrufQjbqDuLdNq7vde7DlvEBg7nmN1EKQ+tVK5t
	 UIy21rwckqXJGqJnBjWue7gRCxMYjvefuisEVqiYrEu4NIXRmPtCKmwerkmx+z5SOFjaO
	 vM4e+1CDGOdYh+7LXgjsBI3qKajcY/kzWH+/n3NZpEOzxl8Dft47kZcwmzRfkH8UjsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fLb63YZF8fSUcYAljgci2oHYuXpncYuUWc31Mnns4n0=;
	b=od/QVSBeJr/KSnRCV2dG0EJOSdxSC+ZvJOXv3eBtXUm95DcDCJ2hRDT8mclSTNYAWQP8
	 qzWUipCd70WGCSgwmMRHltJ3wyTRa9YLUI5CtpaL/do799fgMp30JGW/WepPepAGiiUIo
	 TmGnrsKwnOgSWRb/Sy8Vog5zn8IddJKUDErkYlTMsyzPMnmMEouXYT3zJVxkxq7ahDUwC
	 SOqNpyLXOAEIf8wTfcn9hPxUKJwpmpl+gA+kvqdkUXLiVjPumQfXY4PCXz6kN8/L8Mm1p
	 KjXFXW8K1VhDN4GmQGUI/iXbYWIAUIgKTCVZHc0AuqKVX1BnkQfW0mQXmTnN146LnUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkK+WDix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8DD606A337;
	Wed, 18 Nov 2026 21:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkK+WDix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B0F1F000CC;
	Wed, 18 Nov 2026 21:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039111;
	bh=fLb63YZF8fSUcYAljgci2oHYuXpncYuUWc31Mnns4n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkK+WDix41WuOXMNcNXHaC3e24qfsfYLYneUWZS6T8PFS0MCSIG8B6LANM+XYM4JJ
	 ks8zjFWxsn9tQNuOqMfimYOP34ZDXmktQnyzIeq4L9CXHQCX2AzbMPHDfjZq+Nb6U8
	 X0xYQKBm+FdbdjSFukDP+DlJ91467Mescadlmj08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1983/3318] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150421.561810955@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index e78de99e99335..fd7947d2cc003 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -70,7 +70,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



