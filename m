Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210916;
	b=ik9kk0EDt6h4nDfVTgKlW5VdzbTnA43fPjaYFjefYl3dnK9GXR9NGG702p+cZRGt6UqP
	 Rj45o4uvuMFYwHIjpqIwLkzEdzGakTpfqnCF8+6ilcWeppIgbYLCX+rhsQ8gdMTj6FYno
	 LaMhgGzta/d2M/L3BFyQhs6P/ox4eJ3b59gHtFlkG5UMQUFjLXd6Q+MCarWqyDWuiiGtg
	 uZI8wK6trBY+wAyk4bNMTBtezJSvPzvrLW4U/3TtR1mdsTqRGExgRBtbv7GLoEjlvftyg
	 VIeEnwglc2DRld1intysXgtpR9F2/jg17KnJ45UFMrsRbtk1r03IWx3KvZ8mg+q4DPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ZNfgCyfm+gvvDrcqY0O5sGsXyai/Gjh7FvECJmkL6I=;
	b=0/t6dQpb6RcYjGbX5IoUiplzvSYr5nuBH93GX9LkR3SnP5PO4VsgerP5EVj1k9r3Yrwe
	 hcD4OKcuGkmaqv3YjP8S6oAcrzOFumL4FuV5Nz2qL8vXZITud8PLLI/YTT4VL2/NPGdZn
	 CEtivYqXzU3pspArwb6NJUVpDyOTdszDRxFtEsBjZSrn0IuY9yOEZ+TYWPUfRbJxkr3bg
	 lDuL5vz8vqpjrthG4EHlq+sTwjZiJ3zwjEXTAGjq1Q7+TcE4QuuQF2EJUe2aEM3JtLyOq
	 g7FN+/bjK/sGdLwGpw4sV2vM3y5eM69JuhdLnZLcXsCHco5jKoJAkABuFN1G0JiAHnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdfZ6WC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F030606A31C;
	Wed, 28 Oct 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdfZ6WC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3901F01825;
	Wed, 28 Oct 2026 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210916;
	bh=/ZNfgCyfm+gvvDrcqY0O5sGsXyai/Gjh7FvECJmkL6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdfZ6WC6A0YmSXEJ72srqqZYGB98EX7O15Md2ZphqTghQEE6d1wD9o3N8V2wx2GqR
	 qSmn3ADhahSS8SoVmhFizDXgAxXtcVVvrnscXxpMA/TO7aTaDNdmRoxbI4MoFOpG0+
	 iYI5tIMoRjEnkiWZRsR4yrXDONBHlTqwrsNS+uew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 194/571] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Wed, 28 Oct 2026 17:55:41 +0100
Message-ID: <20261028170012.611568472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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


