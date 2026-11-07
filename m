Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061927;
	b=Mvgn4l08udx7+UYHt0Z6/AE47vGa0OJ32XBmcvJArvrA/6wpT3D0RjWd5tTARUJ1kWA/
	 v6B9EIR0/NmnHGTXaLIRgUI3BXcEMuqbvLz8KDxzQ/n/i6armQl8NEYpojOyuZHP8eCgk
	 GR/7r/ExOgGh+xA7VARl6cVECLWOttCJfUrGhWAaudSEfsIXpPrPPu5oVG3ymnbPq2bkc
	 zI3KrT+lBo3fOVjITBDuX3212o7P0ApiZ+VSeDeT56io3z6VSbkZOleB9UeXJZGmd2XSi
	 oBrwS8fPQha0PYf5yfSnU9K4/P4TbLFGRH9o9YjZ8xld6xKiAGnVoWzey6lBgquT/1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RReCDIEnNVsQ8YO9UjRIE5Vu7EAs9sWTAun0zKhDvVk=;
	b=RlDz9LYYpi2bKCoVMM2Xerm86SYF/VbOsX4ohO5ygSS/YrBtZT7ou/ouAU0cxowHUm7N
	 Q6UYZ91sbllsLTIHrWOOeemN4F1Md0r71aOSLFs0qPLjn/g9F1+nPKI6aYvCrt0W/fARk
	 g+vxfYJG42aLkEXU0m8qU7/d5A/AfZ+3XTDQ4/RHcMFlukIUdTekUcDONgRhUU6yO1rsf
	 6VsgjEautFjwnWevJ6bGw+83fwJagKzW55AhG95MxIhu6qSAXAN0ABBEScdYUV0bah2hx
	 oAdZheg4XfRAgrLCBz954g5iwlxaUpjGYb4r40Tjba9lU8zoRJ2J6XCeIxmtbVZpVtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7Oq9pNw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D11606A326;
	Sat,  7 Nov 2026 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7Oq9pNw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06411F0089F;
	Sat,  7 Nov 2026 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061927;
	bh=RReCDIEnNVsQ8YO9UjRIE5Vu7EAs9sWTAun0zKhDvVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7Oq9pNwhBA3Oqi8KzNiOmmVu2X8/d1i6RPE8dXjQX6kzQ5F0r8ILA9RAAG4wgXJX
	 NVe7ALcfT9e68sj3qvd/BAgJWlHezpxWb8Zi8E1IVbXA4rDD1J6JfvuL8fnrjJ9LaD
	 L1J9U+17Z4TWskjbOxS6BDbnEpe4TqrFDEIoEOR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andi Shyti <andi.shyti@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0932/1536] media: cx231xx: Fix cleanup path on failure
Date: Sat,  7 Nov 2026 08:49:08 -0500
Message-ID: <20261107135023.824114900@linuxfoundation.org>
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



