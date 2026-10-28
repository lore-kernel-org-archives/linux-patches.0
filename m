Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212741;
	b=GTpaZoaEeukK82XTpHCLSE7MHKuPlAUk15qKDHN6lnunVsXdA02AnncOYg2ZL7NeubtR
	 jHkOQ1j87MQWLLiE9DZkA4bGQEZEfXvJNWflXW5BSGTjHxVf5UQUoMEwCru9XFZ0xuRIc
	 XWp/gmT2lFX+VqWLJThF91FPi8HhexqGo/TXlYEBNeCdKU7obDSvnEI9JCeF5kaGwrF/F
	 NUCSF5US7btA2I5QKsxsqpuchkIn5r5sS9CvXn1MR9szZeKzjm9Vg+lQ7q+qCBmErv0h1
	 waR1o4zTufJ0t2pYrZeJo4GexLpUCmY0mVh+RruKG19UdCTeAssUZvb0Vq3rFXv/0PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=05tbjtI9PiRZAxIXoa0961POwVbv+LbJVPa+mGNiNHM=;
	b=dda8RvJ2+/yLQvmtfntxJ/9JXpdM8DhMBns+e22FrN65l3iPE+7XDh66HS3Ezp/CdPOB
	 fpKN6kGhLf9I6kLMNQTBawYyT6UFlbqRqMSAE4KepF0x2IinpiwS+/RDviCrhswMTIGs+
	 UMToi1vuEf88En2LZONV364Ze1AXlmvMmWYjAdY5XaRQ0IdQAYl94rC2tAvztwBkV5DJg
	 f7cL4Dy1LuePsxc1yCWPXxln8MOJXPMee+fQQPbB1OnXis1oT0AfvSPwmGa+sbEJ3vBJM
	 8IC/ZHGcn94T8b3/8wiejr9QksUl+RES186151WeWj+N/iTeg5G+QE2cPLn49usINtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNtiqKno;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC92606A31A;
	Wed, 28 Oct 2026 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNtiqKno
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020A81F01828;
	Wed, 28 Oct 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212740;
	bh=05tbjtI9PiRZAxIXoa0961POwVbv+LbJVPa+mGNiNHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNtiqKno9ie1H6cy6olXWHHrA0uGtG97XgwsaYrf3HYbPJYxOPo/717W+gobEXXcP
	 zVSQ0ph1+0EuAf0L8Ntxm6UXYaVlo4bBVKyr3XqNIQsfC4e0N1kxztaKeT2gRJdx31
	 N+oCWpKrOsakOKTTaxYe/6aw4iyOFHV6HpkyC8yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0261/1887] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Wed, 28 Oct 2026 17:39:17 +0100
Message-ID: <20261028170505.168785374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -671,6 +671,15 @@ static const struct dmi_system_id i8042_
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


