Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5546120010B;
	Thu, 13 Feb 2025 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458536; cv=none; b=MrlUsaUO2DplkVSiQVWsTm4lgW2meEDDeiCRhyyoPtNgzUcsMzFmrh41tZ44r4UvEtgqvptkUaikwwk5sadNogABUrQgkhO0mHTbWhTFjlsYBdtfrqcQp448E29adGBRNL/f+XMS6e4Ypep+MeVqTqEqPjk4kPx7cFr3GZJxfAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458536; c=relaxed/simple;
	bh=ezQjZWohAPGZDpfbb5CO5tosFEldxkP4Ds0bSNcKvPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDxV1xhyMo2hXvcxg8TrdxI+Jvm1Qk8eRoA5NZvE79j5bDGy4bmPCNJDyqZjSXY7xOpyipNT/clhLEKwTImkV7S0chTWj0AVKjwKjguFgCr/PXFLy2rvVNq9/SH0+S/io6jvfEdYfqt0h2Myo1YSuOVLewr77mBdkf31fs5lnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3pv92Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3pv92Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48ECC4CEE5;
	Thu, 13 Feb 2025 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458536;
	bh=ezQjZWohAPGZDpfbb5CO5tosFEldxkP4Ds0bSNcKvPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3pv92Ube2c/UNyEKdq4IiRgT0ARPHT5UGkPmF29EMl06XFoJYJFkRIouC/9x0GQa
	 OZ4I5r76OovBAn3bEeKNQz+miQKZkjeKLClEkqrOMB+YOvoO10DssaULIerAMTBRlD
	 Dlq8aQG0zvdYnoeKlB3nTbM2+xEpokt4BAiFq/tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 6.12 409/422] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Thu, 13 Feb 2025 15:29:18 +0100
Message-ID: <20250213142452.341773313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit 9f372e86b9bd1914df58c8f6e30939b7a224c6b0.

The backport for linux-6.12.y, commit 9f372e86b9bd ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: 9f372e86b9bd ("btrfs: avoid monopolizing a core when activating a swap file") # linux-6.12.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7200,8 +7200,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	if (file_extent)


