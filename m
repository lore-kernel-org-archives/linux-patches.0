Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508E2ECE9D;
	Tue, 17 Jun 2025 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176084; cv=none; b=Nh9ROeZxteMng7XanG2shJOsCYkdO/6Axa8ga5obp0ql64ZtWCXSV/Zn7rGYbM9XhkHUWuEoaNQsI7gUmUCf1ChF4dIKfNKQOJUAoQPy1YOWFAL3tskVLE/qUi5VA2JG1iUIw+ik91c5+gfM3bkga+XPGj4fm9SXwesNJnjkk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176084; c=relaxed/simple;
	bh=o21q1aMAgRQuNpYmF+WuVtH3530bQx9FZvGdL1nw5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKyAQyhaUiaTNmg4BanWQCn41OWcWJ0qSGVqoqaEFW5foVMa8tGDiy7GSehdAAWjcIU1SzeqKQ2HZXQCI1MN7KWnKnluUlvAA1DKCrDz6zsYdMWasX1+nXd5CaleDZkA4PS+V1pRCB4xMFbhByQJVE1PFU6w2scurKJ2iItf2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sirrTHIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sirrTHIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EA5C4CEE3;
	Tue, 17 Jun 2025 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176084;
	bh=o21q1aMAgRQuNpYmF+WuVtH3530bQx9FZvGdL1nw5Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sirrTHIVJ0ct6+bE+RBnce8X337J3zCNsXLeUB8hfjU1a9GGJkuV7GsMuxc7DRCkH
	 1SutJgEpLatA8+S6JdsahHL8vNpV3Uq9wj9LEFIwxllqNMzsAYR9dazv73/P9/L1yb
	 qrmgvybqcXAGmgbYIKOr6xRP4enJqoFnPwVTfQtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/512] Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()
Date: Tue, 17 Jun 2025 17:22:40 +0200
Message-ID: <20250617152427.502579518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17ab909a7c07f..67db32a60c6a9 100644
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



