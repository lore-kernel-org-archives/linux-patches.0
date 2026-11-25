Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623947;
	b=b1fWh3/hg/1YRLZYZbSdPc/Hl0h+8pJ46XtwYxCCg1WBG9+qsSpvr8WM3ssqLvicij98
	 M5nBNMQ2CCeHjbZhRYxC6ljIxwffeRK+VInqb3kokchXKZNANILDyGh6Eyt3WdnWRaRRl
	 mZsACIl9Ylk5lFL9v+a7GC2/y+wtV8VwvCcZjqhcApkweYah4KvQV43jzfJuJrIWLX9GX
	 8Rx6ObZ4xxRKV7VpRZdNKu8muYupKjiHJKtUtLbYu/cbxHI49JLZ4U5qrdtMpxCo1EDqN
	 TOqyziw9pNZf/2Re5580CZLEKZb3S+YQiJMURku8mPflDrRwyRSmdGrHNrqUxTICvYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVAN7Z1jNJSL1L7CAh7yXMAJB/k/i+PNDatqDOcRE5E=;
	b=LMS2CxY8gwbEhF8vG1ro8JGPkswTSy3GY5gyAdVfNxWPiq/9K7NY8nc01iTxZn4plNsH
	 H5OYXB+lK/c8OYprbTbF1uzKR9Zw1L979Fq6XFOBiEokDyb82WlOBHnIQF7LOu3JloLn7
	 WMz4Xp25y7/bs9gX2jZ2/c4BjMC7APtGfgiAHfEaW0o/0u0+H9okrqocvsY+wY2o86QBs
	 oV0c7x0wkd2a4PeJ4l0ANsKPBI2EDdypMO63wbJXjkAifkPdyKvyc2Y1UOO69MQEdIro6
	 aUrg8uKgRIXy3CZ7uDgUeLk2uQVpFZ3HaIg5JuOkXfSNW0z9aIKX2UHbgcRwubd3bsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnIw6SYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F5606A31E;
	Wed, 25 Nov 2026 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnIw6SYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D612B1F000C4;
	Wed, 25 Nov 2026 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623946;
	bh=bVAN7Z1jNJSL1L7CAh7yXMAJB/k/i+PNDatqDOcRE5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnIw6SYd8yGHt+845iVXW+yVVJnetC4CSlCavZNagX1Ji6gLelgbAolMcb/SuudJ8
	 Lu5uQ4KOyrOshseI3rjDVU/TxTe5zQ24sIEcxfosJLCe/uOibwPc3keW492MQSXGPF
	 xr5ZNVYFHVFdZvSBf2SmASk5GJ2rsrpkHS5REBy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hakan Abay <hakan.abay84@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/816] ACPI: PM: Add unused power resource quirk for Casper Excalibur G900
Date: Wed, 25 Nov 2026 15:26:00 +0100
Message-ID: <20261125143849.500997404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Hakan Abay <hakan.abay84@gmail.com>

[ Upstream commit 23ec17231cc6a83bb11d8660db5bfc5336f53a0e ]

On the Casper Excalibur G900, the NVIDIA discrete GPU and the second
NVMe device become inaccessible when unused ACPI power resources are
turned off during initialization.

The failure is similar to the THUNDEROBOT ZERO case addressed by
commit cd7ef20ba8c6 ("ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO").

Without the quirk, the NVIDIA GPU and the second NVMe device are left
inaccessible in D3cold and attempts to transition them back to D0 fail.

Add a DMI quirk for the affected Casper Excalibur G900 with NLCC 001
mainboard to leave unused ACPI power resources on.

With the quirk applied, the second NVMe device remains accessible. The
NVIDIA GPU can enter D3cold while idle and subsequently return to D0
for accelerated rendering.

Link: https://bugs.kali.org/view.php?id=9891
Signed-off-by: Hakan Abay <hakan.abay84@gmail.com>
Link: https://patch.msgid.link/20261005174939.53873-1-hakan.abay84@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 754c3936db099..aaa07997fdf31 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1061,6 +1061,18 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 		}
 
 	},
+	{
+		/*
+		 * CASPER EXCALIBUR G900 laptop: Keep unused ACPI power
+		 * resources on to prevent the NVIDIA dGPU and NVMe #2
+		 * from becoming inaccessible.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CASPER BILGISAYAR SISTEMLERI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EXCALIBUR G900"),
+			DMI_MATCH(DMI_BOARD_NAME, "NLCC 001"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



