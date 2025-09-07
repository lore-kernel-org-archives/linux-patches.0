Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29122F74D;
	Sun,  7 Sep 2025 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276475; cv=none; b=QstT1qM/mjkIx28MT6fPiPYPNnKMFjMnCW6iVjY/fRpIt2euNoR6lObSed3HCzdGIl1AOv8O7sdPcMgl1gDknmjeVrn6j850o5uWHxOXQ4QuYWW901gn4R2zXXP2bko21M6A9jXyufJwc3jZXbdKBnaE7ugnhzkuJ0k6/H6R0WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276475; c=relaxed/simple;
	bh=hNQF7A4XXpT8EhtrZw0bpUgbO5kZdcAIZrq1E+DFux0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9hU+J8BEwqYKW9xfMF/Ap5uwY2PDhCdH0mGH4IYOmeous81WGcg53bYCNpfEaU0CWDWPLlen8FYsAZeEtjQpgyy8P2L0N5INfdGnfa6g5VeQFHnpF8BMNmyjP0DeXCheTUyqkAjnuWChCDon8o/6qAQB8o6yRaKVq+iKcbtuvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVliceEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVliceEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D4AC4CEF8;
	Sun,  7 Sep 2025 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276475;
	bh=hNQF7A4XXpT8EhtrZw0bpUgbO5kZdcAIZrq1E+DFux0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVliceEYXYd4cdkSsVBZK2Rltw6UjAQyY0W8ZLC2zBVWBZn8YS3S/QOA7muGLXWmJ
	 FQX9Zjkbzhl+NF1nIfincWaN+NAxh+xEyZmdJm24gHmFIud20OAjMqDd8nLpcXoGu7
	 puec2CO34ux2BDy0G9dSvj+Kdm355hKjLvuI/soA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/121] Bluetooth: hci_sync: Avoid adding default advertising on startup
Date: Sun,  7 Sep 2025 21:57:28 +0200
Message-ID: <20250907195610.128247243@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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
index 020f1809fc994..7f3f700faebc2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3354,7 +3354,7 @@ static int hci_powered_update_adv_sync(struct hci_dev *hdev)
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



