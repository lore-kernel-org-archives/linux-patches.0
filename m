Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9FA125CA
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmGnpFOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A70C433C7;
	Mon, 23 Oct 2023 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058797;
	bh=GFaeN0l6YzB15kWgREQiEYgYJrNXaj8YAzDmLvaxlRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmGnpFOzn6q4o6d9LU3UFYinOsCFhAxkL+FEyOCDO90x7Q5XAXlzhrwbowklgzeeT
	 FnJJrHpiOLyABvcVn0ZkCiqgEIHvf7kCu2nlp+7U09GHchOgHlECV/nqHUh5/wiMGX
	 YSksEtcHxrUbZ4JH2HO2BniSqLII5t2KozHs4rSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.14 30/66] Bluetooth: hci_event: Fix coding style
Date: Mon, 23 Oct 2023 12:56:20 +0200
Message-ID: <20231023104811.950602494@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 35d91d95a0cd61ebb90e0246dc917fd25e519b8c upstream.

This fixes the following code style problem:

ERROR: that open brace { should be on the previous line
+	if (!bacmp(&hdev->bdaddr, &ev->bdaddr))
+	{

Fixes: 1ffc6f8cc332 ("Bluetooth: Reject connection with the device which has same BD_ADDR")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2250,8 +2250,7 @@ static void hci_conn_request_evt(struct
 	/* Reject incoming connection from device with same BD ADDR against
 	 * CVE-2020-26555
 	 */
-	if (!bacmp(&hdev->bdaddr, &ev->bdaddr))
-	{
+	if (!bacmp(&hdev->bdaddr, &ev->bdaddr)) {
 		bt_dev_dbg(hdev, "Reject connection with same BD_ADDR %pMR\n",
 			   &ev->bdaddr);
 		hci_reject_conn(hdev, &ev->bdaddr);


