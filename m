Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D13EC2F1;
	Tue, 17 Mar 2026 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765835; cv=none; b=Jxxkb5n3nUiXn6lpxBDwJCi1HcGYzJzuTlhGwYo549zELsB+I6aNg47IjBOrUkGMKyHis2gkIsLliMbDhB6WjCmVS/SKUHsgESq1rEYaxVeFhP+9mz9H71J3tb9aUWIsi/6s17C0TgmbIetInOCm45SbDuY/kh3ZqCd0jWX+bwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765835; c=relaxed/simple;
	bh=4YJ08IsBNstPGnH1LTlwepHfqOOsNpJBHNouTvRSm8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFBRqSxeTmsKGIDDEYWwn3C/u3lXAVFNk3zxtAi3sh5s3rnVObKn5o/3mWPH6OxFfyDv4Nil5KHpWwwj3G1z/Qv3QsOO8FxKRi0mypfT5TgvWkT0v9gLfqAzFxxIDaQmfArxHbYlTQWH4ij4AvTidQy7++hx/A8GH6Q4iNYHr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRPy3OW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRPy3OW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE4DC4CEF7;
	Tue, 17 Mar 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765835;
	bh=4YJ08IsBNstPGnH1LTlwepHfqOOsNpJBHNouTvRSm8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRPy3OW50zX88cR2/gprhF7Exio1xHi0fU7o1lUkDB1a89X1cOGMPZBZqg6YPpVK8
	 ECMAGmYJCDre3WLueUP3X3TyeUuOI1qU2E0MjSUFRZ05+ytPKotAqNFmSmt63ScjQP
	 xvxhpqS/a1KkcnjLvKs/yOPVcD5ngSdLfuCrG5z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 106/378] neighbour: restore protocol != 0 check in pneigh update
Date: Tue, 17 Mar 2026 17:31:03 +0100
Message-ID: <20260317163010.917023687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cbada1048847a348797aec63a1d8056621cbe653 ]

Prior to commit dc2a27e524ac ("neighbour: Update pneigh_entry in
pneigh_create()."), a pneigh's protocol was updated only when the
value of the NDA_PROTOCOL attribute was non-0. While moving the code,
that check was removed. This is a small change of user-visible
behavior, and inconsistent with the (non-proxy) neighbour behavior.

Fixes: dc2a27e524ac ("neighbour: Update pneigh_entry in pneigh_create().")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/38c61de1bb032871a886aff9b9b52fe1cdd4cada.1772894876.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 96a3b1a93252a..e4ee0c02fb443 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -821,7 +821,8 @@ int pneigh_create(struct neigh_table *tbl, struct net *net,
 update:
 	WRITE_ONCE(n->flags, flags);
 	n->permanent = permanent;
-	WRITE_ONCE(n->protocol, protocol);
+	if (protocol)
+		WRITE_ONCE(n->protocol, protocol);
 out:
 	mutex_unlock(&tbl->phash_lock);
 	return err;
-- 
2.51.0



