Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D95F14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWTGz4ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B637C433C8;
	Mon, 23 Oct 2023 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059633;
	bh=XV+UthO47pPExCLzEgiDIZyW2Q00nBTLAerQCQScuAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWTGz4ZEbMCHl565WWGSP5IibwmFFJqASWXUJi/HidjrsoVpbNkvPGWqciXE5WD38
	 H3JkmwKF8STrNsGLp6VhV51b6Lj1bPfIQHTjt+j069pdzeyzKjgKJZJtZj2JYYX+Nw
	 8A0BkQOncf4Z2x9jtlz8a4GRBjZ3IO3DA9bssFY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c90849c50ed209d77689@syzkaller.appspotmail.com,
	Edward AD <twuufnxlz@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.5 235/241] Bluetooth: hci_sock: fix slab oob read in create_monitor_event
Date: Mon, 23 Oct 2023 12:57:01 +0200
Message-ID: <20231023104839.603373835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -439,7 +439,7 @@ static struct sk_buff *create_monitor_ev
 		ni->type = hdev->dev_type;
 		ni->bus = hdev->bus;
 		bacpy(&ni->bdaddr, &hdev->bdaddr);
-		memcpy(ni->name, hdev->name, 8);
+		memcpy(ni->name, hdev->name, strlen(hdev->name));
 
 		opcode = cpu_to_le16(HCI_MON_NEW_INDEX);
 		break;


