Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7408F2DFF09;
	Tue, 17 Jun 2025 15:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175052; cv=none; b=BCTk2TTcsZBaIvKER8Ghce5zrP05LuZp2JD2ogp9UzdIrk5CS4KHQwQMszxNoke3N+bgtIm5iWHOlBeSzXo4HfuymMrASM8ihNRAcIKj2DNy2UKSwaSAogiLersGVWu3jZ3phCruiBFQxQG2L5/LFZ8JpA03POuRVbBZVXO/ROw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175052; c=relaxed/simple;
	bh=KqT9poMhthW+mu2viSbCzLmGlegSb5wy5bVhySUJxjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6awtaObZ9P2ubqKsMgPPltnfOksgALLzp/UAxTDwDrA9UglBfmex811oXSqRktFW4yMwdKXGZIGBeykmfPYEZDNmKdkCIUw7RGdGuYTRW3hxrqF3DCAFvbd9blLa2oeWG702RRrqJYffFQtwFdVECj7x5BjDiE3KpqGwzbJvq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4yYBbP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4yYBbP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A16EC4CEE3;
	Tue, 17 Jun 2025 15:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175052;
	bh=KqT9poMhthW+mu2viSbCzLmGlegSb5wy5bVhySUJxjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4yYBbP50SYnRY+mKbQZJwV5SYzpVUQJLrtTID+nzbH30TbWi3ooaG29U1vxkLkBJ
	 l3Z+Lq6IBSu6w9tBsdMUZQo2zlVC0xPVFACl6tF/cP1/7yLhCfmyOGadYLj+d/muoZ
	 oYJhUHtZSrfn51c7xzeS3amfR5o+1qYEpLAgI7/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/356] Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()
Date: Tue, 17 Jun 2025 17:24:14 +0200
Message-ID: <20250617152343.828202610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



