Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8F3A4F4B;
	Tue, 21 Jul 2026 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663338; cv=none; b=kck9wpBalwo8tI5Nn0e2ytOwqkFFu8xKruv4+Yq6BJz2i+4lB5cgO8nDxb/ABFx8n0vDpLdEa4JfyDryhabWs9iPDQQOJJEe/TiQlFpjU2w6APc0yMmh7I/uS6VdI9qqEMKBZXrqUCMKxNRZQGuBQ3XlPzfumZy/qRrSeXU78R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663338; c=relaxed/simple;
	bh=++jVH8gWxvcpNLIRRdj1JCZwEW0xXWVkDjZykX0R+LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYRtduggA9B9yn80BXpdlW7unFtXLe+PLLIUPfn9Sa4BDk2yrgk35HVxdAj9ttsYP/RxoQrKng9BahLFVgOtWXhwRRrRbP9EwOuZeEDyVDRJpowVdRiDIVxXrGFZtPwXuGX6PpdemkzHwnChUg7qhLaODmPfQannhM6M2MDJnzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrjEVI/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrjEVI/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA681F000E9;
	Tue, 21 Jul 2026 19:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663337;
	bh=7TK6c+rY48vHF5M0PtJeQPhalUoUwgqVdgfCVURTby4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrjEVI/0ld1b665WhzVZjRN7QGzIa3/sX2lO++b6+itSDDv+pELSwq0DacaVG0saH
	 RYWrinZgWCoBBN/6sD3p92sX7f9JqkcgJvJVD9d/lIe4tU8PGZK+kwrAvQUHUJvHTJ
	 QOcuP2SaweI3Yc6CX19lD6OHJmx4Jjd4K3yMzEDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0742/1276] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152502.684760652@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 903d37c97228258da71e092f8b4ab260ce81497d ]

Fix afs_extract_vlserver_list() to limit the length of the displayed
string in a debug statement().

Fixes: 0a5143f2f89c ("afs: Implement VL server rotation")
Closes: https://sashiko.dev/#/patchset/20260618074903.2374756-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-22-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vl_list.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/afs/vl_list.c b/fs/afs/vl_list.c
index b25830d040da0e..429fde817e1d5b 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -201,6 +201,8 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
 
 	b += sizeof(*hdr);
 	while (end - b >= sizeof(bs)) {
+		int nlen;
+
 		bs.name_len	= afs_extract_le16(&b);
 		bs.priority	= afs_extract_le16(&b);
 		bs.weight	= afs_extract_le16(&b);
@@ -210,10 +212,12 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
 		bs.protocol	= *b++;
 		bs.nr_addrs	= *b++;
 
+		nlen = min3(bs.name_len, end - b, 255);
+
 		_debug("extract %u %u %u %u %u %u %*.*s",
 		       bs.name_len, bs.priority, bs.weight,
 		       bs.port, bs.protocol, bs.nr_addrs,
-		       bs.name_len, bs.name_len, b);
+		       bs.name_len, nlen, b);
 
 		if (end - b < bs.name_len)
 			break;
-- 
2.53.0



