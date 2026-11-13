Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590784;
	b=apOxLnnEa1EkCmtC7BZkQAXrYbJs1oQgi/W38dbKuDQOLMq4nBVG+kN1rdLgxZuoW0Fd
	 AHBbfa4kpYyQtALpjiOdpDZxYWMJREEIO5Sj2x2byUQll/ZaKJEMu0jiUObfs30AQ+O3L
	 CoWSjqZSZRa3c7hjhJHvMr4QOf5Sig9aPXauBEgOYtI6Sbb+i1p5qWFMiQPhBjM1/CNUH
	 m5Oy/Ezl/YYduZqzYFM6X4J/wFadLtAkmQSnhEgq4iyEqY0w3T1x0I3f9VpOeE62eBQKW
	 p4lVI6rOm5U6xll8neNwCIe7tj2jUZaV3q9sPe0zr1f3+EGigOmKNxlQe8i9Bq+XCJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FWE6/CzJhQQbB1oHEABcDGrU2/OT/eA+gcibPTdYjX4=;
	b=2PwEkYgeUtDznyPj2nKPQo3Fq7xwrH/TBbytgVLaHpM9qQAa8jqRmQx6Hp7KlW3nQcJp
	 ri6Se4XWu5Lvj96nGJk2wcZnoTmQ+wzQp7cG/z3SX0rMU+pT1TCUyYhbgYujBkaLKTt9q
	 7w1/KzuxlC5AG0u8TOXJbMjIkOTq6cL6km5JcWPlIl1Gihf/wv5KpEOOpm+TPcaOf0qLV
	 MIl+AI3CJhLgXmBO5LnX7RBI1KOG7lV28oPnAUZEzEoQwDnZto5j9BmgeKontwFMlHjfP
	 6y3DTwk6f2iXUDt0pHngeadEtr7pkjqOVQmCdUdC+lrhsYnx/UmGRXanClExmfv0xfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mE1tn6JA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ABC607D2C8;
	Fri, 13 Nov 2026 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mE1tn6JA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84561F000C5;
	Fri, 13 Nov 2026 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590783;
	bh=FWE6/CzJhQQbB1oHEABcDGrU2/OT/eA+gcibPTdYjX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE1tn6JAUK7olzuMioG7lBgF4bHbgqaBf2UbdfGQaBUeg3b4odKr4RKgCKbWTi5JO
	 WwSMJSnvM9dmi0359FTMmgt7FYSO2ixAidMQeyzM4LVB3qjd8PqqCse7JG7s5Duf5C
	 iHp+M1ozclDTXYC43hYdat9hmOjArdZEN+ZnOPOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Andy Shevchenko <andy@kernel.org>,
	Chintan Patel <chintanlike@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 677/686] fb: Add dev_of_fbinfo() helper for optional sysfs support
Date: Fri, 13 Nov 2026 10:53:30 -0500
Message-ID: <20261113153844.598869681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chintan Patel <chintanlike@gmail.com>

[ Upstream commit 39b65316fe9d6d3f730632408ace28d49c5845a4 ]

Add dev_of_fbinfo() to return the framebuffer struct device when
CONFIG_FB_DEVICE is enabled, or NULL otherwise.

This allows fbdev drivers to use sysfs interfaces via runtime checks
instead of CONFIG_FB_DEVICE ifdefs, keeping the code clean while
remaining fully buildable.

Suggested-by: Helge Deller <deller@gmx.de>
Reviewed-by: Helge Deller <deller@gmx.de>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Chintan Patel <chintanlike@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 317a8be73091 ("fbdev: sh_mobile_lcdcfb: Restore the per-overlay sysfs attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fb.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index f622f5f520cf0..e50fc8f0801e6 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -631,6 +631,15 @@ static inline void unlock_fb_info(struct fb_info *info)
 	mutex_unlock(&info->lock);
 }
 
+static inline struct device *dev_of_fbinfo(const struct fb_info *info)
+{
+#ifdef CONFIG_FB_DEVICE
+	return info->dev;
+#else
+	return NULL;
+#endif
+}
+
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
-- 
2.53.0



