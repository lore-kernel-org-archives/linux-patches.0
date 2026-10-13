Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625EA4F6463;
	Tue, 13 Oct 2026 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895005; cv=none; b=YB9JXN8/I63FD4MK8PwxvfFpT//a+FnC4OQibQpEj9DlbAQWq1d55EBaB8nZfiHU9d4ESULkedcBp/cud13cB6ATL/sJ1nWlEbqNZ+2+oYa4UdFk7lBOS6PJLHvZfXPecY8L+OHB1Md3XvBCNvMMunOC4nTVm3wL0ylssgzc21g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895005; c=relaxed/simple;
	bh=ZII+TSn9rnqe0I7ayAaOPRqkoi0XNIgPJTPhtNeuEBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/DwHOXveW4ijqLcluijBepb9gnkePq/968+djpzYneMvcSu93tWDySLZ7viQwfImcolLMK6ySG2/JneDa25opqUl3HKv58QIh7hfYgUKe9rY4MNZtB4rNnQ25ec6gi1FMFAIDSFB6eqXdCmHbBbBGxzGsuxoV6O/QPDNcWpips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIDSE0qr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIDSE0qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E68F1F000FF;
	Tue, 13 Oct 2026 12:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895004;
	bh=kZMmECSdkYnYcjb0W+O0jnrGR4xuoZsfObDHu6JL7XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIDSE0qrrEPVyvT8E7f5aADe+PX+wf1Rn0/gzImAyDqI8ETNBLvFq19KX9ZAgHthf
	 ivJxZDKvrx/3llWH3+AST3ZKmyMyw/RiQafUY1JGYoOgvYOUH/vRw7P0PZv6EB28DN
	 Sh/BbW9OOyN9o+ezJW3lQLPUlo3HmNiI0bqJ8FHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 127/497] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Tue, 13 Oct 2026 13:34:54 +0200
Message-ID: <20261013112910.905251040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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


