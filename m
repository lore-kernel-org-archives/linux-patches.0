Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF93C10AB;
	Tue, 21 Jul 2026 22:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674034; cv=none; b=lJ/VJ04oYgb7pW2TL81d4ohGnCPa7VbMYiB9TjdN+HzkU2tyenUmEyGZGj6GsJsmAda3/dRg1SX4Tz4ozTzaSF6v65jJd0Sk7WkrpMM3VWPAhr2a65suXbe2outb7wb0Nppjqo0rmiURM+A5Yu+4Pu6gycXGtih6WVXW47sg/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674034; c=relaxed/simple;
	bh=Yi4o//SQpnLgyH/rRHMKZZf/dg5QJZPPvZn8j7IcOm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVlKSsFOcWWrh8kvOgxEfl9vT2W7hOfMSdpJ0Ex4QhB9u4L6pJjG+ex1PRbCXHkZXTVtBB7pZ2VC7P31+UPQCK51Eupbw2/uvCtA0dUPdRJqMMwFDKDXjUbQcWDxnQqmArqZiOSFNnfIaLn4byr5f0WbfKaNJVl0d7ZOzJvIDgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HrC+HNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HrC+HNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DCF1F000E9;
	Tue, 21 Jul 2026 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674033;
	bh=SG96vNo2NYSi4Zz5FP2omOOlMVCOQERYLnXlxqeybwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HrC+HNqB0zCbgm3wrOJ0JqP2RZAXU64hJsDxw7hyJrLSXsbfZzD4nMOmXzmWwQFd
	 hrlKPJMTWB8fTJjSFdEavCZcKVUO+HXdenpt/YG4+nXDD10EdOz/R+3Fqk/F4xyoa0
	 z/GdiM0DTb969vK3UguUykAnjDO3WI/Xdn8K62w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/699] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:22:26 +0200
Message-ID: <20260721152404.422188441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8508d225509bb0..d7199ed4838be9 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -199,6 +199,8 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
 
 	b += sizeof(*hdr);
 	while (end - b >= sizeof(bs)) {
+		int nlen;
+
 		bs.name_len	= afs_extract_le16(&b);
 		bs.priority	= afs_extract_le16(&b);
 		bs.weight	= afs_extract_le16(&b);
@@ -208,10 +210,12 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
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



