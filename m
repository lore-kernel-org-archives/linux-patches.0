Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061945;
	b=hGKss4j9Kp5gSRTq4U4UZamBD7xrYyOuKga+ehPpts7D09zMTCdsATmtoNPPDVpnAHIF
	 rrxCb5Hx5Q/YetEW8gDJovNwXWwhCg+XbCJZmjXmEAaFO8l+HGf8n7jfHp4Z2B+49Si4y
	 02B5ZyUTxwOj7qH8kryg5SJPnVavUzZMlSk6gPr52kf8gZczKjIcIN0IuqTqNUmDotHed
	 fNGy/pq97VeJHTn5EIySWcahVn7r538gotBpPP4LD4S937xibiIbM/LFAJdipRrAEv2NX
	 EB3xv1XqS8HIuh2/OzpzFgr7XQzfcssx4cBcHKf7e7+GHbWJCBvps0xJWja88JzEdvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=09iiJHh8llfl8ZBkrBEhqJsQiL6YevOeKeoILlEWIZg=;
	b=G3L/xQ1gKLgY/RuGmlkHUirQdzZDUqzVTsXF2z+vCH8rRb8vfM95D6VmTTnUw3RjejpT
	 LKeTeE4W++7kRFjkTGbyEdzKirkf9iqybboy5NsSyNQ1/Z6aXkz/pWyb2OPhDpdY8tSVl
	 PQnLyOq0exG4pRlBA23XGXKiZCvgCdfvPeDpajmkwYu7jo1IEQ5EK2g+5dd5A2FRQL1O6
	 c8MWvi5urOjBH0VLArMV0GbOaipONo01T4D+dYFIrI/hXqGJMqEA1l0J4oDELw4tYcaEy
	 jLnMqrSQqy0OdOZS6mBGs0u75n7046Zpkrc0J17D32Y0BnS9UBC3SniSUcLmqh9fMHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQYmtPkM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9586F606A330;
	Sat,  7 Nov 2026 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQYmtPkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B561F0089F;
	Sat,  7 Nov 2026 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061945;
	bh=09iiJHh8llfl8ZBkrBEhqJsQiL6YevOeKeoILlEWIZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQYmtPkM0ccTZ+TvtAFjOv14aJGizOVvvcOp/+OWmKkN7Kg7CWm2VrQ36J1/xxWxv
	 HlbGBfVi6tNxLgHovJvBsBhvHc7g94emyoE6ImbYz6Va1F9+YPiAaUdCpclVyaqB8G
	 T8UbrMJS37OrcgEfqkCE4//hc0x50S7incEIsk1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0944/1536] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Sat,  7 Nov 2026 08:49:20 -0500
Message-ID: <20261107135024.166397162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0c813860f5b20..96fd738777744 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -401,7 +401,7 @@ static int sp8870_read_ber(struct dvb_frontend *fe, u32 *ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



