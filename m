Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D604B1C5D6F;
	Mon, 10 Mar 2025 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630565; cv=none; b=UgXgzwxq1IgebHLVJtzGtsvz60bE7Uhcp9Vwb8smsysOvmSeqfruBpiVIeyxNyUzeYu8SpzKgLxd09+YcgRmM7uaQ8ssiRrgI6rTak8biuxB+9/LfiemhYOsqBa7AdMjj8kkTSGHyt35zGY+sUM0SSW+/fVb1gA2CJhIssJYuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630565; c=relaxed/simple;
	bh=1Jx9fNcbMcJaX7jsqyUocEnE8gPcvhGsc0LoN3+VFJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0OpnttDUBJS3oY4arybFU1jDO7hm1AJnYncj5PLim1bbunUtfKAtgX5fwjIBO2md6q73esArolDpiJdtLeOd3X81jesVlOYS3qT6VkhfU22XYfQJC6aZefyhjCvoyQhlLLBB80lphdahaFFmOFRt5bXPHs4NkM1U6CUWXo6IGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7VD9ymS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7VD9ymS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D7C4CEE5;
	Mon, 10 Mar 2025 18:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630565;
	bh=1Jx9fNcbMcJaX7jsqyUocEnE8gPcvhGsc0LoN3+VFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7VD9ymSm6/8C+7FXU9FaMwAerzJ0IjZ4Y4+TkNxBzCXmWepBlG1zK5xCy5FbQrsW
	 P/sKECTIiPbMqdua9dTzO7oSd6spHRvefPLqD66Ok11BoNvIYQSsa4R9lAMfWZpY4E
	 2Kp8J48f6rYJGli2g0ph04sObuC2fyHysQ29LdyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.15 427/620] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Mon, 10 Mar 2025 18:04:33 +0100
Message-ID: <20250310170602.451350989@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit 214d92f0a465f93eea15e702e743f2c63823b1fd.

The backport for linux-5.15.y, commit 214d92f0a465 ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: 214d92f0a465 ("btrfs: avoid monopolizing a core when activating a swap file") # linux-5.15.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7698,8 +7698,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	btrfs_release_path(path);


