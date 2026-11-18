Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053662;
	b=pzhSNwtZwl+nllibZcBuQEUidLwGIgkseAiYT38iGoX8ZmjK0H4xtkanuLddJ7ZxfT6I
	 MR+H/kwy6uR654WtWskK/sVafe/b/lewfjoAnf1UEjaIIpnKP9HM8PwZ2YNvu2hZAxLJa
	 4lRx2bXlmcCeF3VRchbe4uVkuN2M9OjN7DwwFE/8CnJAJT4BBHhGCsqWbiTz73aEmNDas
	 K80SFDJCU54skR82t1n3zJRxmeiMzkP+N0NU03mBiZmva9n8VFRxb5hnf9RarlsHUrn/A
	 85VxFPGwFrimTmDFb9I/xJIwMgZ7NzGEUXbar4+AcX/ClCndnHOSAP7TVjNXOm5a/tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0lPX815jBcYt64Exo6WCdCMc+3ovb8Ky56OXp3Prqg=;
	b=5erTdijuAZ42YNvoi1Smse0VQWD2VgRlKd1GOPqS+H0WcS7InqWiqo24HtsfiBahIl7Q
	 S+PPgR5/v+STYYW5Q6eUx9ZQ/wqTeA/VFRPg1oVL+8NxW2l3wJkl8Eymp6CxEhQUi3LlJ
	 S+tM0y0HaOfqg2LtHIeOBSUAHI3wLWnygOcR+oJIiSem+qdrgZq3ODIiP9g7RUwL289Pm
	 TILjEeH9HYAMypAP7zZaWKdEiqUfyFPc5H1YUACCThH9gV4jh9tBmYXxCyTFRkp8pN5gI
	 fwGzp5vP7L+HDUMakeuZ40C0ZF5+ZvzE6l/BinBFVM81QIjv9N00sKGlkDnu/O/Xl/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArPUxux5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2CE606A31C;
	Thu, 19 Nov 2026 02:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArPUxux5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450561F000C4;
	Thu, 19 Nov 2026 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053661;
	bh=B0lPX815jBcYt64Exo6WCdCMc+3ovb8Ky56OXp3Prqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArPUxux5ZRbyq19dAKjjz/BkZoFbsaLJh1ot9zWvR63xkoPuYhRUixgEfQ1QJP8S5
	 MAeL8HrXfRadL3xUDaqKLnwgfiaDW+4yaHMC5Di6kuYVJGom19Igekjx8CYYIZc+X5
	 MQR4txAPnBS3GuWzmvGB5Xn2DumLG59U2TwS4HkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0998/2214] staging: media: av7110: fix sp8870 initialization failure state
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118150052.312719923@linuxfoundation.org>
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
[ sashal: adjusted context for older sp8870_init() formatting and debug output ]
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



