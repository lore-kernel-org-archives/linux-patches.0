Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C8415F04;
	Tue, 21 Jul 2026 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664454; cv=none; b=GdfoNPpMba9kNts5ijkzJnO/7bpJxsEUedaLRCGAW1U8XcgoDJdy7DzcfJ9JF+8BzXaak68EvSl6W31xWj7+3VlJLou7dHp4b9iD8rpHdNn8chTlKcfbRSvUEFY5gYfdOLIDzvJ7iN1nGuwlDtjTej447Y0xZwQGXCQ2obVN2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664454; c=relaxed/simple;
	bh=qOv9uZsm+NmnSs98zLWPWMp+8WQHuz27Dby8RBkb+ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xo55KpSYptGcJAjfgNBW4XehB0QYBPt32K6FOcVU7NYNPTxgRCMpGHEvIswIALhejREXaExH0G+KjoV8hTsE2m6UhNdGZsATZy5uXOt7zsGUJ2F0U7KiM1wrnXu0xRIxC8b0aN/DeGPgzAw0YRYlzp2jcQPjH7Uy+5yZrEMEg8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08Huz41Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08Huz41Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256681F00A3A;
	Tue, 21 Jul 2026 20:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664453;
	bh=nBVPtNaEBDqeEiQ7KQO1ZXG+awYD2O/MrkLEdr2F/7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08Huz41ZpMBN/q1RVzvPpko7E+Cuhh1OmeYmkZdB1YF88S05aSv6LmRW51fsRtCcv
	 Vv5R6hp/B4rr+rajcCzYWZSzKluc5mkiBWKyh7TeXwvINvj4Iq4z8PqcyfnWGahV+Q
	 KbKYoK3UJBJjMLZQ2C5qPdFAKCyProRVx/qT9PJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Roundtree <oroundtree1@gmail.com>,
	=?UTF-8?q?Ryno=20Kotz=C3=A9?= <lemon.xah@gmail.com>,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1199/1276] HID: pidff: Use correct effect type in effect update
Date: Tue, 21 Jul 2026 17:27:22 +0200
Message-ID: <20260721152512.892511718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Makarenko <oleg@makarenk.ooo>

[ Upstream commit b251598b8bf37300510868f739a79e07800d41ce ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -460,7 +460,7 @@ static void pidff_set_effect_report(stru
 	pidff->set_effect[PID_EFFECT_BLOCK_INDEX].value[0] =
 		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 	pidff->set_effect_type->value[0] =
-		pidff->create_new_effect_type->value[0];
+		pidff_get_effect_type_id(pidff, effect);
 
 	pidff_set_duration(&pidff->set_effect[PID_DURATION],
 		effect->replay.length);


