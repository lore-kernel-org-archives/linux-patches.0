Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034465;
	b=L/yvpm3iBSjjEH23tbf1fjgzX3jrd0htvdCDI7PKir5WBXPtMUl6ulRiTupXhOvFftMf
	 EmQOqZ1D0tU26a1Lc/p45fq33a5D+2blw3SPa30Il7eHIfuWCtU2I10pbLM72cLcrlLwF
	 bLqRgLfkfx37Vh5YmWpafUlb2ju72Bt5EZaYs+RQo6N9DMAp6a0mTDFDP5A580G+k9sAw
	 kXStSvjs48UXWHomLMzLN5S4NjjtWKplsg5DesY5J/PNxGqpml76pdnFv6/KN3p1nJ70e
	 45lbdaVD64AB1JjZM5WeEStKE4fviR61fCvrbreEazuCneaRE0YBNUvEDYWt+HyAObw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+/cGWC0XttgUlwqFK0fBFes7dGwIhLv0wgEGNSnRmk=;
	b=CFkV1/hYwPTS2FTa/BymwDUvnBUpw20KFn4BixmerveD2LiBHp7CQmKZcGu8M/aocBIG
	 c6Px3d+XPdfoY4uxEarSVwQKlL6uDtwX6W1aL40CvmboK14VmSEFYzLvQm7OTgZJFRPby
	 +DQMORVnkBQSgLjl700lQXBEufH1XCkfvdBzln2KZuLqoxGD+Bk3QJR/4MJS5UQx2lBUW
	 CjRDzR5CeWwd2+O3mqHaJA7vneLmHbiNe9b3Z+aVXaJRKHT9oNiCZGdEAut52ooPFz2GG
	 BhW5BmAYQtWhqA1WemJE3cehk5tbD141pKOe2yvOl3KV7+ENhOrhD3zN4TWELy6aI+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3nS9u9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D0606A32C;
	Wed, 18 Nov 2026 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3nS9u9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B06F1F000C4;
	Wed, 18 Nov 2026 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034465;
	bh=l+/cGWC0XttgUlwqFK0fBFes7dGwIhLv0wgEGNSnRmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3nS9u9GnwXDsV/jEv422BnF9oypRLurYUrdFvVJ8o2CkTv23Yb6zqtK7eIk3sEJ5
	 X8IU4ciHQIOPRoqQ9skg0dEEXgqJnTulC+/8a3YQD2tB3gMgLYgksQ5PQblN0qbDMo
	 956E7geDJAT3JQsLcIo1vopI30hL2jDUjCU4fZIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0377/3318] drm/sysfb: simpledrm: Improve framebuffer-size validation
Date: Wed, 18 Nov 2026 15:16:39 +0100
Message-ID: <20261118150327.549485802@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 03f1a3545b721fa7fdadd00080e237519a286a97 ]

Validate the framebuffer size from the firmware against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail probing on errors.

v2:
- remove unused function simplefb_get_validated_int0() (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://patch.msgid.link/20260625094509.157581-2-tzimmermann@suse.de
[ sashal: Kept the local simplefb_get_validated_int0() helper and made it reject values above U16_MAX, since the tree lacks drm_sysfb_get_validated_int0(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index d10574e630a86..5d18ed29bf634 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -52,12 +52,12 @@ static int
 simplefb_get_validated_int0(struct drm_device *dev, const char *name,
 			    uint32_t value)
 {
-	if (!value) {
+	if (!value || value > U16_MAX) {
 		drm_err(dev, "simplefb: invalid framebuffer %s of %u\n",
 			name, value);
 		return -EINVAL;
 	}
-	return simplefb_get_validated_int(dev, name, value);
+	return (int)value;
 }
 
 static const struct drm_format_info *
-- 
2.53.0



