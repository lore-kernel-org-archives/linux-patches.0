Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829367;
	b=qNsC3R3RpHHPdIJXtPzpHDVJMkmXY5Lp2RiWFP5ryqK4ZxvTmokqrjVxFW0gOkcO6cIX
	 FakWewyE+wFNG+AY3XHdHAYcp9QCk6WjXaVU4V0pLryNSf2IdJBZW6M7nEfeCC+yHpdcL
	 Barf3tMTVEWI5Mu+oEK5zLT9VRj7J3qxA8x5evddaWUzV5evFIKAJw/73uy5sNiFj4+kj
	 XuzCgW6Q9TEVrbodHZ8UQ/Nn0yQjupjCHXmZmlD8T262HFySUjMZOMaPziAPEdqhRfYru
	 XyditQVDh5g6MIUq6h8oY4XXivg9aBJjD8Mbb1bjxFOJuG2L4qZ3gsyggsdvTxYNz8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VwgI3Mnpx2Iwu3VAJGdKTsacyZGvUvsn2ToditzEE+I=;
	b=p4jd9PDRZE8SXFY87nCV2YGTz3VrOI8nNf7tyexeuIDWiy9jddKd5qohRihxNe+m9//4
	 AW+4K5yCpaNRuByLCru+sH3L0h3+YNxX829CEQDBg6oPN9L3c6O7x9l4sjb1YCjBfj3N1
	 IP/xaGlfRkB0teiC9E0FLKF6zc0ILFO/Du7U9lwN6e26e8fXi5NQBjzDnWf9KAIY9m1/M
	 /fUEt0HjnadW9Xsm0tHcBZwT9LQGzCmf78Eh337dVfQLzxi9fTaSR6uNmZZyNsNLArD5r
	 hzplQ7wS380z+FBDHShvjWIATqZN7Y/4Wty/wdTn1AbzDM1HFipExCRRKSs+0iVB9Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeSWU3xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD80160BF2DD;
	Wed,  4 Nov 2026 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeSWU3xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AA91F000C1;
	Wed,  4 Nov 2026 21:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829366;
	bh=VwgI3Mnpx2Iwu3VAJGdKTsacyZGvUvsn2ToditzEE+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeSWU3xn1HQ2WU0Ixkxnw+4Q6/C9ycZPVr5DB1/VPfoYN8XR2akuLQvn8+4skR2zV
	 lbxXPtKHpJDT8I31Ried1CTvcQop94HiJ3jEQOhjWMwqpTNi7ZgvsBGV69TDuiEYLe
	 0D9gmOhGJMEQFHRcK8kYDpGtoutdboPIwHEaJkYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0080/1005] drm/panel-edp: Support MB116AS013 edp panel
Date: Wed,  4 Nov 2026 15:56:53 -0500
Message-ID: <20261104211045.862630335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>

[ Upstream commit 844e71ba7d7a50c5ffa29d147afaeaafb19b39e4 ]

MB116AS01'3 raw edid:
00 ff ff ff ff ff ff 00 21 63 03 12 00 00 00 00
00 23 01 04 95 1a 0e 78 23 e7 05 9c 5b 56 93 27
21 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 36 1c 56 92 50 00 1c 30 60 18
a8 00 00 90 10 00 00 18 00 00 00 fd 00 28 3c 30
30 07 01 0a 20 20 20 20 20 20 00 00 00 fe 00 48
4b 43 20 4d 59 20 20 20 20 0a 20 20 00 00 00 fe
00 4d 42 31 31 36 41 53 30 31 27 33 20 20 01 cb

70 20 79 02 00 22 00 14 1c 1a 01 84 55 05 91 00
5f 00 17 00 ff 02 1b 00 09 00 07 00 2b 00 06 27
00 28 3b 00 00 81 00 13 72 1a 00 00 03 01 28 3c
00 00 00 00 00 00 3c 00 00 00 00 25 01 09 1c 1a
01 1c 1a 01 28 3c 80 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 e7 90

Signed-off-by: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260701013018.2621972-1-zhouhaikun5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index f2ae333a32d8c..0da04d75e4e96 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2061,6 +2061,7 @@ static const struct edp_panel_entry edp_panels[] = {
 
 	EDP_PANEL_ENTRY('E', 'T', 'C', 0x0000, &delay_50_500_e200_d200_po2e335, "LP079QX1-SP0V"),
 
+	EDP_PANEL_ENTRY('H', 'K', 'C', 0x1203, &delay_200_500_e80, "MB116AS01'3"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d51, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5b, &delay_200_500_e200, "MB116AN01"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5c, &delay_200_500_e200, "MB116AN01-2"),
-- 
2.53.0



