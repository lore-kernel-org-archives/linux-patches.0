Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785C644AB7B;
	Tue, 21 Jul 2026 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669757; cv=none; b=fZILH/28/tOcrq21YiMQkBy3L3vhaOPi7ixc+L0RBHy02/zQdr7gDj9jGqDFKMJ82+LmF421+sSjmpc4IIkkP2+kNgKviTSmRopshZRXVmfp+2LCGaEqWlnRVtegDZwqWTBBOjpXOY30BuRPDpEYTRgzF2MKZtY6/WJj/hFTFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669757; c=relaxed/simple;
	bh=AR9b+BqqnLisA5G2057clRpDBMFAEx/X3Ekm1h/Cpn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScM2bqWXdhjBofv/aWEWUMsVZNrJcFjLNdCBg7rDidetvb5w+P8zN4BMHhh5lDc4WqOhkxD5pi5+hoL2UyDlaX0lAKNpwF36bOqg888xdXAXOrxC/Qf4L6bY/oMfsjY/TXQTfTnqP9fKsVVzlxVWt4Qzq0uhXCgYEJofY3KOpzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1Xl6aV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1Xl6aV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7681F000E9;
	Tue, 21 Jul 2026 21:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669756;
	bh=g5DnDTzzLp+1veXM+saextjkMwVvEII4Om6V/drbGlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1Xl6aV4tLcV0htU2p0l1LgShhIzOOOaBn1Z+vtj8zgnCSEheHFnk3v4Q6Grq+UQ3
	 fyjsh34i0tbUEtv4AuGs7VO7R9M5e47pX+gHgD0ydnHOSqIsKpxPReQpYaXCWvRUdz
	 kT5Mu+FBSH622JvAtHIcmbRxITYXAGDv0firwa2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0675/1067] afs: Fix unchecked-length string display in debug statement
Date: Tue, 21 Jul 2026 17:21:16 +0200
Message-ID: <20260721152439.696564434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



