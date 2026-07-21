Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4A3B2FE4;
	Tue, 21 Jul 2026 20:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666949; cv=none; b=TqiV/l3jk+JhQxMvJpy18xJ1Rs+GQh0TAJBFi37zsvUuTY8p3ydgg5HT7veGwHXz7Tr/FVm6yRwMj8th3VmWRZHuGR1vMzkC4JFcpWc9R/7ZH4TmoKqgoO8sKTyYWu2gG/l+7GzhCoZ8i4ydp6EnL3wKEBaGArygWLTbq9ok5s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666949; c=relaxed/simple;
	bh=j5P5GRhh1VQOJbkzF227gEqwUKeRQKa5D3s8GWGc9DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfb0eJABoJDp1R1rj5N6Y2aNX8T/+FKv6TeB6My0Z+Rct0HM6cd8hawHUAnf6WjcQxfTvcKTcIynBghiAQwZZrvUldN0B4r9NdGsy7PfX/7ywAh8b4+cXgxI2Zua6Jh4LwhbssuLGB/fNtn3V8uerzfIE/XPKPaBeAAB0pkkX7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEwvSzns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEwvSzns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4571F00A3A;
	Tue, 21 Jul 2026 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666948;
	bh=/s/NfC7TRZC0Jd1Z0cD3hKz5q1tEI5/CbXNiDjOxPFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEwvSzns9NjcWmtpOJ+UZhzghBgloDESLFZxnE148CI+cA6WwQQe47sWZWvHnaARn
	 7IJSWHXkFJBGuVa/MFEq0krqAMaY7lZvv+lMxoaRPl4MvNBNGmIimv4DZ/8a0Kjeh8
	 Ze3X60PukEWnmKQOfwDXspXkvNxhcTLmtZUY4n70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0833/1266] afs: Fix the volume AFS_VOLUME_RM_TREE is set on
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152500.494611334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 56b4e4b26f84411d880f968a539207b0a8889c8c ]

Fix afs_insert_volume_into_cell() to set AFS_VOLUME_RM_TREE on the volume
replaced, not the new volume, as it's now removed from the cell's volume
tree.  This will cause the old volume to be removed from the tree twice and
the new volume never to be removed.

Fixes: 9a6b294ab496 ("afs: Fix use-after-free due to get/remove race in volume tree")
Closes: https://sashiko.dev/#/patchset/20260618074903.2374756-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-21-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 0f64b97581272e..3f2e088fb27d98 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -37,7 +37,7 @@ static struct afs_volume *afs_insert_volume_into_cell(struct afs_cell *cell,
 				goto found;
 			}
 
-			set_bit(AFS_VOLUME_RM_TREE, &volume->flags);
+			set_bit(AFS_VOLUME_RM_TREE, &p->flags);
 			rb_replace_node_rcu(&p->cell_node, &volume->cell_node, &cell->volumes);
 		}
 	}
-- 
2.53.0



