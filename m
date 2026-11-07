Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063903;
	b=Id7RIMTcZs16GnKPWw2S5mcz2fyuSBGoL9hJMRixtTJlp+CjwXqkNRmsgoXg+AHQZN0M
	 bTryGjSGMB27l/HMA1boWXMYcaSYmiaeO7FRXEEQHIAfrper9Q1P6rc3Z4fus5ErSimys
	 kLY8a1aVuZ39e8i4w32zBy89oNsok9Jny5wgvaQAnGMh6oA/F37SOx6bGseQxUih8YwJQ
	 bnduj78ywF396UItpedr267yzK9dgqlhWkymA9m80qbInoSt5KxTUvEa5urqtmsH1Il/d
	 WngjiGv2NXI/5iW4tgzSympN9D8KzMDGi7NUAbyNH7lUpJpxJ1v8ILRanAjgoZphcdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e3Nm1NMslRAu2iQ1czsVB0XvOZ4EEvNwGjYmwlrl96U=;
	b=3/rIzfpd5Nn8R/GNd+W+RLwbG/2NitLfy+YbsWbv0uA/viX8lQNHqSYoG4xC2iVt5qvP
	 lJIeklGeDryIjKt+/OuiF76qH1WbuLob16cBP1gNoKL11F3BKqRal0oZteF7afVCEteoN
	 FD6ih46HYiLz3zjlZme6nznbXn1aJZEAgPHwCihuw/iQMkD/f2tFya8lH1LwkxJN+/1QJ
	 0VkKjJ7v7Fcw9vQg+If5Vvv7UFmvpFCDjAzbKiDMyJXWst5akLBvh/k9TrrgqyB/yklsv
	 vSHA+S7btzHhm1XYOjIm0Rr0Txnd7MFHr4TG+8e56WBAxZQ1cTCb0K8cbFpfoTlD7Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG+lEthJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860D7606B8BD;
	Sat,  7 Nov 2026 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG+lEthJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333101F008A4;
	Sat,  7 Nov 2026 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063903;
	bh=e3Nm1NMslRAu2iQ1czsVB0XvOZ4EEvNwGjYmwlrl96U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rG+lEthJnaCJ9bgV2ZQhKkIRiPZHzn7mmKbH+t+ktXABojem+CEUZFKiGvQzTfLLC
	 HEbeS74I5QYpVJncKT7Omkzq29Bvrud1dBLb5s1aln1FvNHhYIxDaZ9DcZ1Pwrv6It
	 Mayd9/w/WrDZLG4I6tRIY7CK3qwqrTRPJN+dMT48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0103/1257] staging: media: av7110: fix sp8870 initialization failure state
Date: Sat,  7 Nov 2026 08:39:59 -0500
Message-ID: <20261107134942.203157228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 30684fa98394bc0eb4362282908612aab7d4dad9 ]

The SP8870 DVB frontend driver prematurely flags the device as
initialized at the very beginning of the sp8870_init() routine, prior
to requesting the firmware (dvb-fe-sp8870.fw) and executing the I2C
upload sequence.

If request_firmware() times out or sp8870_firmware_upload() encounters
an I2C bus error, the function aborts and returns -EIO. However,
because `state->initialised` is already set to 1, all subsequent
invocations of `fe->ops.init()` by the DVB core will immediately return
0 (success) without attempting to load the firmware again. This leaves
the demodulator microcontroller halted and the frontend permanently dead
until the module is forcibly reloaded.

Relocate the `state->initialised = 1` assignment to the end of
sp8870_init(), ensuring the flag is only set after the firmware is
successfully uploaded and the system controller is actually restarted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/av7110/sp8870.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/av7110/sp8870.c b/drivers/staging/media/av7110/sp8870.c
index 77bebf2c7d5d8..be62933cef450 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -315,7 +315,6 @@ static int sp8870_init(struct dvb_frontend *fe)
 	sp8870_wake_up(state);
 	if (state->initialised)
 		return 0;
-	state->initialised = 1;
 
 	dprintk("initialising frontend...\n");
 
@@ -353,6 +352,8 @@ static int sp8870_init(struct dvb_frontend *fe)
 	sp8870_writereg(state, 0x0D00, 0x010);
 	sp8870_writereg(state, 0x0D01, 0x000);
 
+	state->initialised = 1;
+
 	return 0;
 }
 
-- 
2.53.0



