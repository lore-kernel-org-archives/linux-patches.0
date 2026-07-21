Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2927436344;
	Tue, 21 Jul 2026 18:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658094; cv=none; b=BfJxmBEebd10vnhue8RBBWTn08FHZ858HyI+X5pa787DxZjNobcmbfbpkK674TVnrbmuD5IeFRmrx3HRB5N4R6S8HOsyESz2CjvtFZksSDjjkwkJeV15AaJIgx2BTieJ+kkzdyQ5jt2YRaCKLCAniind2t/zQXlwWromH0fPoAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658094; c=relaxed/simple;
	bh=+2FgRE8xPIRtvsbheDJySYyBgsO18YXl5iTt0UyNSMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH11lUDtT9XIbJurtUt8t06kD6kwMh8VnrB7IFrXdENH6ZnVAQJT3rrUDWB4vXA0ySgfPsG2EXdf4myQqNL/bI3BX6M0LAT1ioom+JqEn6aj2WncrSyt9bUepy443G8BbLiv5ZAXPBwedlF/X3oqfJ7FBcDMvfJQUCdrZjTqp5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln2gDWor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln2gDWor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3E91F00A3A;
	Tue, 21 Jul 2026 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658092;
	bh=zAWU9ga+r3MilIfMm/e7fX+EJ/3oLJHdF8qSUxpq93I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln2gDWorfHe+NDC3CtY7XLk3tT9pku/OiYZp9BzcJTmOyVU+fSXptQ7rFuGhAE0fy
	 nrR/a2Ek1m19xoasFvxYi0UYktaEDJliJ8D42nZXW2wxcM/Moy4hAyj1AVECxnGpxZ
	 pI8kHncAIYVDW2RSZSwywJ9i0+++gui/xGPlsA1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1012/1611] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:18:48 +0200
Message-ID: <20260721152538.158625925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



