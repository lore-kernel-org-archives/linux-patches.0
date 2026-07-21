Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5543D510;
	Tue, 21 Jul 2026 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674695; cv=none; b=sVBRGE4kETX3XBz39ljU2r7YULKTf0hAPPZhEWpLSwWWKewqoKwjnG2Y5/hI2UoquGV+PJT1A9FX4VCfdtWdwofX3ZZ4VQol0vy6jvR612CDKSemjrZyXULat2Y6lxJ4konzuN4Apcec6Cz6FkZbenZ/vGSqY6T+v1qMnujzF98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674695; c=relaxed/simple;
	bh=egoCYlryAwkyREP+gUwB7iuwUfdxsJ5qxmMDujKxrus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN5xfbdVK3Yv7eF3hdJh8vK0YBJZSnv9lg3Yi0kHtnd0yTXEOJmSLdslnfLxksKnmyB1uOMl0hc5hf466RhRIlfXWHPR3WUXpdaIhxFT3+PvqYFH5LolwIlW9cJ+ULNSln8B4wkYN+cveqvl3ofe4hXr2ZopQ0D9RV+UhvoI+gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzS0r5Dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzS0r5Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D81F00A3A;
	Tue, 21 Jul 2026 22:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674692;
	bh=QUTYmwZRq/lXEURWwWAIqilWOIoAzqnYM/A/9YKlmwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzS0r5DjhrYnA7Ze9ro8pvUqhDLYZWbV8YlwaQ+E8SjntoJBAVkN6tU5BZhvDRnZq
	 KyXvWga/eT2tTIYv2IYZ9OIHoypSqiIRlRrhoHA7CaoZeHnoLD9mYVYbEZFuEx41Qa
	 sN4uqu3yK2nr/Upn3H/l48sJmrmLuL+LpU9KOaxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 595/699] Bluetooth: btintel: Fix offset calculation boot address parameter
Date: Tue, 21 Jul 2026 17:25:54 +0200
Message-ID: <20260721152409.153109211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit d00745da644d42c2f97293eb3fe19cfd5c0b073c ]

Boot address parameter was not getting updated properly
due to wrong offset

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: c5b600a3c05b ("Bluetooth: btusb: fix use-after-free on marvell probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -863,7 +863,8 @@ static int btintel_download_firmware_pay
 			/* The boot parameter is the first 32-bit value
 			 * and rest of 3 octets are reserved.
 			 */
-			*boot_param = get_unaligned_le32(fw_ptr + sizeof(*cmd));
+			*boot_param = get_unaligned_le32(fw_ptr + frag_len +
+							 sizeof(*cmd));
 
 			bt_dev_dbg(hdev, "boot_param=0x%x", *boot_param);
 		}


