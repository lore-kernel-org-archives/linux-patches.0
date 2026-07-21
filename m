Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2647124D;
	Tue, 21 Jul 2026 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658057; cv=none; b=POJBucMAHpQfzwPkFEIciNpwR+7grBl7xkOYdn6clxNxVJ7MaY5kvwHZ4XKJYJi/Z8SjSJpwT+6i02ifem8JQ36xKoRixfgfNHVZWxSnKkNJJBOskACi0BbybwJbxfwn3WNuU80MIMh0LYWxliJ+WdNA2QsKAOCwnn8HXeaWYGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658057; c=relaxed/simple;
	bh=dNGYZMpxhyxn3QnaliPsJ8BskbFlMVhlGj9hfVX0QAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrgSh4XkaOBn7rhKo/QuLCBxZfJXq2eV2B5GNNcDdtmGi/zprw8LyBPnWt+z+m0bS9Qj6HY2k19dnkd4f3TBDRaJrBMXWF+S1trrFXZKMjVXN1/scY6+bQrbQ+VywHF8ksYKSZcw3QUbJicTIaYVZfgpU2zHAbfxLjQNX8XmlE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y881bqrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y881bqrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975081F000E9;
	Tue, 21 Jul 2026 18:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658056;
	bh=pz3TkqIvZrCLlGali09D/LbupxAVwdQ5pWg9ZgoRwU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y881bqrPrj9aFrJvJrcyYbtFqPWtHziIz71TgHFBvmgsp57T8RoVVAdwoPVlqCjuI
	 hEtbj4rbIeOuSnv5y1Q0ZslbabqpkDbV6SBJAaKcd/Jq9F4zt9iAgbJlTYd9OOVxlo
	 LkofxdFSh9P6drd2AQ06DEqq1heZBmhNNJxwNMgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0999/1611] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:18:35 +0200
Message-ID: <20260721152537.863562307@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4897cb71d4ab1f7e1a214adb1e4b80176702368d ]

The error codes on these paths are only set on the first iteration
through the loop.  Set the correct error code on every iteration.

Fixes: 0a5143f2f89c ("afs: Implement VL server rotation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vl_list.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/afs/vl_list.c b/fs/afs/vl_list.c
index 9b1c20daac53bf..b25830d040da0e 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -93,7 +93,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs);
 	if (!alist)
@@ -111,6 +111,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -123,6 +124,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



