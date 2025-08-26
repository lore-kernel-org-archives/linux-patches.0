Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0684A29D26A;
	Tue, 26 Aug 2025 11:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207104; cv=none; b=PDaha0zCDBU5LrJKUAj9bGX2HFUM/R3u4hKp+VA5L+lYCSS/TZk+pvDV1OBrrBp2Y5P4wbbVv0CthP/w7c+9HtYLVFW1+uV5HBhOSmwsxaMgQHbLD0WskkekiPI2DyOpNFRgBekcea4gnFRqWyAOCMAqrq9pWIrTV8H2jg7k4uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207104; c=relaxed/simple;
	bh=00H3mx5wvFjtSOkGLNHB0kOd464xUMIW54UbKgIsgVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeHijOk0mP9LxQnyx+rfQ97hycM3McJ7XK4utGf9BxFM0XvcIYK2Hee7sT725dUGtiWRvk8ASqUKiU48P8B5s9yfSYknVFpUxvYn98yE8B6EVdUoGkXgcTtjvMnEoJA0UL5T+wJaCG9mDPoDLluY5TFvEmCFcVvpZGNKv+3d0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLwEyPxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLwEyPxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A71DC4CEF4;
	Tue, 26 Aug 2025 11:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207103;
	bh=00H3mx5wvFjtSOkGLNHB0kOd464xUMIW54UbKgIsgVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLwEyPxu5Fptxf8KC8x6LHKcK8vx3icrgpcaPwFedL8U7HzJmo+gHU4l+7T4s4yO9
	 NX53QoO/4lFY86k2VknaL+WYBua1yUNztT+/nSMyhkj1OjMy7iYZUD1A1tW6SE36+H
	 4GZ0wcE1firOhteTiHe0kIIuguzY5Qyi3Ov9kMcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 045/457] btrfs: fix incorrect log message for nobarrier mount option
Date: Tue, 26 Aug 2025 13:05:29 +0200
Message-ID: <20250826110938.458913670@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1453,7 +1453,7 @@ static void btrfs_emit_options(struct bt
 	btrfs_info_if_unset(info, old, NODATACOW, "setting datacow");
 	btrfs_info_if_unset(info, old, SSD, "not using ssd optimizations");
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");
-	btrfs_info_if_unset(info, old, NOBARRIER, "turning off barriers");
+	btrfs_info_if_unset(info, old, NOBARRIER, "turning on barriers");
 	btrfs_info_if_unset(info, old, NOTREELOG, "enabling tree log");
 	btrfs_info_if_unset(info, old, SPACE_CACHE, "disabling disk space caching");
 	btrfs_info_if_unset(info, old, FREE_SPACE_TREE, "disabling free space tree");


