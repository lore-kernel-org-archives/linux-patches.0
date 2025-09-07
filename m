Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA304315A;
	Sun,  7 Sep 2025 20:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277430; cv=none; b=N9zO5HBHTLnBl6Wn51++Z6RJ+GCLU6DMkfDbIPPRHOkhNmBQ3lQQYlPCcSMHKZzHb9xqrV0MnDwPDWilyVPY2dH4CC1MxQjAA7YZMPYpCAl77DD1V9Lp73LFHKRv4diKj+xwRk145T3Xg+6cseoV5Bkvh1rLUeRL0IPZJ25yChU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277430; c=relaxed/simple;
	bh=cWoRygG08XbhLyQNPJ3fr+ihmb3Dog1w0tc3BaosNUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esHJYJ9vBoVEsbfkhiT7WGe+OX23s7nrEnmEXjRCAJ3l9KUguAf4xzGQAbDKamCYwYnuw3hMxTlrszHomJIcNAJdgOM6pah48CuzpUTq0ZgKPnWuTpDf6mxPnQ937A3f5evZIb7wcG4OvawFa/tslE/TNu5UBdjk2uzyJn54FM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGNS3GaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGNS3GaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E56C4CEF0;
	Sun,  7 Sep 2025 20:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277430;
	bh=cWoRygG08XbhLyQNPJ3fr+ihmb3Dog1w0tc3BaosNUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGNS3GaWuPeOpUho3vsZEstnrEFTpo6j0rVXfkHlS6dtYoYH/ZKM5VOCj5riCAupO
	 qkKmMrxUO4Be+ynv+5HiCoQLorZX9+itVSAkFzce9LTzXzAh9DN1dB/24+08E+cIYC
	 YQ8kLwWJmI2gbhTuj1Gx/g9NS/ec0V4rFp534I/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 013/183] Bluetooth: hci_sync: Avoid adding default advertising on startup
Date: Sun,  7 Sep 2025 21:57:20 +0200
Message-ID: <20250907195616.105910880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit de5d7d3f27ddd4046736f558a40e252ddda82013 ]

list_empty(&hdev->adv_instances) is always true during startup,
so an advertising instance is added by default.

Call trace:
  dump_backtrace+0x94/0xec
  show_stack+0x18/0x24
  dump_stack_lvl+0x48/0x60
  dump_stack+0x18/0x24
  hci_setup_ext_adv_instance_sync+0x17c/0x328
  hci_powered_update_adv_sync+0xb4/0x12c
  hci_powered_update_sync+0x54/0x70
  hci_power_on_sync+0xe4/0x278
  hci_set_powered_sync+0x28/0x34
  set_powered_sync+0x40/0x58
  hci_cmd_sync_work+0x94/0x100
  process_one_work+0x168/0x444
  worker_thread+0x378/0x3f4
  kthread+0x108/0x10c
  ret_from_fork+0x10/0x20

Link: https://github.com/bluez/bluez/issues/1442
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 749bba1512eb1..a25439f1eeac2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3344,7 +3344,7 @@ static int hci_powered_update_adv_sync(struct hci_dev *hdev)
 	 * advertising data. This also applies to the case
 	 * where BR/EDR was toggled during the AUTO_OFF phase.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
+	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) &&
 	    list_empty(&hdev->adv_instances)) {
 		if (ext_adv_capable(hdev)) {
 			err = hci_setup_ext_adv_instance_sync(hdev, 0x00);
-- 
2.50.1



