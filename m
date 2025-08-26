Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB32FD7DE;
	Tue, 26 Aug 2025 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208350; cv=none; b=lFC70U1JhT+FArlK0OkwljqOHe7D4VePGGF2OXK9MoNqRHojsYl5eGHSXdco7oTb5xITgtA2AYqL8+fgD1zjhS1wYE6nB+2jG+f31zALcqFZTSEsAxyyPRBurcN45m/+0eoAlD/6LH8B73P81AvQPvyAzcFxEq1VHWaXHS7zuJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208350; c=relaxed/simple;
	bh=jYjBioxn34bq9966y+PVEzGhQ3LxisPbfunPGALZK3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iriEcfDYOn4GSg/ijocawwYtKrdvxxz64ApmI4JW+AnGI6aW0cR0+s45MN+7IJNtu7sjBcXfIL8qUncV4ZoeGCJLnRmtsu04rIUgY+rsaHCg9wdCMVt9H/b371HK4OFobhOHlYPjBTLpuYg2Pa9JAzJ0MjtcG7PFgbIDZcbVUAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWUFXTzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWUFXTzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B95C4CEF1;
	Tue, 26 Aug 2025 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208350;
	bh=jYjBioxn34bq9966y+PVEzGhQ3LxisPbfunPGALZK3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWUFXTzA+m7ydE2/OjrWm5zJx3lgQYeSNEQ02c3OeKP6XCGfiylAgZtU/cpq0ywSU
	 xa5f88i0jWv7XuulglXTnI5EbKsIobDumfxC760gCuSfpyLFCjhG349OzP1zmo04N6
	 kqqzVmQHAigzZKCib8s6hjo/k8ZZDoPTozczaKW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 036/322] btrfs: fix incorrect log message for nobarrier mount option
Date: Tue, 26 Aug 2025 13:07:31 +0200
Message-ID: <20250826110916.245632992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyoji Ogasawara <sawara04.o@gmail.com>

commit edf842abe4368ce3c423343cf4b23b210fcf1622 upstream.

Fix a wrong log message that appears when the "nobarrier" mount option
is unset.  When "nobarrier" is unset, barrier is actually enabled.
However, the log incorrectly stated "turning off barriers".

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kyoji Ogasawara <sawara04.o@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1461,7 +1461,7 @@ static void btrfs_emit_options(struct bt
 	btrfs_info_if_unset(info, old, NODATACOW, "setting datacow");
 	btrfs_info_if_unset(info, old, SSD, "not using ssd optimizations");
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");
-	btrfs_info_if_unset(info, old, NOBARRIER, "turning off barriers");
+	btrfs_info_if_unset(info, old, NOBARRIER, "turning on barriers");
 	btrfs_info_if_unset(info, old, NOTREELOG, "enabling tree log");
 	btrfs_info_if_unset(info, old, SPACE_CACHE, "disabling disk space caching");
 	btrfs_info_if_unset(info, old, FREE_SPACE_TREE, "disabling free space tree");


