Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028431;
	b=g1ip+Da4Tjbd3gyGzwoCXQbHKAgDuCM/cqfRGrbzagv5q7E9CNOzZCzKyT7M9OQrNM2b
	 plKNdFI6w41Eo66PJo9pCi3UaJOgUt0E/9S0pNqC8CqivCNap6/xiW8WwXdloh4NTgr7u
	 ES0jCufbQSv36D7lh5nukrqdmmfS9J5HdxnKyC8G9AKKGkTQnqMY6BV3PfSm5ZSB1WMOb
	 LWLhxGtP99EXlBjjpSpkCfChVfSoND4biPYn3fwX61+U7ojmsgTVupYVA+WtTfwf1QQ6c
	 Sfn4JIk5WLS1AHqnmmVTTVZRUzGLmumG9NATbeypS2LSkwtCgEgD9Hk8QwZ8gEquhbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jugPDBlpI56zHwSPyX5ugsCwKzKwuBivpprSM9P87h0=;
	b=qlaCEKi0X6cepYNUpOyKcVCcuD4P8yUtK+hhscLNlZthlvSvCHSybpWfV1N/WjDHxmyA
	 JVQWlWJTN5/Mv49iC/oit1GY2SxtbrJCDA5dcfDieIVE0IlbK+tCurJwYai6TjxMKZVRB
	 dr/PzEVNG3JJl5DrQWed1MYcnwbRkVpBRTpH2rOlfyzM03iDntHWT90WhRXf5Bb7+vTld
	 qj/mKQ7Cl0I2Tdj75oubmFTDAJSdz4N2N5Ob6vWD67Ya7Hdy+nK3L8RE6ZH84kIlmBVUD
	 k38KYvNsnzVqvOhpe+93eFdZ/1iXeLT/kjD22Kf+U5uCy4/G22NcrRwspazI1nDxL8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCLByiiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB854606A31C;
	Wed, 18 Nov 2026 19:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCLByiiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203EA1F000C8;
	Wed, 18 Nov 2026 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028431;
	bh=jugPDBlpI56zHwSPyX5ugsCwKzKwuBivpprSM9P87h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCLByiiZB87AmkSgBZSl/Y5kWXFTWDbdmkbA9Mq8uF4+u/Jfbxq9sl3cylVqdEgXu
	 DnRN3Uu+hW+0Y5+TEZUGw7FIYZdGeRbQTSpJcrKpvr/oEpMszvw69b3SGaqjioLlDM
	 MS0ntmrBxJjJIMHDI5kFIPKB67lx0NdAuhUhJHlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jaron=20Vi=C3=ABtor?= <jaron@vietors.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 2143/2151] btrfs: do not reject a valid running dev-replace
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150239.733851743@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 3c0c45a4dff73845ba93d41365fc14e45ee32bd7 upstream.

[BUG]
There is a bug report that a btrfs with running dev-replace got rejected
with the following messages:

  BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but not found in chunk tree
  BTRFS error (device sdk1): remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
  BTRFS error (device sdk1): open_ctree failed: -117

[CAUSE]
The tree and super block dumps show the fs is completely sane, except
one thing, there is no dev item for devid 0 in chunk tree.

However this is not a bug, as we do not insert dev item for devid 0 in
the first place.
Since the devid 0 is only there temporarily we do not really need to
insert a dev item for it and then later remove it again.

It is the commit 34308187395f ("btrfs: add extra device item checks at
mount") adding a overly strict check that triggers a false alert and
rejected the valid filesystem.

[FIX]
Add a special handling for devid 0, and doesn't require devid 0 to
have a device item in chunk tree.

Reported-by: Jaron Viëtor <jaron@vietors.com>
Link: https://lore.kernel.org/linux-btrfs/CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com/
Fixes: 34308187395f ("btrfs: add extra device item checks at mount")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8462,7 +8462,12 @@ bool btrfs_verify_dev_items(const struct
 
 	mutex_lock(&uuid_mutex);
 	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
-		if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
+		/*
+		 * Replace target dev item (devid 0) is not inserted into chunk tree.
+		 * So skip the DEV_STATE_ITEM check.
+		 */
+		if (dev->devid != BTRFS_DEV_REPLACE_DEVID &&
+		    !test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
 			btrfs_err(fs_info,
 			"devid %llu path %s is registered but not found in chunk tree",
 				  dev->devid, btrfs_dev_name(dev));


