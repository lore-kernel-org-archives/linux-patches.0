Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6658F2253F9;
	Mon, 23 Jun 2025 21:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713380; cv=none; b=bu4hGcugrqhWVJaXQOs1krs4IBf0uGkRA3avRepYAHVLlVitf9Jf3gJSxTNhRIynIBC8E1MOpwK+rczX3MeJ7xu9QPjp2D48awEpIxfpqbuw1iNDtHE/vdKMD4jn+vuyFdQVt1vZypdPdsaDDfag3jw1dD85V26LFywirDUGJKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713380; c=relaxed/simple;
	bh=0zRISVZC7UW13erzri1ijaqVfF34qzjw7+YI+si78/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpcoicC4QokC7zdPQbaiw5LVaKxBZs/0fWfM9Y4LOcFoIYzInJvoCk3jWEORJIAQnr7EvLKa0T75n1eVLAcbuziitx6RWVFSxkm/gvZCB3ppb1t4e0jPAImAv6x7T4whDP9AI6Xj/R6llsafB1lmC+7ItqkNWu31tbz72mR8E9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxDHcG6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxDHcG6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1852C4CEED;
	Mon, 23 Jun 2025 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713380;
	bh=0zRISVZC7UW13erzri1ijaqVfF34qzjw7+YI+si78/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxDHcG6rpq8qpeXPeljkMfYlUL0NI6oWpMh57WjanANCoc9LGUPPyNVO1zYZ43YOT
	 MYc+6fQPIhxfA0I/Er8/fk4norbF4lP6ym/SH7n5ouLIXpbJg/CbMNRz70bNWiUO2A
	 KcZ4MPxQ0Au4Sr8YgFtuuZTZlb0n0sNyysOGGCJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/508] Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()
Date: Mon, 23 Jun 2025 15:02:18 +0200
Message-ID: <20250623130647.545094329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0115f783bde80..17e32605d9b00 100644
--- a/net/bluetooth/mgmt_util.c
+++ b/net/bluetooth/mgmt_util.c
@@ -321,7 +321,7 @@ void mgmt_mesh_foreach(struct hci_dev *hdev,
 {
 	struct mgmt_mesh_tx *mesh_tx, *tmp;
 
-	list_for_each_entry_safe(mesh_tx, tmp, &hdev->mgmt_pending, list) {
+	list_for_each_entry_safe(mesh_tx, tmp, &hdev->mesh_pending, list) {
 		if (!sk || mesh_tx->sk == sk)
 			cb(mesh_tx, data);
 	}
-- 
2.39.5



