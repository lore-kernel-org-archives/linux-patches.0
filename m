Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE29397E9A;
	Tue, 21 Jul 2026 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653712; cv=none; b=QKekhpVRW/HAZO2UjCc7QCQZdhZLvDoxLokhLSv1XUGYT5vXF4ClezO5zz4W2BpMaj269BVmV1ruu2BDPAnuz0+LlySW2o+D/yPrLq3o/Sl0JHAJDfuDFn3gglpvoagu7Tk6oOM5p4pw2fgr5m8Ul+XZBWCjtcHZ12Miv25wJF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653712; c=relaxed/simple;
	bh=d9c9jLr9NXgzsrw6DDJyhK2JfwjSk1xZl0CL3hzESGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQjREFC/S1gD8bndj+8bozr9GlBEE+HPkEyJk4/5KVsNhkBPTplUx9wS2n+vxD9jgBz5jfMJGHmYBeFRoqbob0Y4IQpQdqYQ1+Qc33jqFU8ZVyg9ARy1A8q83Y2hGRdGO3AJFRE9r70x4fLV2y33T2Rqk03BLZxzzJ5ZzMPQdyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOeNdSBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOeNdSBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314721F00A3A;
	Tue, 21 Jul 2026 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653710;
	bh=s7WLy0o8gf+XlLXBqjBIVNzIkTfxwMcBqeq12wy88UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOeNdSBaf7QQp7afXyvuB/mgxiWUwJxLZByIlT/PVlTHHZQ1TgKnQniU+JX1NVuLB
	 +MC/EYcrMQXbtqgvBf9tIJDbrNbqsGzEDgumW4zquGx4jahZM8in5YsuXEVEGLCcGL
	 sEV0GLgEpyvA76H8YZwrgLfyOCYswzZBo1uq3Nb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1387/2077] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:17:40 +0200
Message-ID: <20260721152625.529913207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 003889cf0f18dc..0dc1b005f554f4 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -200,6 +200,8 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
 
 	b += sizeof(*hdr);
 	while (end - b >= sizeof(bs)) {
+		int nlen;
+
 		bs.name_len	= afs_extract_le16(&b);
 		bs.priority	= afs_extract_le16(&b);
 		bs.weight	= afs_extract_le16(&b);
@@ -209,10 +211,12 @@ struct afs_vlserver_list *afs_extract_vlserver_list(struct afs_cell *cell,
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



