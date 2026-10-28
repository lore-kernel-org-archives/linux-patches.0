Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213221;
	b=2Eu4NOaHaj92JLYemdzCmTpbWeCh8I2WSyXvShqO1o/EWmY/yx6+32KI+FOQO60guIFp
	 MaglQMDibf6HTDeKtV+IMxyjbzZkYilcqcAAQtt3zy5N7G4SzkmQQ9c6xMIjrzHzSlNrq
	 f/tSsyWza581UYTmEo5gtICfZmi1SH6WAnNrgZeRxSfauul2u+HlU52tgghqGQUqRnUp2
	 bz22yMx1KD1engXMECC1DTvRW00U6Qx0er08xkOxU4rrEf7RASyNBoVSoDZMvIHEporMR
	 yJhTxRxzcscK0PU8WXVEfKYA8m6Q11WocDyjYB4oV8k8QTvXKykXAXc7u5CVsLS+3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GH22mRZ7EZ0S5zfHRZB81sOfpOd5bkdXBuICdg97Y/M=;
	b=PIi5NvcMyvm9pBOAwCXYcMuTLQunlDtpWnYR1+WBfh4wRqEXg3HQMM6GPhJkVb95aNo7
	 Fju80EfLzwk28w5z4o0GFVgT8vDX+eK86dvCp6FSdEHkXrt1gk7OZGiZk7rOsZnuXXpOe
	 raSu/twaQIBbNY2yUXSreWoVo38cnzJPE81y3toQUnm9Yae8SuIm2fW8wJKWduVY1L1rE
	 w7bczjKIhKrZYeiCMAIVsAPAGwJOfvKsNZiSZEi1BLHtZlxTbM+10v9w4Q3O9HvRTPF8s
	 aIxQrsCilEBRxLMXVO4VNjvwCzPtls+Z3aSoNejzgIFhc1lateDwEMFHrDChL+gqE5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UHKR/7V6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B75606A31A;
	Wed, 28 Oct 2026 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHKR/7V6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46951F01825;
	Wed, 28 Oct 2026 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213220;
	bh=GH22mRZ7EZ0S5zfHRZB81sOfpOd5bkdXBuICdg97Y/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHKR/7V6IpDbhTBd54fL9LokU+pGm5FmKiv9or654h3WeKSp5cXzF2LKtbnh9tHNh
	 9kKUccIztDsY7v7/gJok9Laz3GgJdPw09M0uu1wSngQD/ROqum37DzDsN+i5iTrF2g
	 xsIYBbWJZYgNNiF7DyIVTUYu+zNkbEohKk8e49/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0392/1887] drm/amd/display: Mark DCE 6.4 as not APU
Date: Wed, 28 Oct 2026 17:41:28 +0100
Message-ID: <20261028170508.155522818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context in dce64_construct() because the debug and configuration default assignments are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index 8db9f75144662..556c453666a74 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1355,7 +1355,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



