Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331412ED16D;
	Thu,  3 Jul 2025 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555188; cv=none; b=STb2YZJmiu/FsDwUyO0uPiPG119AlMBHNZ7WOGCP+1N5vfR6bCk9jKP/LYTM8b6Rh0vr20cuEOdnPwobjRaqmRGugtFFvWXDdW4C4Pfh3oNH9DUhvPKWbMyVt534/OCdJgEg8oCLefQL5P3k49dsu5TiKM5+Dy5oQeR0ERtPQzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555188; c=relaxed/simple;
	bh=uua4WHZiAJIy93IXMpvjgRIllZhuM5rljvhjy3r1XD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0IHRwcwuNlERwoJFsgMA80OdAANLwEZibdJ2CTcDsHpBVCrLxKx1YJ3s0dkRKl9PVBRkEhfEX5HJhL8v2Emjeoz6LBtmHmDdL06g46cXz5DjNg06pr0gTX8BB7AvigQ96SneqItOLDsjxg/IX7vxnJJYMfi7xN3yz08HA4pHkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIR9mt4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIR9mt4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95043C4CEEE;
	Thu,  3 Jul 2025 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555188;
	bh=uua4WHZiAJIy93IXMpvjgRIllZhuM5rljvhjy3r1XD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIR9mt4p6cZit39mLVyK2bFcMXLHJqBEbPAnFfvUZaJNOuiRULyW2CfHjyR4zwMpt
	 kDwjrT2HNL1l7i6XiwSLaivI7B2P6Jj7agwo3RrKBhhT0ZuQeO+3SCaZ3PbaPR7Q+5
	 MkR/oARoRUAQfG1mcU3EXIv+G7qGkw0NrqywvETM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Adam Jackson <ajax@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 6.15 203/263] drm/cirrus-qemu: Fix pitch programming
Date: Thu,  3 Jul 2025 16:42:03 +0200
Message-ID: <20250703144012.510024658@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 4bfb389a0136a13f0802eeb5e97a0e76d88f77ae upstream.

Do not set CR1B[6] when programming the pitch. The bit effects VGA
text mode and is not interpreted by qemu. [1] It has no affect on
the scanline pitch.

The scanline bit that is set into CR1B[6] belongs into CR13[7], which
the driver sets up correctly.

This bug goes back to the driver's initial commit.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://gitlab.com/qemu-project/qemu/-/blob/stable-9.2/hw/display/cirrus_vga.c?ref_type=heads#L1112 # 1
Fixes: f9aa76a85248 ("drm/kms: driver for virtual cirrus under qemu")
Cc: Adam Jackson <ajax@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v3.5+
Link: https://lore.kernel.org/r/20250328091821.195061-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/cirrus-qemu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -318,7 +318,6 @@ static void cirrus_pitch_set(struct cirr
 	/* Enable extended blanking and pitch bits, and enable full memory */
 	cr1b = 0x22;
 	cr1b |= (pitch >> 7) & 0x10;
-	cr1b |= (pitch >> 6) & 0x40;
 	wreg_crt(cirrus, 0x1b, cr1b);
 
 	cirrus_set_start_address(cirrus, 0);


