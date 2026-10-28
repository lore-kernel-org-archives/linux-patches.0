Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212581;
	b=UlWyQEPs4S5k8tcd1Seacd1XsghGmBrJqKooGCgLCT20GoYrersGLaD65zm8QTVJ0Y/t
	 qNZEQ7iaFwWTDXNR8XorHJKUnPckKYXsZ6ZDC5bn5otHJXkqOZCgIJRWkomq/CKW1hvtD
	 Yckewr+9pw/LpxVESWfFpgbLAOGXc76khHPuZp4VY5KW28qvM7D9ktu72kV2w9YLNPltl
	 e6Q5V7WI3Ty9OBZ9EENHqvfQPyOCSA9SEX76wEC8wW6u1QznrmVcBVOPh9msQ98BMwl9/
	 ibfb5TU8pSaw8+10MZLA0wwKLjMpVr2eqa+ySdabizIQyMQK5yF4UHhT2zXh9io5vRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vxnnFwxo0qEJugtKH/mdi0b5yinquzA3DuEX/vfuHQI=;
	b=VW4FkArlG0TS4nr4f7BhY23QNgzW6rGWJ3uCrhBysozjX9n/W5NHmgU6qcT3F2rhfO0h
	 +4G2hZsx0Tr1zktPWzePa7Rc0/G+y5IuaIW3w/LA3K4fp1nHs2L/2LQe0bqZg8017kwPH
	 60Bd6dyAaWHeG8Eb6rL0udrfuh1PrsPH8XW/OE3Q9lwBmyFUX9uObFSn37+u4PERfyi67
	 YDcnBYnZFnwJrkjKaYCFaK5wjAk4FWsfEv1svFhjLjFbC0HO0sHzeBn77wEjt4+vRDs3w
	 Dzn7hhqnX4FpGnFaUfLDFAiSuGZ+zJ8FEzI9Zd/wEWcoP9MFqxCyfhAZajDMdiogqfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6HRdD0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369F606A31D;
	Wed, 28 Oct 2026 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6HRdD0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5685F1F01825;
	Wed, 28 Oct 2026 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212580;
	bh=vxnnFwxo0qEJugtKH/mdi0b5yinquzA3DuEX/vfuHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6HRdD0mfQmw6xUfS/Umk0JlQAnB7uhKz1Y9eTkCA5stxghYRtp2FdiPcuiaYjrNO
	 Z9Y0lvA974umPN2IpPDJqG6YM6E4aw7Jy2b1ziW1nZx8nnFHZZ8VQMnrOXSxirtxgJ
	 oUs5fnO3Hw89w38MlzWZBBTF2Js0R3l1tzpIVr88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0160/1887] Bluetooth: mgmt: fix race in read_unconf_index_list()
Date: Wed, 28 Oct 2026 17:37:36 +0100
Message-ID: <20261028170502.876755639@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit b5dbb41b212c50c095a4dbee3017a84fe94f033b ]

read_unconf_index_list() counts unconfigured controllers before allocating
its response, then checks the device flags again while filling it.

hci_dev_list_lock stabilizes list membership, but it does not serialize the
per-device flags. During asynchronous controller setup, the worker can set
HCI_UNCONFIGURED and clear HCI_SETUP between the two passes. A controller
omitted from the allocation count can then become eligible for the fill
pass, causing an out-of-bounds write to rp->index[].

Allocate space for every device on hci_dev_list. Since list membership
cannot change while hci_dev_list_lock is held, the response remains large
enough regardless of flag transitions. The reported count and response
length still include only eligible unconfigured controllers.

Fixes: 73d1df2a7a10 ("Bluetooth: Add support for Read Unconfigured Index List command")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Replaced unavailable list_count_nodes() with a list_for_each_entry() counting loop. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 251e0c0a062a7..7758210c927bc 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -500,12 +500,10 @@ static int read_unconf_index_list(struct sock *sk, struct hci_dev *hdev,
 	read_lock(&hci_dev_list_lock);
 
 	count = 0;
-	list_for_each_entry(d, &hci_dev_list, list) {
-		if (hci_dev_test_flag(d, HCI_UNCONFIGURED))
-			count++;
-	}
+	list_for_each_entry(d, &hci_dev_list, list)
+		count++;
 
-	rp_len = sizeof(*rp) + (2 * count);
+	rp_len = sizeof(*rp) + (sizeof(__le16) * count);
 	rp = kmalloc(rp_len, GFP_ATOMIC);
 	if (!rp) {
 		read_unlock(&hci_dev_list_lock);
-- 
2.53.0



