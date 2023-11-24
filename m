Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108BE2FC21;
	Fri, 24 Nov 2023 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKFUWCvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDF0C433C9;
	Fri, 24 Nov 2023 18:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851630;
	bh=tgXET1yJ6iFgtlL5zkPXeWhFcpbEi9iBLlaQ7CzWXRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKFUWCvLjOcZISRiHAwKMSClKtDVK8eJLVaKEx5Rq31SV60YbvRmYSurDk5eVVZJj
	 PwrY3AcGgdg1LaP87INbdjGH9gDg3iVFPrWxl79D8N0HVJ3hkS7lRpUjkBK3AW+I8W
	 3wGZf9pcdC14hFxaRAeAsMcz9ThfE2Z2X0JE5Ph4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	youwan Wang <wangyouwan@126.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/372] Bluetooth: btusb: Add date->evt_skb is NULL check
Date: Fri, 24 Nov 2023 17:46:52 +0000
Message-ID: <20231124172011.324340998@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: youwan Wang <wangyouwan@126.com>

[ Upstream commit 624820f7c8826dd010e8b1963303c145f99816e9 ]

fix crash because of null pointers

[ 6104.969662] BUG: kernel NULL pointer dereference, address: 00000000000000c8
[ 6104.969667] #PF: supervisor read access in kernel mode
[ 6104.969668] #PF: error_code(0x0000) - not-present page
[ 6104.969670] PGD 0 P4D 0
[ 6104.969673] Oops: 0000 [#1] SMP NOPTI
[ 6104.969684] RIP: 0010:btusb_mtk_hci_wmt_sync+0x144/0x220 [btusb]
[ 6104.969688] RSP: 0018:ffffb8d681533d48 EFLAGS: 00010246
[ 6104.969689] RAX: 0000000000000000 RBX: ffff8ad560bb2000 RCX: 0000000000000006
[ 6104.969691] RDX: 0000000000000000 RSI: ffffb8d681533d08 RDI: 0000000000000000
[ 6104.969692] RBP: ffffb8d681533d70 R08: 0000000000000001 R09: 0000000000000001
[ 6104.969694] R10: 0000000000000001 R11: 00000000fa83b2da R12: ffff8ad461d1d7c0
[ 6104.969695] R13: 0000000000000000 R14: ffff8ad459618c18 R15: ffffb8d681533d90
[ 6104.969697] FS:  00007f5a1cab9d40(0000) GS:ffff8ad578200000(0000) knlGS:00000
[ 6104.969699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6104.969700] CR2: 00000000000000c8 CR3: 000000018620c001 CR4: 0000000000760ef0
[ 6104.969701] PKRU: 55555554
[ 6104.969702] Call Trace:
[ 6104.969708]  btusb_mtk_shutdown+0x44/0x80 [btusb]
[ 6104.969732]  hci_dev_do_close+0x470/0x5c0 [bluetooth]
[ 6104.969748]  hci_rfkill_set_block+0x56/0xa0 [bluetooth]
[ 6104.969753]  rfkill_set_block+0x92/0x160
[ 6104.969755]  rfkill_fop_write+0x136/0x1e0
[ 6104.969759]  __vfs_write+0x18/0x40
[ 6104.969761]  vfs_write+0xdf/0x1c0
[ 6104.969763]  ksys_write+0xb1/0xe0
[ 6104.969765]  __x64_sys_write+0x1a/0x20
[ 6104.969769]  do_syscall_64+0x51/0x180
[ 6104.969771]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 6104.969773] RIP: 0033:0x7f5a21f18fef
[ 6104.9] RSP: 002b:00007ffeefe39010 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[ 6104.969780] RAX: ffffffffffffffda RBX: 000055c10a7560a0 RCX: 00007f5a21f18fef
[ 6104.969781] RDX: 0000000000000008 RSI: 00007ffeefe39060 RDI: 0000000000000012
[ 6104.969782] RBP: 00007ffeefe39060 R08: 0000000000000000 R09: 0000000000000017
[ 6104.969784] R10: 00007ffeefe38d97 R11: 0000000000000293 R12: 0000000000000002
[ 6104.969785] R13: 00007ffeefe39220 R14: 00007ffeefe391a0 R15: 000055c10a72acf0

Signed-off-by: youwan Wang <wangyouwan@126.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 96d4f48e36011..4a6369d1dd171 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2638,6 +2638,9 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 		goto err_free_wc;
 	}
 
+	if (data->evt_skb == NULL)
+		goto err_free_wc;
+
 	/* Parse and handle the return WMT event */
 	wmt_evt = (struct btmtk_hci_wmt_evt *)data->evt_skb->data;
 	if (wmt_evt->whdr.op != hdr->op) {
-- 
2.42.0



