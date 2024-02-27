Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122ED2F2D;
	Tue, 27 Feb 2024 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041353; cv=none; b=ZlZJEmCFhySOZ7x3FEFJSYKW2Eb9q7fsmPvoAhDItZNnshqEvKGnjLkXxwUZXqOmbi+qBf/o1je0AZlfN81iJgvOMwi1iQ0mP8pzkkSF5OJMHbeEun9BYLHqlSgwTdLPP924jTZUTDCRLoGcJnpHVuJ85qpg/X4GOQLbUf/26V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041353; c=relaxed/simple;
	bh=7wFoA43hpJi0NKdPGRvmfCDChyxo/eqGYFpV88+Cv3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi11TiUWNA2bzbyUFhfrqvtVz9nxqUaZhQ5GkHCfOeUqKA45/tVlmGP7pcAZCm3yCLtaK9/imCFhPJ70H2cz1BD+85tjMG0vbH2hJDxodAIBNhLNfq2JeKs6KKhLls9LRm5Pk8K8eDEu55mIX0HcopVsFGfIc2q0akE/FfKAps4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLWh/beK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLWh/beK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515AC43390;
	Tue, 27 Feb 2024 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041353;
	bh=7wFoA43hpJi0NKdPGRvmfCDChyxo/eqGYFpV88+Cv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLWh/beKnlHYOmLanffeQ+R3kSsDa0Md9cHC7M0ddgPYmxbRywZIgEfehY8fYX4rg
	 bAQzWIOFeT80DetPhWnA2qPLvXPZ7kPoUYtajwfMAZ/pLhZvSma2+yV7LgkJJMFTeF
	 NXZp1XrwPKkI+jddTr4ZxQK6J+lRTu9IgN6i1ZvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 279/334] afs: Increase buffer size in afs_update_volume_status()
Date: Tue, 27 Feb 2024 14:22:17 +0100
Message-ID: <20240227131639.994994006@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 6ea38e2aeb72349cad50e38899b0ba6fbcb2af3d ]

The max length of volume->vid value is 20 characters.
So increase idbuf[] size up to 24 to avoid overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[DH: Actually, it's 20 + NUL, so increase it to 24 and use snprintf()]

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240211150442.3416-1-d.dulov@aladdin.ru/ # v1
Link: https://lore.kernel.org/r/20240212083347.10742-1-d.dulov@aladdin.ru/ # v2
Link: https://lore.kernel.org/r/20240219143906.138346-3-dhowells@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 115c081a8e2ce..c028598a903c9 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -337,7 +337,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 {
 	struct afs_server_list *new, *old, *discard;
 	struct afs_vldb_entry *vldb;
-	char idbuf[16];
+	char idbuf[24];
 	int ret, idsz;
 
 	_enter("");
@@ -345,7 +345,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 	/* We look up an ID by passing it as a decimal string in the
 	 * operation's name parameter.
 	 */
-	idsz = sprintf(idbuf, "%llu", volume->vid);
+	idsz = snprintf(idbuf, sizeof(idbuf), "%llu", volume->vid);
 
 	vldb = afs_vl_lookup_vldb(volume->cell, key, idbuf, idsz);
 	if (IS_ERR(vldb)) {
-- 
2.43.0



