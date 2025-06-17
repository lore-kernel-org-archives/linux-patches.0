Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0620CCFB;
	Tue, 17 Jun 2025 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177461; cv=none; b=Nb4VdIYG6Q/2YoDAlPy1NlPCS3ROBbCK/2K7hdAccFA0Q7/FXpjBafDVQrzAiEyD/OFXZ3GNZhlMy86f8mthFYJM2CJNSXOdZ1hw2sPRjXBQd7hOVMPSEFxM0Egv/wChTvJkkEMKoTJv+f2BZl32+jsLMrET1QLrbHOAAwE6LGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177461; c=relaxed/simple;
	bh=ZZ+T6NWxMdXhl29TYgCOVjubdcEjVj1bIbb56ZkvcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9gb+Y7faGcG+1OHwKtOlLcOj7cwaWPmwIjRfWWrKBor48fUHWQj+pH2z+1yXxZieaJxPuyQtdz2WHkElnzag1ZNnli7Y4oOEgpTDNLwT+6QQ/HgjjiRKXz5lohiy3nCbOPaoGx/0ihcFsflPtFIuGZY/g9FisjTPZt70KivFQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+e4O9tE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+e4O9tE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6038BC4CEE3;
	Tue, 17 Jun 2025 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177460;
	bh=ZZ+T6NWxMdXhl29TYgCOVjubdcEjVj1bIbb56ZkvcHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+e4O9tE+qU4GfayndXGuLHLHx7uPxTaNusv1MwJqslsFgQ3fB8ZgtOS2MpSs0nfY
	 xnsc/mXGlPIoJRCGnaQTsp6h0OCXmWeAzHl/19oG32eeoMQuB27Y8PpT0iR8T3saFW
	 0boKEJ/9leN+p9B5XiTLQfOGfE1Lwvttt+X2k1KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 310/780] Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()
Date: Tue, 17 Jun 2025 17:20:18 +0200
Message-ID: <20250617152504.094131662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 3bb88524b7d030160bb3c9b35f928b2778092111 ]

In 'mgmt_mesh_foreach()', iterate over mesh commands
rather than generic mgmt ones. Compile tested only.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt_util.c b/net/bluetooth/mgmt_util.c
index e5ff65e424b5b..3713ff490c65d 100644
--- a/net/bluetooth/mgmt_util.c
+++ b/net/bluetooth/mgmt_util.c
@@ -304,7 +304,7 @@ void mgmt_mesh_foreach(struct hci_dev *hdev,
 {
 	struct mgmt_mesh_tx *mesh_tx, *tmp;
 
-	list_for_each_entry_safe(mesh_tx, tmp, &hdev->mgmt_pending, list) {
+	list_for_each_entry_safe(mesh_tx, tmp, &hdev->mesh_pending, list) {
 		if (!sk || mesh_tx->sk == sk)
 			cb(mesh_tx, data);
 	}
-- 
2.39.5



