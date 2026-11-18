Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022961;
	b=J5ew8tGKVXqOLj+8qVwUHuIXAPE4dDLjzsQeFCcJ+mQW7PaNH/+o5zFRMfDdLOEdr7EE
	 ZL2ffPk1UfICrNMk/CGkbvN4UsdNo2d/vTZlpwEVke7y/narCPBwS1Weq47oYOHA3IDnB
	 U7mIvGNmkj2xPnbKJtlP9PivqAb4o9Tmmc4uHAiq/BSdE3+4JzoKiwWtrBwsqj1nPDFs4
	 bCM9hH17ZEzCe3//P/fPAszuMMFeXPZ6ONLPbWtUpmBHna5StIbAizsgwK15tNZ9zEyE9
	 PLaqcfgkHaGd76LZgJy+7nP5Ow8SOld3QMid6gSm5QmvVU6MelNZy/nedtqjG0mOjeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JSpKdoDecKFG8QPiiOkXEoiDbE7j/U4lP0O8ipccxg=;
	b=cZaUM0i0V30+izVaEE9N/V05RhHzX94KBTBojqfjZhRSdWrCwfDv4ZTC/TAsYbqH12g0
	 dVbFcHhp50IQe+KQAa9t3lKJ96Z8RCqwP57oC2e58aLjyHmvnLrIMjjGtHyjZsMnJ/mOL
	 9hhBY2lW2QM4MROTRb5iQ78ciir3IQs6+frse3TLUIQNYY1LOk5qOfO18V22k4MfE1pQU
	 hGqnwh3X0+BuODPefrSTTCTsmwzPmAmCjA8FtTMpv5tVHEG+aI4eCApIm00gRbBpwK6wa
	 P/krGovIM2Kv2UHLpmdp0nApcxeJLU50VgGT4VmVWzXcDsAJxsBDy6ziFrIsoj/TDZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgU+bl1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F337606A747;
	Wed, 18 Nov 2026 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgU+bl1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E202A1F000C4;
	Wed, 18 Nov 2026 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022961;
	bh=6JSpKdoDecKFG8QPiiOkXEoiDbE7j/U4lP0O8ipccxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgU+bl1DoXP+JuL/w3X2oE9PN2jzP5eMh7b/QuOaN4IhByDti3ZCEHuC7g2t6V6gx
	 VzjpzZZn2szT7giQRk/AcVJJz4uw5avz14UAcNbcXGUzraeIXR0L0NDHvcvEUhc4Lq
	 HNUPr7qoZDdCF6OJpn2rZIDpQ3MqkTFSOwbsmbug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0200/2151] dlm: fix NULL pointer dereference in dlm_dump_rsb_name()
Date: Wed, 18 Nov 2026 15:32:15 +0100
Message-ID: <20261118150129.070121662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 19982c99a302ab544c69f95d37ca3070c89762d3 ]

The function dlm_dump_rsb_name() is called from receive_rcom_lookup()
when a debug dump is requested via a special RCOM_LOOKUP message with
rc_id == 0xFFFFFFFF.

The resource name passed to dlm_dump_rsb_name() comes from the received
message. There is no guarantee that an RSB with this name exists in the
local hash table.

dlm_search_rsb_tree() returns 0 when the RSB is found and stores a valid
pointer in r. When the lookup fails, it returns -EBADR and leaves r
NULL.

The current error handling is inverted:

    if (!error)
            goto out;

As a result, dlm_dump_rsb() is called only when the lookup fails and r
is NULL, resulting in a NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2d90354027ad ("dlm: merge toss and keep hash table lists into one list")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9be5b26f75314..58f3d885c6858 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1421,7 +1421,7 @@ void dlm_dump_rsb_name(struct dlm_ls *ls, const char *name, int len)
 
 	rcu_read_lock();
 	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error)
+	if (error)
 		goto out;
 
 	dlm_dump_rsb(r);
-- 
2.53.0



