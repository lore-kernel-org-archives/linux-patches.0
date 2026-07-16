Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76193FC5AD;
	Thu, 16 Jul 2026 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209657; cv=none; b=f4tT7PM4k+Hk5vDmI740kD8JA1nzf/uxxLn09QqJjcUlUyBYqjNKKNKGsMho0FHjtNJHs7eMUYoCGENJ8WpvtWxir/JRm4fn3Ad0y/9L9sXRhxykFvqRUrmfESV0kKsOJUeKap562cYgIJsyuPaukeOeNBId/JrO/EUNEcmEzcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209657; c=relaxed/simple;
	bh=mhSoqZBsgNzbSna+3DTwt9OyPJIZC2yP7MpTE32cBnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DiTFctcQ2BaewX+tLVxLNXlNTPW4jTfvxVuQOABa+b7lENraYdInw1gtWD6G7Ypajih5Nxe5OEHdoK9P2Do7x9CXexlqLaO99UREyv2E3T1FuNmt7TrDsz3DZLRL9aDyRD4UW6yqepdiSXtvMRe2HHAdsF4rLtlfeoT+AotDBmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3vLYCvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3vLYCvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A5E1F000E9;
	Thu, 16 Jul 2026 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209652;
	bh=rWI5r7qDXVO0q8D6YhtmV8iHsNzQ2o/Fcg7OnssWjPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3vLYCvtvL3FIH+SDf+FOhJOngaBQD/JLakxgfLq9hm9y4m8WzFSo3Vlmz8BsnBQt
	 TwPOCxqu+IVwbL5MQdT7HgvNaC4rpi4MWOR4p6kCrclf2DLWLvczeuuKe1scEPEKpe
	 iYeOMFz+ljbRGzbCWlEAkLZLbbE3DTZjEdOY5qOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Roundtree <oroundtree1@gmail.com>,
	=?UTF-8?q?Ryno=20Kotz=C3=A9?= <lemon.xah@gmail.com>,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 268/518] HID: pidff: Use correct effect type in effect update
Date: Thu, 16 Jul 2026 15:28:56 +0200
Message-ID: <20260716133053.680975129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Makarenko <oleg@makarenk.ooo>

commit b251598b8bf37300510868f739a79e07800d41ce upstream.

When updating an existing effect, the effect type from the last created
effect was sent to the device instead of the updated one.
This caused incorrect reports when a game creates multiple different
effects and updates only one that is not the last created.

Fixes FFB in multiple games that create multiple simultaneous effects
(Forza Horizon 5/6).

Fixes: 224ee88fe395 ("Input: add force feedback driver for PID devices")
Cc: stable@vger.kernel.org
Tested-by: Oliver Roundtree <oroundtree1@gmail.com>
Co-developed-by: Ryno Kotzé <lemon.xah@gmail.com>
Signed-off-by: Ryno Kotzé <lemon.xah@gmail.com>
Signed-off-by: Oleg Makarenko <oleg@makarenk.ooo>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -522,7 +522,7 @@ static void pidff_set_effect_report(stru
 	pidff->set_effect[PID_EFFECT_BLOCK_INDEX].value[0] =
 		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 	pidff->set_effect_type->value[0] =
-		pidff->create_new_effect_type->value[0];
+		pidff_get_effect_type_id(pidff, effect);
 
 	pidff_set_duration(&pidff->set_effect[PID_DURATION],
 			   effect->replay.length);


