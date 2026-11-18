Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038147;
	b=o6yCC7yVfRZM290WluihfkQaJaN7X2LPfdODCKZwwGFhYH5EZ9ObnhaEJHwi+CF6pkJQ
	 D7PmhrWEncfuaMMvNAgJnG/VamvQzLzBijBuk29Er6ktGjW/WKcSTfYNbu+EX56Y/ppee
	 +81VQQhOMrgT0iw+Y371ePc6KEU/y5jxjq2bnlvHsbk+rvD87GVlDs0j00qFdxa7f2DwA
	 EdL0fAAksJnYxp9NT5PePTjreUFBj/hzPEvo2TZB+HKjXBnK6pZcoxYZ27J/xilTRh7jE
	 t3Wx85ToFTITlAkutvO+tc73l+r7ao0Z3gpYafVTZS65tK9AsXytzD0r15BxbmNJRDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NMbUiyl8i4PQed7bPuaehTDq7CDb4QL9eu2p9rOxp3I=;
	b=Ea0KUxrnUHCYWmLerWuWS30/fBFBmPrqbnOFpGuwM42MKPDmEpch4jrXPCzRlNOQ93GS
	 Sy1E9Nz6HIJfTqeFe/zXureZtAxh+MW2Ognqswu5GvmL6fK04f7jPNGkaeqe07gJ3mPIp
	 o2BbZBue0j/vVgCJ2hXx0GsIhxY0ExXx9fUpCbe3+WdzlSTVshyNpoP4/KdJ+vdhuw8B/
	 T8etUcEUBVewG9U6hlJH0X2FfxUCWmTjDVTyXV3MPFyP1R6eB25qFgT6jxMQ6a3lgzASG
	 42RJPzsq2KYPmOwcWbRF3KVlZFvesnEPX7yDcPbVRyeOeIdwA7fqJyDy96RdGkB2JiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R3oX/GVr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A286606A320;
	Wed, 18 Nov 2026 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3oX/GVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87691F000C6;
	Wed, 18 Nov 2026 21:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038147;
	bh=NMbUiyl8i4PQed7bPuaehTDq7CDb4QL9eu2p9rOxp3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3oX/GVri/Zum6ow3/3g0nPJCabLjawTrbthum4gfLFbhTronQObyS4hiZxOOYRCr
	 fDxtVZ8q7O9w79W9hrwuO95OMXYwSGYPQdpaxzLB/o8mKopKa4+r9mc9DAixfFru6J
	 PB26fJhgiE5VctDZvDt0f8U/KRS4bTlKKkfyQaYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1641/3318] staging: media: av7110: fix sp8870 initialization failure state
Date: Wed, 18 Nov 2026 15:37:43 +0100
Message-ID: <20261118150410.992686984@linuxfoundation.org>
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
[ sashal: Preserved the one-line initialization guard in sp8870_init() instead of upstream's two-line formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/av7110/sp8870.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/av7110/sp8870.c b/drivers/staging/media/av7110/sp8870.c
index 3a9fbfc5adf03..de70953014114 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -297,7 +297,6 @@ static int sp8870_init (struct dvb_frontend* fe)
 
 	sp8870_wake_up(state);
 	if (state->initialised) return 0;
-	state->initialised = 1;
 
 	dprintk ("%s\n", __func__);
 
@@ -336,6 +335,8 @@ static int sp8870_init (struct dvb_frontend* fe)
 	sp8870_writereg(state, 0x0D00, 0x010);
 	sp8870_writereg(state, 0x0D01, 0x000);
 
+	state->initialised = 1;
+
 	return 0;
 }
 
-- 
2.53.0



