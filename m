Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA5434E2F;
	Tue, 21 Jul 2026 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672141; cv=none; b=ClBCqDiEojzNeSJpTztNYRpeS9QsaCz1dGGfn+kTqu+9QiP9QX8B8J5Ii+2YFrTLVMWDiK0+ymcYwW7PWpUAsuDFtZpinNSceumFOUAXh+T0e0xbIuvLfVycIcCm3XY51Mg8meWkWS5pg9qn8p3SLeD+L+nflY6aDpgbqtht0+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672141; c=relaxed/simple;
	bh=HAa5X0pyJPqqywsFmzO1YyRPb9MX5CRHzlZf128K9tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEZVVNOjJD04krRtRVf2+f+lZr0RBOXFX0cMbpbSoZ9wzag/kHBbXeH+wn/dycpP0T0V4eCszxqlwvT46WYe/6+wFm7g+GEX+m5iztHgxNFKLdPfg13RHeTqw8JOYLTJTzzCMQwOxSFJ7ztGQBeCoRxGyD1jIVGxJO/r8SNS/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfRPD2qW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfRPD2qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BF61F000E9;
	Tue, 21 Jul 2026 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672139;
	bh=4drRA+T0vyYFshy5OkeZYKgIl7QFepOCjJW8FA2abj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfRPD2qWEyk399OvckHeKHw6FoJA9VNCpItt+trJaYeW9i1j/+oGCITlRSnRzMhXv
	 zHyi7jcJ4V68++zRpZRZ4DcU038RAJLXiAmHqoodS5ZGgBZzgiholazVVtCcjlTpzw
	 5WGMtwMEctk/2D34kK0YqzWg+FsIJjtXZWbgjXb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/843] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:22:27 +0200
Message-ID: <20260721152417.549744369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 631ee7e0629dc1..2761ac3ab0076f 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -192,6 +192,8 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
 
 	b += sizeof(*hdr);
 	while (end - b >= sizeof(bs)) {
+		int nlen;
+
 		bs.name_len	= afs_extract_le16(&b);
 		bs.priority	= afs_extract_le16(&b);
 		bs.weight	= afs_extract_le16(&b);
@@ -201,10 +203,12 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
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



