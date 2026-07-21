Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C14E415F10;
	Tue, 21 Jul 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666952; cv=none; b=R1YNpmylPOhV9cXs9/tbAeIsYCckskZv23OqgxiYWxACCr3vzLD9Cjgqa1ycl7F5YtwmdBnBzXXEyE8uyJFrt9119YoyijafsZzB1lByCe9E9nri9RylvCGR4uvhm3+qNvaVsu7HhbdK/zz/l2UaVB5y4HkAD+paXXi60tgQ2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666952; c=relaxed/simple;
	bh=xN/J+pGQx8hQssl43uIhAp/4wz7Rkp0tuXmwWgcy5HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brlDojxOhiYwlTTam3Gt+eC0qC/2vfJmBUMmFTQEaz5vIQ1G8Hl0X8DOwrpg3w6j2kXssNPsNumpmqJAZm5TFJP8cvCq9/rvXlmnZcXW6ptKZZ5L3GZH58g0FZzXviXJTtxEY21cFttSCwvV290IvS8mVGe6rmTrXjL42hmWaOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6ZWCzFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6ZWCzFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24F31F00A3A;
	Tue, 21 Jul 2026 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666951;
	bh=i87C4ayNXYN7T2mDT3kGMvTYhIF4WEdoBJAFwvMH/Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6ZWCzFOB4uDDSHtdaGH1u/N44ggUwLeTyV/zrEMQNDW+JFIUagxrp8v9VQ23DE/O
	 p6+t3t8s92fM2uEFXGJFiau/30Q7jxvUTrL5/MDX0DZZ20GwCGPDK55qQ2VBlg+BRG
	 FD2Qs2xOUV3f/rHD/E6QDTKejbynwx07x7y4sT7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0834/1266] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:21:11 +0200
Message-ID: <20260721152500.517196982@linuxfoundation.org>
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



