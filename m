Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CC6434E2C;
	Tue, 21 Jul 2026 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664610; cv=none; b=us4df6tLEbtLAAAKKpMIAIYArji4PMljKLkf79cRwzVwnlRj8TJpADxfTeyK4AcxLHe6B2It4LrWpowGPe1R4t1GhjLGf7lTjJmh9qclJ7uHZvp2JI3bSit2J5s2OL9POxhj7mmuN3lb2zeavs/DIiyIoSkSG/16D67jKbes1ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664610; c=relaxed/simple;
	bh=ZJl3Z6zAmdNfyc77vEuvID474O4R7NmoDzuJUqt/tgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAnFZtnU00AXGc158nbzFFF+JdVbTT8YN388sVEUOzk2jJ0qV5yy41fzVcoRXekKtbbw/VpXwQ2esbFJTaX5O3WiwAmoyjzuOUN+0JS1zkFUAp369Yn10KEgfT9njRl3Sr0+k1A/SvcqQm5ovoIsrR5xqHbxga44mHbgnHxbKwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEXNTlS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEXNTlS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AA61F000E9;
	Tue, 21 Jul 2026 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664609;
	bh=V3/dvsomi8pPRD5+tIHMOob6yQDD2VoDv5jeRnoLR/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEXNTlS+QDjvC48N3ppDQ282aCtU1T8ilHDL7+jsgtc0XmwoKaurh3OLZMQNW/7BJ
	 z6qYhKoTiZRpQeIVox7vpc+SCnGoSh5D7nkEjAyiT7XN9PzyqfNV3uGQgQtplhWHzV
	 7W39gB2T4TUwliEazQcncgo3fiAvLbEKprAQQ5rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 1265/1276] Bluetooth: hci_sync: Fix attempting to send HCI_Disconnect to BIS handle
Date: Tue, 21 Jul 2026 17:28:28 +0200
Message-ID: <20260721152514.397924609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 314d30b1508682e27c8a324096262c66f23455d9 upstream.

BIS/PA connections do have their own cleanup proceedure which are
performed by hci_conn_cleanup/bis_cleanup.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5543,7 +5543,7 @@ static int hci_disconnect_sync(struct hc
 {
 	struct hci_cp_disconnect cp;
 
-	if (test_bit(HCI_CONN_BIG_CREATED, &conn->flags)) {
+	if (conn->type == BIS_LINK) {
 		/* This is a BIS connection, hci_conn_del will
 		 * do the necessary cleanup.
 		 */


