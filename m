Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D855A84C;
	Mon, 18 Dec 2023 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9WkwVH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4786C433C8;
	Mon, 18 Dec 2023 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908196;
	bh=HH7mWhXO/3xi4eO4Y6YhreDDgrpb5j8Y+uixqv4uSDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9WkwVH8mF3NcaRzQ9xe6YzN97wrB7kpXsjsJmhMZRErF6PvHIFItzXeAYuz/khaT
	 Rl8Y99H9BG/mELWQxcTJZFB9je0+l79yexPz0UlAlqyB1VAjGsGEufKUUdQTdS7uSM
	 Q60WqzPiyCWkLOjcr372F0NP98kFBKHXNFmWxIUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Marcus Aram <marcus+oss@oxar.nl>,
	Mark Herbert <mark.herbert42@gmail.com>
Subject: [PATCH 6.6 059/166] HID: i2c-hid: Add IDEA5002 to i2c_hid_acpi_blacklist[]
Date: Mon, 18 Dec 2023 14:50:25 +0100
Message-ID: <20231218135107.691913011@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit a9f68ffe1170ca4bc17ab29067d806a354a026e0 upstream.

Users have reported problems with recent Lenovo laptops that contain
an IDEA5002 I2C HID device. Reports include fans turning on and
running even at idle and spurious wakeups from suspend.

Presumably in the Windows ecosystem there is an application that
uses the HID device. Maybe that puts it into a lower power state so
it doesn't cause spurious events.

This device doesn't serve any functional purpose in Linux as nothing
interacts with it so blacklist it from being probed. This will
prevent the GPIO driver from setting up the GPIO and the spurious
interrupts and wake events will not occur.

Cc: stable@vger.kernel.org # 6.1
Reported-and-tested-by: Marcus Aram <marcus+oss@oxar.nl>
Reported-and-tested-by: Mark Herbert <mark.herbert42@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2812
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-acpi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/i2c-hid/i2c-hid-acpi.c
+++ b/drivers/hid/i2c-hid/i2c-hid-acpi.c
@@ -40,6 +40,11 @@ static const struct acpi_device_id i2c_h
 	 * ICN8505 controller, has a _CID of PNP0C50 but is not HID compatible.
 	 */
 	{ "CHPN0001" },
+	/*
+	 * The IDEA5002 ACPI device causes high interrupt usage and spurious
+	 * wakeups from suspend.
+	 */
+	{ "IDEA5002" },
 	{ }
 };
 


