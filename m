Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062770;
	b=MRm4pPZQbw3kdQ87MQCkYzYAZ9LEGE2XLl9GG9ds0F0DSd5KWe08KHcNzgGrQimcPY2N
	 8CyJ5D2akPSOC7uCBowMGCh0MmkEALAJOu4gSvwdlWyUMCc+iJp9ljkqNcgDJDWVQ8quk
	 LdtpcEoTUApaINP4qmupyuoXZVTzF/9NqeFhr+S7XhElKHCjAU9npsY1haqg3Lhev8muY
	 DmcJjUxcf5nd9LVdUbLk0bysqvrZHU/oGCS40+zAxc5vDEE302pmUIOPQ+yGqjrcLY13t
	 yDRLwLJSaYqHBI7XiR5rjxpAR9prF5QPotkJHHaRYoG8oXER4ZwkyYCJvHD20kQKVCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMpDK/3vlgCVrv9YLW1YavrlcfSPc6WvjdBYp85ZKjQ=;
	b=1nV/hvsTfG1gFf9EES1r1TuNDeWLXbh+0fpMXatslY4F/3+ZU2dOMyS0UKEL+EL5VOc1
	 B3rpScrV1qHoUCrKYH0qCQ3q1AIoNd6K8haGTLKfZL2Wn5AKXoA76GdCOxx2TdKU18cLF
	 0Eel/1E/R6G8u+SJ8/IiEoAKL+Bj8J0iLTTwM/H/BP/0sX/+JDT1iR6vVcbJFyT/4iocd
	 6XrPj4e9zChoFRsZKgHg7mHJANYBHfZhxGhAyoqba5Ctgpn5IHry8/Fmx8LBobYw1KqTh
	 04EDSbS8urqwejLxvrg7SdepEciQrCuISfjJQ10CyuNO9hGFiw9Oqx/64CCCI4kCCDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlBsTaak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF07606A32D;
	Sat,  7 Nov 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlBsTaak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3431F008A1;
	Sat,  7 Nov 2026 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062770;
	bh=VMpDK/3vlgCVrv9YLW1YavrlcfSPc6WvjdBYp85ZKjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlBsTaak/cTKeqPZZqqKtMsUI4Z6kI6l9ytEXoR5JAUKqnNqZcpGEIgoADgKiYSfH
	 QR5GUiczzeaIf4+hj+wrDpwGy5p56+X3GXpwPieWyKTZXvnjCrGEYv2iWove/w520q
	 oIuLq1PI+4IF/StX/Do17QDGLLlz3Ng1dffCAXfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andi Shyti <andi.shyti@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/869] media: cx231xx: Fix cleanup path on failure
Date: Sat,  7 Nov 2026 08:46:00 -0500
Message-ID: <20261107134855.377931330@linuxfoundation.org>
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
index d96b9ab276b76..1824e36e541f8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1828,7 +1828,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	retval = cx231xx_init_v4l2(dev, udev, interface, isoc_pipe);
 	if (retval)
-		goto err_init;
+		goto err_video_alt;
 
 	if (dev->current_pcb_config.ts1_source != 0xff) {
 		/* compute alternate max packet sizes for TS1 */
-- 
2.53.0



