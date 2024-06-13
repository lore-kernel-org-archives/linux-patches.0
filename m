Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139F1428FC;
	Thu, 13 Jun 2024 11:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279658; cv=none; b=oIe6raTGIq6iON4yTkqftLX6o/M3GfFJA2ALZzfwtgY78G5PJLetDVEEMKDkkVSDXIs2KvTuwlRfJhl1Ch/SHjLumRXUwIwTY2T5VBnwMQ0JVkCsDQqu1WBEes4wBfeaA1iP2TS2q3jxqLXBzZE6jGvqU04xciDY6snULneVc0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279658; c=relaxed/simple;
	bh=Wzk2trO3NnMS4Dtgw/nA+m984WVNRD9TK1pClT86n6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEo34k3h+5D0ECd81nHuGypa+zjUoMb6kPzGxeJudE1k8ewwWUiIIGPhCdQwneOtPmUjbDfNg7YgiPlg0SkQ194a+7Vdgwk8ooXdbA+juZCjGbIcCcrB6F28rD3g0j0tfH7286ahWvEIc38s+IjsMvGjn1SxGA3e4T/yNvGKiYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlbDPPSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlbDPPSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7EEC2BBFC;
	Thu, 13 Jun 2024 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279657;
	bh=Wzk2trO3NnMS4Dtgw/nA+m984WVNRD9TK1pClT86n6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlbDPPSjofhczJ3OzryA8N8RHF7Lbt4KTrJCAU1Kv4wt0qSk6al4mxHgeWTP9/qRF
	 E6QD8ecyBYYPXqhmcQkUdISjGjxaMZ8zsXBJd8v4DmTLVJCKCxK0SFU6WlQR7JB4pO
	 4ElaGOZ8pHx9bsHHvValnQZ/zwMZD1xGavzFWv5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lennart Poettering <lennart@poettering.net>,
	Jiri Slaby <jslaby@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 150/157] btrfs: re-introduce norecovery mount option
Date: Thu, 13 Jun 2024 13:34:35 +0200
Message-ID: <20240613113233.210863264@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 440861b1a03c72cc7be4a307e178dcaa6894479b upstream.

Although 'norecovery' mount option was marked as deprecated for a long
time and a warning message was printed during the deprecation window,
it's still actively utilized by several projects that need a safer way
to mount a btrfs without any writes.

Furthermore this 'norecovery' mount option is supported by other major
filesystems, which makes it less clear what's our motivation to remove
it.

Re-introduce the 'norecovery' mount option, and output a message to recommend
'rescue=nologreplay' option.

Link: https://lore.kernel.org/linux-btrfs/ZkxZT0J-z0GYvfy8@gardel-login/#t
Link: https://github.com/systemd/systemd/pull/32892
Link: https://bugzilla.suse.com/show_bug.cgi?id=1222429
Reported-by: Lennart Poettering <lennart@poettering.net>
Reported-by: Jiri Slaby <jslaby@suse.com>
Fixes: a1912f712188 ("btrfs: remove code for inode_cache and recovery mount options")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -119,6 +119,7 @@ enum {
 	Opt_thread_pool,
 	Opt_treelog,
 	Opt_user_subvol_rm_allowed,
+	Opt_norecovery,
 
 	/* Rescue options */
 	Opt_rescue,
@@ -245,6 +246,8 @@ static const struct fs_parameter_spec bt
 	__fsparam(NULL, "nologreplay", Opt_nologreplay, fs_param_deprecated, NULL),
 	/* Deprecated, with alias rescue=usebackuproot */
 	__fsparam(NULL, "usebackuproot", Opt_usebackuproot, fs_param_deprecated, NULL),
+	/* For compatibility only, alias for "rescue=nologreplay". */
+	fsparam_flag("norecovery", Opt_norecovery),
 
 	/* Debugging options. */
 	fsparam_flag_no("enospc_debug", Opt_enospc_debug),
@@ -438,6 +441,11 @@ static int btrfs_parse_param(struct fs_c
 		"'nologreplay' is deprecated, use 'rescue=nologreplay' instead");
 		btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
 		break;
+	case Opt_norecovery:
+		btrfs_info(NULL,
+"'norecovery' is for compatibility only, recommended to use 'rescue=nologreplay'");
+		btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
+		break;
 	case Opt_flushoncommit:
 		if (result.negated)
 			btrfs_clear_opt(ctx->mount_opt, FLUSHONCOMMIT);


