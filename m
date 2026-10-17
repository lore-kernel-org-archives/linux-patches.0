Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A717BED0;
	Sat, 17 Oct 2026 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257960; cv=none; b=FliDcgjmrT/Lh0v2RxI+WtlmSkCZkNfRsmtFutqq3EWgoyMhYjFvMQvreEzgzdR1CELQZzf3lSWlCUgfcY5fihMFpQ4/dqyItzHjBgmdb1KxtQ3ByW/NTm7GZSMWF0fRlMQ17BLMrsq2tvc46bGAVJGkzawm3/LXJLMAjxScEBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257960; c=relaxed/simple;
	bh=Ob9vz/jujkAwq7m36Ru9/+ZDE//Rul0dgNY7bPGn6Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjdEjhL4XZKV9Ewx1j25Sf46ifg//g8Cf/Jyd2srEiwngUhQ7ICf4iXHQovmQ7fvEh2vklql9lwqCumwzh/kWqE/JqnDQ7+A5usxQrmlVxLlSABdXmQM/ysN6DrT5+0Fc3LzwC8u2cAyzJpDavL/9Mpeel4MGsJz1sMimnqWwCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b10KbyUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b10KbyUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FCC1F000C4;
	Sat, 17 Oct 2026 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257959;
	bh=0/JCIhljv4kJOwespfp1BiWpTeTT8X8Flk9iss1EZsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b10KbyUxcwfYTwZV5kUazKXRn2R5ariX768quvl2fEeeIEiZGJJPycj1sH1mPm8JL
	 0P0ivuY9sYbOuLU771HsTZsTHDJnj2B9AuB8QmXtGuPwhGiwkakV8WNzBcxiy6kgZx
	 92cYgfg+mS3wMbQ+YsMfm8jGOD54HB8g4Vj+TL20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0726/1674] btrfs: remove pointless initialization at btrfs_delayed_refs_rsv_release()
Date: Sat, 17 Oct 2026 17:49:58 +0200
Message-ID: <20261017160449.745204976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b6ea3e6ab569d9ed7472e8df4cbf5f78fe49f277 ]

There's no point in initializing to 0 the local variable 'released' as
we don't use it before the next assignment to it. So remove the
initialization. This may help avoid some warnings with clang tools such
as the one reported/fixed by commit 966de47ff0c9 ("btrfs: remove redundant
initialization of variables in log_new_ancestors").

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7511e29cf135 ("btrfs: harden block_group::bg_list against list_del() races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index c7b1ce749175f..2409ee23b1b67 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -66,7 +66,7 @@ void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
 	const u64 num_bytes = btrfs_calc_delayed_ref_bytes(fs_info, nr);
-	u64 released = 0;
+	u64 released;
 
 	released = btrfs_block_rsv_release(fs_info, block_rsv, num_bytes, NULL);
 	if (released)
-- 
2.53.0



