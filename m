Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D47146D53;
	Tue,  9 Jul 2024 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524612; cv=none; b=sjaPRzFZN4WBsx6h0KFoobJdwUKZ3wjiR00T29MV+Hsfv0gR74hmLcRJIqHwJMUIy6D4ryyQB+WaV6Q15R2hLBS++HNb6ongRHWUkp1ZcQBhFIZ7mF8xdpvLngVFEhsbO8U4wvhQq6ykhHP4M2kTWB7A3kizzrGAo2101ZEYrIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524612; c=relaxed/simple;
	bh=JCxzKQhbpvXSf9qYcQdh0dm11lg1j/otQS3bSG5uvPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnVzVusjjYxRHAWwl5t9qQphhpKCoIMQE3B66Mhdv6X173p0O/8aEhzmOE10jcJhAdiZIKidjAbdqWRHA0VPn5kk6SJkksJoDHLgNO03TGpzpyHBKFxogx3T2FsvClVUfVdSF5srOMg4nHnOqlci+TiU8UvPSvhECCP+yztt5Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdIFxVLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdIFxVLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC10C3277B;
	Tue,  9 Jul 2024 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524612;
	bh=JCxzKQhbpvXSf9qYcQdh0dm11lg1j/otQS3bSG5uvPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdIFxVLgWT/0XySNv5N5GtwFvdbeYzQo1pjNLEaUMMtX+P4n6kIYRzumnIa+UXmWI
	 f+hReuADgMV2oyEGoByG0SlmTV/bVwxa2z8yF9OpJYD8t//O0gja/z5OGrlcDt1uhj
	 +r5a7Lptdc0iMWdlfy9/5WHPIuQKPreYoHjYw188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Lu Yao <yaolu@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/102] btrfs: scrub: initialize ret in scrub_simple_mirror() to fix compilation warning
Date: Tue,  9 Jul 2024 13:10:04 +0200
Message-ID: <20240709110652.972329339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit b4e585fffc1cf877112ed231a91f089e85688c2a ]

The following error message is displayed:
  ../fs/btrfs/scrub.c:2152:9: error: ‘ret’ may be used uninitialized
  in this function [-Werror=maybe-uninitialized]"

Compiler version: gcc version: (Debian 10.2.1-6) 10.2.1 20210110

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 12a2b1e3f1e35..f48895a9b165e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3407,7 +3407,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 	const u32 max_length = SZ_64K;
 	struct btrfs_path path = { 0 };
 	u64 cur_logical = logical_start;
-	int ret;
+	int ret = 0;
 
 	/* The range must be inside the bg */
 	ASSERT(logical_start >= bg->start && logical_end <= bg->start + bg->length);
-- 
2.43.0



