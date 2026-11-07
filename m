Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061948;
	b=XOZaVq3Zf743Iw72CC9TgbvGpuSWkhsobKa692m51o4uOUVHdQWr2cwr4JZKLWi/Vf7+
	 8FhGAfxDqs4L2RLhXly3/YSH+1K6oKFm3Lj7Mrt9n4LJwYf8OBxKmjmXoeJ1zjLCWDwCx
	 9S2WQbobEcHVONLvabFJ5jUiPqMe9aDmJm+Au+FmlVVOvVIaS0VKNIQIxW3LsCRNuZJ8u
	 g8Pd1QkL16odCvKZ+FbusbHEshyoVfUXqShnT/nxrOb93wxkhSh0BhLTPCkr35ePESzsT
	 ogaDuSNH/vM2jl5TmSjldPdNhErDlSN59kn+TmIU+JYuefVBsQj25m6dVZVV2d2E9nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xbJPJo/Hztz8GE368rgjIGCnbkpww8VaDpyhrKKYsLg=;
	b=YO964J1N8sVQaauBLN4TMlAdyUMn7GjMo7tCg8EKQwoW6ROfeDQp/Sdij/5YME05siNn
	 zC53ohlPoilmmHR/w4S+CUmgF4rL0X+wjB8WAQHszE77qkBOVa+6fE4fy5JsZBl1JVnVz
	 eDElpoAGFmehFS9Fc2YmfC1pny98WYd6ATR4pAEgtK26sg57AwL+2/KZFXLP0Zwq+eSZ3
	 bICi/7+IX4wlB7sTEOZQXWJSjhs509vfW4NCfMGm4I14WIXm5y0kcigDffKN0kgsnOjkx
	 5ZboLHPrTzdOMMVaoFUW8A8DmAeFtjtsG5x6ZG2w4kISZRthkR5ttvotySsj4pGIyUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsoeyh9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB2606A32E;
	Sat,  7 Nov 2026 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsoeyh9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA27A1F0089F;
	Sat,  7 Nov 2026 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061947;
	bh=xbJPJo/Hztz8GE368rgjIGCnbkpww8VaDpyhrKKYsLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsoeyh9NKUMc/EEDvRrbhHIjAqzx1oFsenNbAGOxbAqYES4Gw7rZzoiw27Hso/fHC
	 Bz1Sy+LrvoZrrPT7ngxmrMAJf2jRND9S5PX/kLLPoSsMBMUDOwHf05JPYkcIlAShJH
	 eknDi9MKPGZoe+572wOX6JgjKryYXSayu66th94g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0945/1536] staging: media: av7110: fix sp8870 initialization failure state
Date: Sat,  7 Nov 2026 08:49:21 -0500
Message-ID: <20261107135024.196887249@linuxfoundation.org>
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
index 96fd738777744..b5b49f1ef5e7b 100644
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



