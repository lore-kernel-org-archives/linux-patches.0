Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212667;
	b=Jjn3q6Tq3WCktXVDIOzGuQKqshvj1tk+ln2RR+n/3c1jINywL5mv+ytcoA1QyKTEWRSQ
	 1Ch1lcmw+ewdg0R8D4MCOs4/0IAW8QAcz1QgE3Gp6ex865qcc03oZfDmWcU/DzQfmRFIW
	 oef5rPCrCIH8yzcHmSRXp6CdVFWHQ5cFweO3eTnJQeM09rPOjJq6EddPA6ifhqrLUpU05
	 j5odixmtVLn90RnycCRlYP4TYD67VQ0pCniteswMR53kfG1ejvFhAIQ3I0Cop5HqCb7Qg
	 3BuG6HqC29w6A9G3ohp5VXuxP9XVgnQ/HFaYSGEbiCYFqbt1/OWtSEtVcK6leXQfoHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QikC9QCsldawvabFOEGWBN8UgxtXcgsdIu6E1z7a7Ls=;
	b=JFtgTxl95RAEucyAWL4U90UV/cUlW+fOVeHpfg/QM6KEep+2/8iZXKRsFyix1miB1AJ2
	 IfmT/rIp8GlGGfsMFUQOQ0nKvwQowiL9qfHOy6lprqHWZVlzhBq9I6aMFF7AeBV+5J27B
	 X4dTl7vdEXJmn8T5KCHL48fM1KYY1GKHSl8QwXgVi6mSvKG6PTfBtr6KBRswvBVMmjPSK
	 6DudPTriRi6xm9/Sinu6uuyVJ5LHVcAs1ldvt0mGaB1DBhX9ClvnRmfaye98nA5SVMiXU
	 xDwoOii+ymOo+cOr/JgVENVmj5IPbvt1QJq1ceuprwHfQr5oeBq7/aE9PDcJfRw3v3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMF5mq76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA198606A324;
	Wed, 28 Oct 2026 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMF5mq76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09311F01828;
	Wed, 28 Oct 2026 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212666;
	bh=QikC9QCsldawvabFOEGWBN8UgxtXcgsdIu6E1z7a7Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMF5mq76N+mT8o21wlPIcUbSwPe2hEh4e58DQ9bTiZhYC9oU5D0d2ZGKADyKBSpaI
	 zKGOvf2KNLs1YKhGPnETEIJmlknnZaNnfClrd7Nmb5V0QYosAmQqOnGDboLujNUdJ+
	 si5uWCdjIVZwaUPvWAXyccQCmusdEzziLht+S/Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217e3f1283cafe80586e@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0233/1887] Bluetooth: hci_sync: dont drain cmd_sync backlog on unregister
Date: Wed, 28 Oct 2026 17:38:49 +0100
Message-ID: <20261028170504.534152081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit b1f24c1ab52345e810c42a1a81286cb5a7c92252 ]

hci_unregister_dev() disables cmd_work and cmd_timer, then calls
hci_cmd_sync_clear(), whose cancel_work_sync() waits for
hci_cmd_sync_work() to return. That worker dequeues and runs every
entry on cmd_sync_work_list. With cmd_work disabled nothing reaches
the controller, so each queued HCI command waits the full
HCI_CMD_TIMEOUT (2s).

The backlog has no bound. Userspace can keep queuing MGMT commands
such as MGMT_OP_GET_CLOCK_INFO against a controller that doesn't
answer. Closing /dev/vhci then blocks in vhci_release() for
backlog * 2s:

  INFO: task syz-executor:5749 blocked for more than 143 seconds.
   cancel_work_sync
   hci_cmd_sync_clear
   hci_unregister_dev
   vhci_release

In a local reproduction the backlog held more than 5000 entries,
which comes to hours of hang.

Stop the worker from taking new entries once HCI_UNREGISTER is set,
and wake any request still waiting with -ENODEV before cancelling
the work. The entries left over are destroyed with -ECANCELED by the
existing sweep in hci_cmd_sync_clear(). They stay on the list until
the work has stopped, so hci_cmd_sync_dequeue() and friends still see
them. A callback already running may still issue another command,
which delays unregister by at most one timeout per remaining command,
not by the whole backlog.

Fixes: 008ee9eb8a11 ("Bluetooth: hci_sync: Fix not processing all entries on cmd_sync_work")
Reported-by: syzbot+217e3f1283cafe80586e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=217e3f1283cafe80586e
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5825ab89eb22a..4e4eae12ee3fb 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -308,6 +308,10 @@ static void hci_cmd_sync_work(struct work_struct *work)
 	while (1) {
 		struct hci_cmd_sync_work_entry *entry;
 
+		/* Leave the backlog to hci_cmd_sync_clear() */
+		if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+			break;
+
 		mutex_lock(&hdev->cmd_sync_work_lock);
 		entry = list_first_entry_or_null(&hdev->cmd_sync_work_list,
 						 struct hci_cmd_sync_work_entry,
@@ -677,6 +681,8 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 {
 	struct hci_cmd_sync_work_entry *entry, *tmp;
 
+	/* cmd_work is disabled, the pending request can only time out */
+	hci_cmd_sync_cancel_sync(hdev, ENODEV);
 	cancel_work_sync(&hdev->cmd_sync_work);
 	cancel_work_sync(&hdev->reenable_adv_work);
 
-- 
2.53.0



