Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F323F3431F8;
	Fri,  9 Oct 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556000; cv=none; b=MHdfez5jILTgQDaw8/s2IWree1vMNJ4DHidM7Ymqye7qN1BLJz/t77EbV5u7BwxHGX3I0hKTkrpZLmfmk2Vnlwn1r30Bxcrg+o+ImYD+fdxHg0HWRhKvG+moJRuy7mqjUUU21nyVoUe95rde9/U2k/uZyjitJIira6mF4TwD4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556000; c=relaxed/simple;
	bh=MdIMs8Ii00A0uJhshtf5HwwpxzAgVzZ6CK6ADb4VN6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQmwvAsygzYCkBrkObHvsUA99e5lLxhEm/xifpV6bOQAmMkH3yP1pm9HHp0RchpOF+GtJdRlUSWx92mXhqFcZsl9+9DjFvy6aRWUMeBfA2twcU7DntPEZdQIkidHlm9UsnS8mHSFHM/jQu4k/o6T88EoLS7dSSHqPhR6V6ZcAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfof44/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfof44/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDBA1F000FF;
	Fri,  9 Oct 2026 14:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555999;
	bh=/incMWReZ3kRUQUtcXEHR8/qQZQFCAEK3m6DpfkThhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfof44/nL9w366jUDYq7NF+RMkZc+e3Te1hCK4q3zhUK1k9Obt8PJ3joM9tTBQQR+
	 JndSL8baUF2PMDvfmX/zdnI2Ok3zB28XyiR7WS5IKgzZVt4oqTEG2SLdfIHeHsiboF
	 9uSJiB/ZQHWN4XtK+hbnMlh/DRRMP2n46rWq8WIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 152/403] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Fri,  9 Oct 2026 16:08:33 +0200
Message-ID: <20261009140955.626569006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


