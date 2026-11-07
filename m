Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062784;
	b=EcARyulClJePtljxaUmfIbFqlofIM7lhrIYX5ME2X3+xp5PvUGQSni6DG1ahxMgsLNC1
	 ebhKpBvZoNgJGKqhR2Mv009zMEcRSZsYczZ9R20WGwBae5x91wEA6rowb5zjxN283wAzF
	 9MSsMBRa1av2OztzFctQqlRgZx/ciSPMi+5NFsC8zg5+RpelYIEQxEc7g5EINTqPp76ru
	 4wCWtY36HWM7wIoUoKySjmFUk0lZKwEl1Becr7h2fzkZHkQe+H3GFnGu1RIFJPJ7LFmDZ
	 t1WWJTaFv88wEdKetPBwpRVuA9gGb2Z1dtPL7+MNv1ciwm/7O/9P+6FGNL7c671Ex2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJpqWIu8sxxEnzY+PjJeyS3KSwuQquJbtIiKIWjnA+U=;
	b=Vhpfg87/91p3Y2Ub22NAuqHh+z2uAK1B/pLMDwItvjXHTDtvEl/KF9PNh9v5IY3nfIMr
	 v/088rylXOScuezEG77GGv+Slo1J3f1I4fDZpfWyClJLe/Eudk1WIknLtFFEHGfKzUQqY
	 Ct9xjwEWP8j5LcEz7sCKNA5olhAcGKq2Iu+rO+Jb1OuaWTXpwPETUPwFpyP/O8pJB2uQl
	 KU6/djleOZi7XffjVIHgdFAE9vTZxRWybewGdV++dYTFrU4lMMdX0Y8MnjMEjvS0p7tx2
	 OylF7uRHrj80oS8f2FZ4P+HudR+NkDtACgrvXK1lP2R4tnkVm8rj2cHU+2Wt2Ou4cyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuXvqbkW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADB8606A32F;
	Sat,  7 Nov 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuXvqbkW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B901F0089F;
	Sat,  7 Nov 2026 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062783;
	bh=EJpqWIu8sxxEnzY+PjJeyS3KSwuQquJbtIiKIWjnA+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuXvqbkWWajQnjtNHD+bVycCdfBf/9D96EB54pp6XdSU4e+XU/c5II76ftOb2HRjB
	 rjpjPz8HnYqbT/kcsBwQVlqSzQLx4tDmNYv2hO1A2IZu4Q+js3S1kSKcnS7ijc0/y3
	 bkZge6nqmJVAj/0hrsqkCHgW/j/ENXw96FMXMlXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/869] staging: media: av7110: fix sp8870 initialization failure state
Date: Sat,  7 Nov 2026 08:46:13 -0500
Message-ID: <20261107134855.797942326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



