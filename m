Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09870145A0B;
	Thu, 13 Jun 2024 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280365; cv=none; b=UjsGw9VYD9WZ3mW0tHevePfT49g3uedWbGqzWoIzQpmabEKuqnDqR44ydvS1eqRd4nlDsKZQutq4NMSqiCXxx3tnBR/XWAEAwZcts0flhomqUlmeALreK0cV48lBbAdEP6qDAgZ13+V/UG7tkS46KrxqECJh+btDLZxuTFkMpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280365; c=relaxed/simple;
	bh=AunfuEYzfhSPGWQSJkC8l+ZRMY2JpynZnPTJJAcqtGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3JZM98Ts2ti7Z7RMonZ1wuaNSEJR4/j3Xu1nwfhC0xZrz8nNMGql4qBQ9aM7bXj9hg46Td8AirZr8V5P/O1HabfVkfMVJXIUjMGt4uLkGFsq5ekzI8L57mGupACKt73xNe/wwaDq+O+Gy/aqVNdubKvIr1ns38EenIo0Jv7r1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9UpCZ3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9UpCZ3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E5AC2BBFC;
	Thu, 13 Jun 2024 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280364;
	bh=AunfuEYzfhSPGWQSJkC8l+ZRMY2JpynZnPTJJAcqtGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9UpCZ3UwS1dGCEjr3P/4FPESwNRsX5jK7JITFe0BD+sfvsJcX2kKlbw8+BituQW0
	 vdor7gtRcGwn2JWasvl4FjjViJn+jKzz37lH8jztSpm1Wg+Vez4hIO/7uRZGBvxFAs
	 Jp+4bK47oOWuWO17jh704WQ9pxgVOeOPZQQV+On4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 028/137] ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx
Date: Thu, 13 Jun 2024 13:33:28 +0200
Message-ID: <20240613113224.380241497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit c81bf14f9db68311c2e75428eea070d97d603975 upstream.

Listed devices need the override for the keyboard to work.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -594,6 +594,18 @@ static const struct dmi_system_id lg_lap
 			DMI_MATCH(DMI_BOARD_NAME, "17U70P"),
 		},
 	},
+	{
+		/* TongFang GXxHRXx/TUXEDO InfinityBook Pro Gen9 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
+	{
+		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+	},
 	{ }
 };
 


