Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1E9263C71;
	Tue,  8 Apr 2025 10:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109715; cv=none; b=cV5eB5dOxuYAH384i42CZS67+59c1JY1iy5DPb5iCzRDVQCCsEWWVxWZmos6go3bwjBsgz/OL7sb3pHqwoYFBRNwjChJIvckQiimx8CeMEpb2MqBm8ljp8VZE9SwUn4Gj8c8udSiOB/A3xE5sqv4KehH9/ab5eM/+DvAwyR4vNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109715; c=relaxed/simple;
	bh=IE3wH3ZxQRy4XoR8hjPlpZ+fO3vWCsycl6y1JlvAWFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z44RLLP0Qa4ShQ1EAo/oQ9cXTw/OkwlWdFkrD9j7NGCtUPq9X5d4t9vyY3j5FTM7IB+c6+nLRF8EXsFkD7LxrzkgL02eBWgpUr/1W7ObbLYtk724muz3dRcHsJWfqalAHN0dEgJx7NILWBoJnB1HPKrmOHRDrddu/f9ZkDrUZ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4IqYUDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4IqYUDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1951C4CEE5;
	Tue,  8 Apr 2025 10:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109715;
	bh=IE3wH3ZxQRy4XoR8hjPlpZ+fO3vWCsycl6y1JlvAWFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4IqYUDO1w5OnQrQgcv0Ferx4e9tuk6kpjnJey4zscii0ybbGY8/i6fmvYyEEiGs0
	 o8WzgYxov1wA9d41R1kQ4hSIe9g4SpU3l8a5L0st50qw9EGORC9O/aVfbo2VJzWpwH
	 3kzjQqBfsu2Tk4eeqUM3greK4YiH/qZft6LEBM9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/227] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Tue,  8 Apr 2025 12:46:44 +0200
Message-ID: <20250408104821.181272187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b00dad7ea8d40..532674936a0de 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -482,6 +482,12 @@ static const struct dmi_system_id asus_laptop[] = {
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



