Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016239;
	b=zGghkGaNG2Sonlclr8VXMwo6NkeAvYs+1tC89SK3Njjq0juC1Va62XqBsRGyFdYPO4aV
	 a7Bu2/z+mx35Cu0rv66TKaMJSFpO9yo4w+Ya0u6/IWwo1206F3eXWIvUDjRHq0pLbxfNI
	 UwE/iYIZsQS0ji8DRO2w4/gsFZ/2HVfwFIHx+rLU40/HTPeNWci2xn8OD4OAPTGrSP+nF
	 MWEthmAdpvJnotrMFbCvrHAlBCOImnFZhe8EhPUZadCkt/KdLfHpfi96qgXDhCy1TVsut
	 jkFcjg0+QGOznQAu0H4izmSr6DItPP90YEc81dSrkBTxK0zRtuJED6v4LLny9u6Hz/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLQFlCU3/aaHtYwDxA1DCVKgBW/ciHPij9ZCptSDy84=;
	b=lp8Bn+SIMdICSY4Et5kBcIWUVCU4wTVtdw1WXOQoB7tkifsbeQeQzNhaMK4iRnZL0tZi
	 fdoOdZwnpPQOZE9IhrwQ9Zg9w367e90iGB5yIQnAfr16Pw0IPR5r5DxgYzS4TrdXljgwa
	 D9VFjyXsxHJa+byX0KEHqvirYN5ky5v1hUOUzI7aWry9UbrveWwYYbfvd2dfeZPKLiDb8
	 22mFMI5U3IYTJdNIqNjl7I/LZwmM5jGBXnHCwpnYW6A+za5GJwhj2tE1NIbti9ptwrfcZ
	 hYIShXFUVj1s/mMwyjoivH/RAOxsULo5kDKkbXljO6vY6bTdOX2mo8q6kt1VGK6E/Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1aW6BYN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE4E606A32A;
	Wed, 18 Nov 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1aW6BYN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F175B1F000C6;
	Wed, 18 Nov 2026 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016239;
	bh=eLQFlCU3/aaHtYwDxA1DCVKgBW/ciHPij9ZCptSDy84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1aW6BYN8mbJZwzTGBz/yVwMLY+O/HWhuhKczCjytAhX0R//xjbp4qqzOQOxOL+Q8
	 bhniPiigb4yzG2WQnDDbR76sI1bzLockwr4fdUK85qhIQl5e2HlPyQ4vEWwSSDvQqB
	 6gwDlc76jzFQKXnxx3kiOE+yCNFIvbFwb8uyRXkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0457/2651] pinctrl: mpfs-mssio: fix whitespace in debugfs output
Date: Wed, 18 Nov 2026 15:28:17 +0100
Message-ID: <20261118150304.256245987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit d6a27168cce7339c633bce88df00444489dbb5b7 ]

The printout from mpfs_pinctrl_pinconf_dbg_show() is appended to
information from the core, so a leading space is required or the world
will end.

Fixes: 488d704ed7b7 ("pinctrl: add polarfire soc mssio pinctrl driver")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
index 92d38e5336de0..8da0c5312ce37 100644
--- a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
+++ b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
@@ -612,7 +612,7 @@ static void mpfs_pinctrl_pinconf_dbg_show(struct pinctrl_dev *pctrl_dev, struct
 	reg = mpfs_pinctrl_pin_to_iocfg_reg(pin);
 	offset = mpfs_pinctrl_pin_to_iocfg_offset(pin);
 
-	seq_printf(seq, "pin: %u ", pin);
+	seq_printf(seq, " pin: %u ", pin);
 	seq_printf(seq, "reg: %x offset: %u ", reg, offset);
 
 	if (reg < 0 || offset < 0)
-- 
2.53.0



