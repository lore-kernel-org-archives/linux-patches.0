Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052224;
	b=huByQBkezEEqRoGkOBH2J7JtVi9lptZeC5U2xaqgvA7vk+WUbcf8B6/rAKOTkHU8Dfoh
	 AmGBcciO9slB7DqsLmABnd375yW1MCYfQCq96AVw+0FWCHobrlmEUwDPJgjInwJY1jzS6
	 84ztYU0R+Jvutweq0fv78QJ6AYtCQ3dVrUDkBDxg/bnKCzM+5WHyS2JeSdRRtFo/bIBJy
	 Ein/ALF13NmHjheEyxjCL4XyJSjHfarHF19q5WUMYzXdEul0hsqlErlcEruj68X/OFdve
	 W8wsQbahxfy2txx0W4bF8XmtWiMCsvCFD+uv6+fYulVmGorCqFdeHABrURO7ZXbdLkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRH56VKo4dWS74xDImHyulyB9zKfZghr1F+sZDF2+N0=;
	b=PHwVUUuPonLGkQ7noNJaeEScI+su5b3SsuV0+lL7vF122lWLAGjv+YTqpabQG5NWxm+l
	 2G55Yo46qFPHlCzN/s76cRuEcuYn+q0+wEFIbdmtpDgl0u8QPqaqaPnZTjpnqq6dq+RGk
	 ZF7TUTJ/vBfpc2nMe0h1QbaV8g/D31wrlWYokp4vl7/YoI3pEhm7mNgaZWk20oBO6HACB
	 Csgnx6bDnlbm/Y+1fdmgsi2OxGMmfzq7k/rds+LI7MkzXkTU2A34wMXxORQZ1gOF458UD
	 CtWST35K0lbakagBHC4+eiTRrGQwNduSYFNCU9wLnyXROmZni8XqQZpG7S5z23DmRTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YY48KAX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E62606A31C;
	Thu, 19 Nov 2026 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YY48KAX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82841F000C4;
	Thu, 19 Nov 2026 01:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052224;
	bh=sRH56VKo4dWS74xDImHyulyB9zKfZghr1F+sZDF2+N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YY48KAX4GpIfJUxH5DTnTjpGb8rAVWv7nyD5D9Q3aHiFTZj+azvm0d07h/w5+g+3T
	 K54rqMk/mPHtWf+LfeVoEc3W55XQEIoMjmyes9MBZ4K6eDpUWk8bUl+FruTXwxZifi
	 6d6545WbMKcWFx0eZkdoyBcSUmQ/JZosttflwWss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0470/2214] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150029.998258541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 5764f9bd7b7a72c6df49db6c8c00d4f9994a55ba ]

In sp8870_read_ber(), the 14-bit Bit Error Rate (BER) is assembled by
reading two I2C registers: 0xC08 (lower 6 bits) and 0xC07 (upper 8 bits).

The current implementation masks the lower bits via `tmp = ret & 0x3F;`
but subsequently overwrites `tmp` entirely when processing the upper
bits using a direct assignment (`tmp = ret << 6;`). This logical error
causes the lower 6 bits of the BER hardware metric to be silently
discarded.

Fix this by using a bitwise OR (`tmp |= ret << 6;`) to correctly merge
the MSB and LSB payloads before returning the metric to the DVB core.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/av7110/sp8870.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/av7110/sp8870.c b/drivers/staging/media/av7110/sp8870.c
index abf5c72607b64..3a9fbfc5adf03 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -384,7 +384,7 @@ static int sp8870_read_ber (struct dvb_frontend* fe, u32 * ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



