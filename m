Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052150;
	b=xABURzGf75gcQCuLiqyYIt4aPVGfn2GLyAen0te8tAyHxM1i1x43HGcAPv+Zl5KB7c6P
	 L52FoEqDkn5FU4+ttaXUwlRdWW+T4Pf7zQ2qL5FlH26QpLq3pkpyPd859OPRHqSdME2Hb
	 ur2VnwOLmLvxsAEoTfs4rQsXnVptukwpcI30PP2ETknp1naPZoaCDx7RckBXo6efl0MNM
	 BxPt3GyjiNrsp2fZ92sbyFez3fOdEh/gzTrnd+GTrsKYu7oEz3epGXir7bxcxKYu3DKJ+
	 3l2ZdfAvhOL0bsyy7518qhFUR44oqmdetnDB+/S2tRCubHXT6QXADaa7mqDE4wWxPpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIDpklTizX28arGZ0GHDE5L+DHdrYDxvgIWL2pYkjHo=;
	b=ck4io4cu4zvUx/TDDhcUqcvRCLvBDBFist/UQQfNtOL+2E1xOQEuMq1xSeJygEWP+0kB
	 lMmpLbGlpOliRrKvghjxHyZauagqb0FBoTTch1IOKLus1SXwIxdiIb4SoP7h/cmsq1LXN
	 SowEd0JzVOTaBEflDFZWS6Fn+qYP4o7OQub9ntxcF+W/bpirH6FWAdfTn3SN5JeF94r4s
	 yyx4I4IJAlCajDO5WB7YahmAOaPzTSLh7aNvtyg9h/bxTvmoxZQIwaJZ9aYnZbe8zhCmK
	 tvqGXD5eqIq7Vmvea96I3pBf9zE//LhX4Ir3IRpoQwn4ddvPnTIg5Ma08fqEeVJ9J0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=utp8pZ6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4112D606A31C;
	Thu, 19 Nov 2026 01:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=utp8pZ6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BA11F000C4;
	Thu, 19 Nov 2026 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052150;
	bh=zIDpklTizX28arGZ0GHDE5L+DHdrYDxvgIWL2pYkjHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utp8pZ6cxFeua7Ah8vWuENXJcEmn0D6/jo8YW1q4GBxw34ncPs7cTogs+zK1rYt+i
	 3hlkU6l1Wq/anouagm7WvF8CVucz/wzYkEzD6H0ZPBI5kbnWj39AGCjtdDWZtL95Dk
	 pT4sHdyOeJhGuAVeucBxgFhypW9p7WsGwPI1TX+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andi Shyti <andi.shyti@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0459/2214] media: cx231xx: Fix cleanup path on failure
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118150029.595478738@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@kernel.org>

[ Upstream commit 6e30287eaf3e41b86dfb86df3b811526693d74b4 ]

If cx231xx_init_v4l2() fails the probe currently jumps to
err_init, which only unregisters the V4L2 device. The analog
devices and I2C resources are left registered while the driver
state can be released.

A subsequent driver bind attempts to create the same I2C mux
channel links and triggers a warning when the existing
"channel-0" link is encountered. The remaining devices may also
access released driver state. This produces the following warning

    can't create symlink to channel 0
    WARNING: drivers/i2c/i2c-mux.c:403 at i2c_mux_add_adapter+0xcd8/0xeb0
    Call Trace:
     i2c_mux_add_adapter+0xcdc/0xeb0
     cx231xx_dev_init+0x2fb/0x1260
     cx231xx_usb_probe+0xc48/0x2140
     usb_probe_interface+0x657/0xc70
     ...

Jump to err_video_alt instead, which performs the full device
cleanup before unregistering the V4L2 device.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://github.com/farhad-alemi/public_bug_reports/tree/main/185-warning-in-i2c-mux-add-adapter/
Fixes: 4d2a7d3509f5 ("[media] cx231xx: move analog init code to a separate function")
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 64c3cb8fc2bf0..623c3106ef3ee 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1830,7 +1830,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	retval = cx231xx_init_v4l2(dev, udev, interface, isoc_pipe);
 	if (retval)
-		goto err_init;
+		goto err_video_alt;
 
 	if (dev->current_pcb_config.ts1_source != 0xff) {
 		/* compute alternate max packet sizes for TS1 */
-- 
2.53.0



