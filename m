Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626771FF1BF;
	Thu, 13 Feb 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460972; cv=none; b=nzRm3PMNLIXT9Q3qPchovfx1UPPFHyFo3og4h53ampSrT+5MdhtloLd60WuLdag9bmnAdQpxfmCN0wuYhJFrsNQbXmo7HKkG+JgbM9SdGwKZuLjedX5zJTx7K9A2nvpuMhLavsgr8zG0qw4B69S34w66ee5ws2cWJDN2IW0aros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460972; c=relaxed/simple;
	bh=XDGaCuZwqBCwMMUFEKdIE+Gqg7E6jS5agqBiHZG10KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgfEjk7chAZNqo3TSrl3VPzqvWmOi9Xnvo2HU2fMeQfVYj/3qFrAybl02w3d4F/W5VUb5IBmr2Il5ScrMLfKQDuX6JN+m5R5MFKqJD+Gxx6F+5fbdJ7G7KPpcsdfg6+3Ju2AK7Pg0gatwz/M7Fp38iYTgUcOw6OwyUPTyxBRmzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEAgeKxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEAgeKxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B1CC4CEE4;
	Thu, 13 Feb 2025 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460972;
	bh=XDGaCuZwqBCwMMUFEKdIE+Gqg7E6jS5agqBiHZG10KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEAgeKxmxy+BwaKbuZv21YDqdGdyNoXQ+6UZ8NzA7dZzzv25uSApHCCyRxMzBOjyl
	 iibaxxS73axdBUolM2bRAecl3cRx3U1yuBmsCwDd0eF+ktc4aTkTUqSj7gD3AanFxu
	 EzFZhLTOr6yLFk65BS5Tokg55y8F20C5ZkxHhRjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 6.6 264/273] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Thu, 13 Feb 2025 15:30:36 +0100
Message-ID: <20250213142417.848751501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit 6e1a8225930719a9f352d56320214e33e2dde0a6.

The backport for linux-6.6.y, commit 6e1a82259307 ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: 6e1a82259307 ("btrfs: avoid monopolizing a core when activating a swap file") # linux-6.6.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7153,8 +7153,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	if (orig_start)


