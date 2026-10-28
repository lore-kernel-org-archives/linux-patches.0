Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208625;
	b=Gb96N1YsHM+FyRks/PY6q9+I+WOTjBF/2LjIiWXmCp/aTllqB3KCxhJPVMvW4RT2hLFL
	 nP4TDFNG+YND1N3D05xIwa9ukUlHe8nPRAvQ+pgTb9M+Nxo1W/Q4IAxC2J959R3ZFfpei
	 j5AZSxrb8G574pPDoauTx9Dt+SmTDpTchrLy8hF6FASscFLsA6du3gcDHzeNxu4sqcdPS
	 luSnVlSKcoMhvCFtkq99bjdLglkqYRtIgrd6zjSnhSWd0iqBR7ekilRHq3FAL0BG68ML2
	 dGInxfCkm7ztU2A8taknLIDvRHfbqil7JnTj6IyFa0bA63azZETQl8PcpBkGv2VLDaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGx5No6eXHVMHwXbxVlxTUR/HGHnS/eHObm1HNDKzlU=;
	b=TNkM9jJXukSvPpoIYimkGihlvn6BfYZ+OuHjCwmx6u08YSZBBG5+PzwxAVlwu5tNfm4x
	 dhOZPB7GKFast8vujZyqFZOIp2AOCt2z1dsuQa5lw6mNvRnfuzA7DhXrNeHvxApT8sV06
	 buOxiklT0YLhfr+FHqYhSfy4eJWHP0fUWUWT+QiW8IdlIRjSg90im1thkppjmQnVvrJ+t
	 4TSs8ttsurvZqzN0OhKAFQ66xVxJebveOG/nfThvzoXXpPxvIzGxE/97KhqD3WK+l4kCV
	 fW0jEfDf6FnIUTqx38w/vkJcTX4qwqKTr0xGVkSnuLtAcOkj749WaPrWWzcdmViRz4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6o1rDlP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0130B606A31F;
	Wed, 28 Oct 2026 17:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6o1rDlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A771F01825;
	Wed, 28 Oct 2026 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208624;
	bh=VGx5No6eXHVMHwXbxVlxTUR/HGHnS/eHObm1HNDKzlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6o1rDlP97a2PsqJnXsJkAuIZkB/CNL5l7uOZz/HMuCjAkvZbZmuDDnvs9SlSBXlk
	 D0yZW8Hovw53mqQMViHg8p+AWJm9LNMTXbzuoGx8pHaokkuqiou7ILfpgCqlxlJGMJ
	 2LN2s8I5rXje/V8el8tZrXC3BLG+1V3d1xVE80/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 183/516] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Wed, 28 Oct 2026 17:55:35 +0100
Message-ID: <20261028170007.840608919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 495cd7f858b45d2ffa9b685bba3a8c23c1ca4dd3 upstream.

On the Fujitsu LIFEBOOK U7410 the internal keyboard and touchpad die
shortly after boot if i8042 multiplexing controller is probed and
switched to muxed mode. These multiplexing setup commands disturb the EC
emulated keyboard and atkbd reports "Spurious ACK" and "Unknown key
pressed" warnings, after which both keyboard and touchpad stop
delivering events. Both touchpad and keyboard work in BIOS and GRUB.

Disabling multiplexer using i8042.nomux=1 makes both devices work on
warm/cold boot.

Add a DMI quirk to force nomux mode for this model.

Reported-by: Heiko Brey <cico0815@gmx.de>
Link: https://lore.kernel.org/all/89f36f3f5e4c2d07b9ff72bc0b355875c336e498.camel@gmx.de/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920113541.1484808-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -661,6 +661,15 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
 	},
 	{
+		/* Fujitsu LIFEBOOK U7410 */
+		/* Mux mode also disturbs the EC keyboard, causing spurious ACKs */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU CLIENT COMPUTING LIMITED"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U7410"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
+	{
 		/* Gigabyte M912 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),


