Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA112206B7;
	Wed, 19 Mar 2025 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395187; cv=none; b=oW+o7Eta+WutJjSHluqAXjoZYwi3XbWxfQ1U/opyahJIlN0aTLYjHOlYcrf17gLPuBu56/OgDNj0wmGPWu8bof1deAv/8DZ1ACwzBRLasGt76cgwDJazeMxOdtQ2f7Q0sTnc31Ww2QBn9yeDmoU8X27x6FGbUUOP5yjnTqL4gJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395187; c=relaxed/simple;
	bh=bQm1Qj713h0QJl1wxJLV/83IUbBct1PB9MmfGw7fDvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItNcQX/QxC9GbZb5b8dxt/wJIY6aI4/bI5VsOHTzEKH0oR+to5VatG2dWNrx6pgN2Y8Bj2IOgraL4SzGsjQxBuNceCP8Vp43tNfzfIfXiwrzR91P1lVK8UcpDzZJ/yTuxRuZ5mRWwqVdJ3CUjAiW5r55wy0UHdHNxbAlxUQU1/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHQdyHaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHQdyHaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A4DC4CEE4;
	Wed, 19 Mar 2025 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395187;
	bh=bQm1Qj713h0QJl1wxJLV/83IUbBct1PB9MmfGw7fDvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHQdyHaLqpQGJtS62X/BQBrc3d5xlldJdn02VsTQwa++H3p7ipKsrBy/nxHA9fkL2
	 8LCaENHtJMI/Hp5qFdBB9Afw+XdxOjZQAoK2cKU2eC8PVVQ+aiLgwJVdYuGowOdfHT
	 FepdbUeNpYKYHHZwWUAeiFYeuD93PIjr2R/WNMNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/166] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Wed, 19 Mar 2025 07:30:17 -0700
Message-ID: <20250319143021.238820559@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gannon Kolding <gannon.kolding@gmail.com>

[ Upstream commit 607ab6f85f4194b644ea95ac5fe660ef575db3b4 ]

The Eluktronics MECH-17 (GM7RG7N) needs IRQ overriding for the
keyboard to work.

Adding a DMI_MATCH entry for this laptop model makes the internal
keyboard function normally.

Signed-off-by: Gannon Kolding <gannon.kolding@gmail.com>
Link: https://patch.msgid.link/20250127093902.328361-1-gannon.kolding@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 64d83ff3c0d90..96a987506e717 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -549,6 +549,12 @@ static const struct dmi_system_id maingear_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "MECH-17"),
+		},
+	},
 	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
-- 
2.39.5



