Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876FA22D799;
	Mon, 10 Mar 2025 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628386; cv=none; b=IIuD/SRGmCVWhswRfwUlIMs7sUHpN127V2Iyz0hdAF0qa173ElrBefltJVyw8IKnXfKYt3WYacln7v5bNqm2YuUUXO6oZi248f7+VRaaFJ07L/ti2bDVnC/ToHR12yGYjMFaeXLl6boZFJQuegJ3ZDUq9tLglotlsm6t3PvRqDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628386; c=relaxed/simple;
	bh=gBD5otTiTK1AYBKD4rEp7p8voqiLY7SjIriEVE+rid8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ic61vyWiFsGZs8nY6l/z5h8Rkj9O8hqd2dDuW8Guixkpd/14kKtQcvkpbcP6KCwTSaAAPS3/801imnU7efODU/tEf4Ctw4M1XbdQNpbUexa+i+933uU1vTTfMPvJJCXycUwXa8+Uw1ejVjQWq5ScKH3w0+8vuLzqUsTxUGSFyM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM4Ipa9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM4Ipa9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B96C4CEE5;
	Mon, 10 Mar 2025 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628386;
	bh=gBD5otTiTK1AYBKD4rEp7p8voqiLY7SjIriEVE+rid8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM4Ipa9MGeO5NT06xMHBAeEQzy2pY1aJJ8lgaYDsq6ibxxWlb25X4DsxG1glutHUZ
	 PdAulYzgZJ9zUAJtNUzHNb5c458ySGtkSeTBUb7AcfutNEQ/e2kSYSryacXf66oQqe
	 HLqZ00Z1YAueEooq7O5kFx/nwmlMsVTT44+ASw/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/109] bluetooth: btusb: Initialize .owner field of force_poll_sync_fops
Date: Mon, 10 Mar 2025 18:06:24 +0100
Message-ID: <20250310170429.152844471@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit cbf85b9cb80bec6345ffe0368dfff98386f4714f ]

Initialize .owner field of force_poll_sync_fops to THIS_MODULE in order to
prevent btusb from being unloaded while its operations are in use.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4c9747de0d6de..25adb3ac40eb8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3769,6 +3769,7 @@ static ssize_t force_poll_sync_write(struct file *file,
 }
 
 static const struct file_operations force_poll_sync_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_poll_sync_read,
 	.write		= force_poll_sync_write,
-- 
2.39.5



