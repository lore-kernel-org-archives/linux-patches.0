Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34625E83F;
	Tue, 11 Mar 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707193; cv=none; b=Rv4x5FX4kcajKtwa/EyHuuJxTAkmOtufqtPW1JAZCRgu8K/r7fUeevNjC9ljKqQGkmo72FWR+JrqAQcRTb71GqHxsz8e7TjgPjI7zbb73GNvRRprH7gq3yIqehBLO69H6ZtHLVsNPcfd0l4ILULXbOlLuE2+6dEIv0+3qxvRYqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707193; c=relaxed/simple;
	bh=A5wyZm07eXV+fZOnDKaSH0oCuXTqPVHFLdObmOb7p8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6kfYCra1HJ2TNM3/+37OzaL552fw4DWMAkSJh04ZLs4RBECVt0Yo7N/BdU8nDraRVS5XkFCM++I0Fo2QUCC4DrgyvIgEURQB1Ujk5F075Li1TucfZKpoZ23ajn/OYqHAxmpNim3xl6JYJ1pwzXWL1AJyp2rY8xboEQ0ZXMt9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdxqEUi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdxqEUi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D799CC4CEE9;
	Tue, 11 Mar 2025 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707193;
	bh=A5wyZm07eXV+fZOnDKaSH0oCuXTqPVHFLdObmOb7p8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdxqEUi6NlPXegCKBxCt0qRlUavGZFv129ZfKSpV0QmeUTJNwwL5wZrsahk4YSdfT
	 b4L2Ps6+2UV94sM3Yz+pX57Ki9mmSez3FWHy7fcpDvcHaOjjgx/Fo51Fei+KTcI/tz
	 lRgdGzlmwmU3ip+NnvYMxJJmxH7rOncrxQRc6x4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.10 305/462] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Tue, 11 Mar 2025 15:59:31 +0100
Message-ID: <20250311145810.408883036@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit a1c3a19446a440c68e80e9c34c5f308ff58aac88.

The backport for linux-5.10.y, commit a1c3a19446a4 ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: a1c3a19446a4 ("btrfs: avoid monopolizing a core when activating a swap file") # linux-5.10.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7127,8 +7127,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	btrfs_release_path(path);


