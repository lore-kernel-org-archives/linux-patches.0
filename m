Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063936;
	b=QBgW8YvsIl3LdEfHvqUxEHZQnQvBWCy/v5OiPtAPbjjGI+XRJaWeUGlpjgWiBWYfAcn5
	 HcPV9JJORiI0Z/c52QAt/VixmnhqRmoBBu0fDjH2nlamikJYxkP7BW94Oga9aD/Gw0+Bo
	 I00oEOJIJtuuxHrve3DJH3F4CCFvixqBFe6OPjmSjcWqvFskOXallz8Qe7Sg+a2l13Tez
	 iBnRCwCRA+X2yiVSysnemDKxpsDglWjA4BchwqVQe4SQE08YIlhuxNxEtNsLaicLyoNpK
	 LOB1pk9FcOVzNMljKbU4TAnuXYW3bPFlaZnGa/NF7bZLX0os5Yhsde5S59VDgYow1qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sw2uZ0ZoyMA6gu2SE0XoHQom9jAgKbMnbHiPTbQmk0s=;
	b=a4yNIJV9gcw8uGHlnFQJLTejQa3f9xXgz57KwOTwPnRI5IENbyYozw4pz8Pn57P2mn0t
	 8vOAtIxklOIy51Wj9WH3vEo5Te/YZ/syNlUpVzzCcsba1EI6b6Vnr8RPQLZoEDneVkzHu
	 RYKU/P6xZRLMMbv/hLYn+TE5O4+QtBXvcaaf7m5t/w8NJeoK1DRtTmKS/fCTqYwOT2f6d
	 Yaq7OZm7otTx0/p20eJpFjncyncZgZc+AYPFfFyVbBjUu2hjNvp6hgmiV6XvL/+dZ8Wrz
	 THGzJL8ucKVo8QRTHX72Mf1Gho771RzyNBCax19sEk7hmElM94JM+baTRw5SIPuPheg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WU4JzPpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07A606A335;
	Sat,  7 Nov 2026 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WU4JzPpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7591F0089F;
	Sat,  7 Nov 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063935;
	bh=Sw2uZ0ZoyMA6gu2SE0XoHQom9jAgKbMnbHiPTbQmk0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WU4JzPpG5/khrZEUvOnLwQ1fjFCDrzuLchLUA1vaT0J+zG83osZrv5hfbb3Zgxjty
	 varUnvqPGBYH5EVCC468qlKcTy1k4Lt4Jv6SNYJR6/pktVz/lNBcqW7b75I+dZJA80
	 Vn+Vvm8jpcy9PluvOwlv7O7hFacUMuSg6a3+ajVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andi Shyti <andi.shyti@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0089/1257] media: cx231xx: Fix cleanup path on failure
Date: Sat,  7 Nov 2026 08:39:45 -0500
Message-ID: <20261107134941.821491505@linuxfoundation.org>
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
index 69b24205bc567..b0941cd2a2d85 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1826,7 +1826,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	retval = cx231xx_init_v4l2(dev, udev, interface, isoc_pipe);
 	if (retval)
-		goto err_init;
+		goto err_video_alt;
 
 	if (dev->current_pcb_config.ts1_source != 0xff) {
 		/* compute alternate max packet sizes for TS1 */
-- 
2.53.0



