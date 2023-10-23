Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018FD14A97
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xk+velNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E89C433C7;
	Mon, 23 Oct 2023 11:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059942;
	bh=GDnv4Ys2pjUPTOh0wIrYRdLtfuMI+5n6dkX2JcSat5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xk+velNpUrsziGlm28Ib4XWb3DObGgSCryF9o5T6rkgox4SOILHWKQzGwL9RohV9F
	 ly0qlquAa405m1DazsPwTUfCqmDbCSBXEvzZrx8UMyAnC3D8nI2PW2+4eGX9+hE7yt
	 YUQpTG3fP+t9i1e9V0gzQrLEW40yW5+wpIi7ofjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c90849c50ed209d77689@syzkaller.appspotmail.com,
	Edward AD <twuufnxlz@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.19 96/98] Bluetooth: hci_sock: fix slab oob read in create_monitor_event
Date: Mon, 23 Oct 2023 12:57:25 +0200
Message-ID: <20231023104816.906461854@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward AD <twuufnxlz@gmail.com>

commit 18f547f3fc074500ab5d419cf482240324e73a7e upstream.

When accessing hdev->name, the actual string length should prevail

Reported-by: syzbot+c90849c50ed209d77689@syzkaller.appspotmail.com
Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Signed-off-by: Edward AD <twuufnxlz@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -430,7 +430,7 @@ static struct sk_buff *create_monitor_ev
 		ni->type = hdev->dev_type;
 		ni->bus = hdev->bus;
 		bacpy(&ni->bdaddr, &hdev->bdaddr);
-		memcpy(ni->name, hdev->name, 8);
+		memcpy(ni->name, hdev->name, strlen(hdev->name));
 
 		opcode = cpu_to_le16(HCI_MON_NEW_INDEX);
 		break;


