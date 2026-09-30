Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BFA36826E;
	Wed, 30 Sep 2026 19:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795854; cv=none; b=vFmdNsrRR/zWQXUv1sPPCnM96KFDIIi9J6vnncIaPrWXnVzO7WJLr1OUk5lCFzskTVpXV8JBSU+RXvPB2XXDqm+8ipwI6/wD4W2xRMl6vwki9jSYgzNpHsN4EmneRwhbUZdza7zKKUCpAXsne8zO3ls+5Ov5kP2u2JTRHDZr8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795854; c=relaxed/simple;
	bh=AteeG4j+tFs5FtlspEMaFNBg9P7d/I3IVd263CFXwsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG0EcplzmWaHgcdIT7UIGGoLvUNS4SwocRCLuxm+BjelITNTeOf76yV/FVVdX0UeaKDoUDKSUzbcu/ycma0e9Q7TJna2FnW206rODTBKLi9dVewLoO1BRJgCRVATE6FzbMcCzZSyjBjdgKTGDwKxFij0YLZZHb4jN5xxFCDCtvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa7FvbZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa7FvbZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDFC1F000FF;
	Wed, 30 Sep 2026 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795853;
	bh=/E8jyk6FiOv6fdSjHPb9jLdhnwWE5kEAcMS0VIqzR44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa7FvbZor96jzxpwi1mDb4do+FoPMlB302Ry00MSbfQa0MXrPCyIJ+9ReEWKG//yc
	 WF9sVSfG6cjreRn8uBQeybWY9fcv/keDvEkT0AwpgGkPzwpjS1D0w0uv7AyHSmKTuh
	 9QOKA9QIzFQqjXnsR8h9J2/ZolC7SrWcW8ajh5yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0705/1193] Bluetooth: btintel: Fix compiler warning for multi_v7_defconfig config
Date: Wed, 30 Sep 2026 17:23:09 +0200
Message-ID: <20260930152449.913847252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

commit 36b1c9c35452d043ce2239a65393b3e7ee7101c5 upstream.

Fix the following compiler warning reported for ARCH=arm
multi_v7_defconfig.

In file included from drivers/bluetooth/hci_ldisc.c:34:
drivers/bluetooth/btintel.h:373:13: warning: 'btintel_hw_error' defined
but not used [-Wunused-function]
  373 | static void btintel_hw_error(struct hci_dev *hdev, u8 code)
      |             ^~~~~~~~~~~~~~~~

cc: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 67d4dbac3b8c ("Bluetooth: btintel: Export few static functions")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -364,7 +364,7 @@ static inline int btintel_shutdown_combi
 	return -ENODEV;
 }
 
-static void btintel_hw_error(struct hci_dev *hdev, u8 code)
+static inline void btintel_hw_error(struct hci_dev *hdev, u8 code)
 {
 }
 #endif


