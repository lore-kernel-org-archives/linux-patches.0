Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028993;
	b=TTBWRDFZ4ASOxqIPJfboSdLH/hRpxGYgpVZCQoDb5p/E/qLo9H2zQtS1u5CrcxyFoW9i
	 VsMiKHL2juC2BhCbIxpGaua1kf0Hz+GEpnfs0J6wD7eZ+oaz7kp0I3Gm5dYc4oZHUnvkt
	 5u1ssiGE1So7/azXztIm7uFfRo13hX8fBrnAfRd112/oMRmvtvT2TTSjkUOBBHp8BOmP5
	 rECebXS4IhrHVo36321FCqXLT71BdhXlWGCT2uX2Wv+NtU5gBvzJaE0wH+DdbIoHT+sdM
	 7qpK97zJmd8YFXQ3AIxLGaV+YXmAARUSjtDLV5emwmTg4sF7zXvF4pKNyBYf8YKH9RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JJqRyHIJjXi/+Y/uJoV9T8dkxllEm45WBsZgLy/kTwA=;
	b=CK4x4XZRLSQ1xUNgPdC2/X08Y1YfnMpxzA4CdHplblt485x75D6s+jpdmQUYMs835eo8
	 M+ODl2T2CdC25kAfDPUOcFbpUtXBnMmA8JHvJ4oKinEWiLNKrJLqKLnsI8hHPKyDbEJBX
	 hPUV90i/VRo1S2R6fhqfjPAJSw15p2OEC7A606WJ0D3DlspeopMuajEQyHoRHRKiqfru2
	 WnoRiXJE+FHQwVJW1645jF27n4unVcLjaDN/PEBryfQMSb2qTFgvggrD8gUSpKm3jB3bh
	 +g+RXTJirQeYc0V4eaBQtGe0l9j7Uxq204fLsyBFVG3OaS1Xbto44gJOcZqGh6Tv90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjKpl8ao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE5F606A31C;
	Wed, 18 Nov 2026 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjKpl8ao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD301F000CC;
	Wed, 18 Nov 2026 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028993;
	bh=JJqRyHIJjXi/+Y/uJoV9T8dkxllEm45WBsZgLy/kTwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjKpl8ao6CIVUp4+ppfnoH8Yvw5kcaBiVzx/TORqZHfqAi+iw3178UApZcC5DluJA
	 HwURatj9kbEAWZGrS6A5Nu9oaiKbTwT4MCfqQ6za1F9i1QP2kUuQauHOvHqEug9bFZ
	 dwbUMLLfetNOejl7p52VrYI62GepwJoJx4cyBnrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0191/1756] staging: rtl8723bs: disable SDIO function on block size failure
Date: Wed, 18 Nov 2026 15:38:38 +0100
Message-ID: <20261118150016.000158560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit baa84b1bb1648506333fde3e66b6540f9d7d73cc ]

sdio_init() enables the SDIO function before configuring the block
size. If sdio_set_block_size() fails, the function jumps to the release
path and returns the error without disabling the SDIO function. The
caller then frees the dvobj directly, so the enabled SDIO function is
left active on that probe failure path.

Disable the SDIO function before releasing the host when block size
configuration fails.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260731161710.44828-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 8432d13e7b125..096429afdd144 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -121,8 +121,10 @@ static u32 sdio_init(struct dvobj_priv *dvobj)
 		goto release;
 
 	err = sdio_set_block_size(func, 512);
-	if (err)
+	if (err) {
+		sdio_disable_func(func);
 		goto release;
+	}
 
 	psdio_data->block_transfer_len = 512;
 	psdio_data->tx_block_mode = 1;
-- 
2.53.0



