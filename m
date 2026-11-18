Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046835;
	b=Y6y3F80KlcyH7duMtDofJvg+2WOUXGbPjF6meRwNpFB0v6i2vYajU0drWxEMnEpAlNB6
	 wIpy9+N3dLymaIoyt8ptI101eMeDPZOgtreh38bsBapuERDZJU9Y9dN3NWGdAI6B44VIw
	 eW5RGyDvGtpPfWab9irUjSWZ3VJB5lmBqPFYh4z+ZiPv/gVLnC+GNhOnIFfkS5i75Uo4P
	 U2AcKKJ4wIRA8VOUXaLOyyT8Z66pSGjLP1GMvWH+uxQ2/orlMea9BPCrWkhi2PuLtZ4Av
	 YDKm34PzKUXcZrAB3GM33rf6k3C9FH2KRuUftmYQTCqEUcuIlplPPXmfeJPMkfOn5Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R56YxOUrkmwaug7gH6YKTZqD2XJUCOfvh1HhqnCykic=;
	b=eKO5Z5MO0XIZwMTAYYRpnjRWpcfUgqRwidypu3wUqDcYIcBb1KOjNfvX4Myo9U+x1iZQ
	 0IJ0yXJC682PbQ7cM/mTDXr3+cZmvhtg8huBu/pzvl+sic4kX6FgiQOzYScNJ1alToAnx
	 JIqHt5kQGaxDVdJB34oXieRx8/WGeMWEoBvrcil72Cc3T6p8+9d8zfopaCMwI5YPqMe9u
	 yaDbsVw2nw8UWx3Nd6ePSKfPUbCi8S51/XbekJ0cxyf0JkZF+0ZI8/dAJkVJez3u3SFT+
	 5FNbrBmupQ64U1wXvIVzGK+QkZQJN0i1gbwHw0nCSUVx9Ax2YHtHSCWUSkwpVnhju5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/eSQ8M2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2FB606A32C;
	Thu, 19 Nov 2026 00:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/eSQ8M2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03321F000C5;
	Thu, 19 Nov 2026 00:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046835;
	bh=R56YxOUrkmwaug7gH6YKTZqD2XJUCOfvh1HhqnCykic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/eSQ8M2KK1aAn5/wZ+KZmwtjx3c+AUBJfVJn1+z9dXdT8lewuAXrFc5k+7Lqec7F
	 201WsWQjKM0UBN5/zIl5NGhb3rh4kZFyl0L3KBjN9WfUGJHxoBJs6aSUU/vHnf1ZTh
	 YvdzDRn0I807wQVGoZvKZ23FabXPtkiRmDrCQbjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1383/2857] staging: media: av7110: fix sp8870 initialization failure state
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118150251.167635761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted patch context to match the relocated driver's existing initialization guard and logging. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/deprecated/saa7146/av7110/sp8870.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c b/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
index f68479e75e462..3e05ef983fafb 100644
--- a/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
+++ b/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
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



