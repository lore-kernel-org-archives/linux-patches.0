Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285C22D794;
	Tue, 20 May 2025 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750705; cv=none; b=U7daskmexGFVUHs4qC7BZ/uwUf2TFnDDFCTU98KHHiGsrpflZyKt9R/E/Mgkc6Y+xNjG3f7n0dLWKbSvBJEJz46SYqlGHG9BU6NQBX0Sf+G7Djx5Ar0IQe5NbYb+MDxhgZ2hEpQy3N2OuGQ3TjMvv5MeJVY1nfAWtZmX9EW642I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750705; c=relaxed/simple;
	bh=urYACN+rCu6oi1U41MLFrc9A5LzDvTtSlppj04qtr2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjk+nQNdo+8zQRUUAI/uhFKOeFmbsnQMIuPqxT3TgsCeqckrzdZobZvA7BJ5MzudAbGw4t0TZ4H7PTgFiatV3O7sOu607dkKtCG9b7HqKrYTu56X6SgtzHrruTZuets1W8M8yPHVRla6pWsapBMoz65YazDZqHqRkh5zMGs/reg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGOO/50x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGOO/50x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0AEC4CEE9;
	Tue, 20 May 2025 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750705;
	bh=urYACN+rCu6oi1U41MLFrc9A5LzDvTtSlppj04qtr2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGOO/50xwjdDjOEYsWvy0m/QGF298yVR3C0vt2SrOttAlP+yEglJbmbo2EKBdjdTV
	 GhM4/F2RCpNtAJcCvmCBfR2JkqUIB20b8t2QClIN7HS3mXfniHRaJu3GaWcyZzJVSw
	 f0m/fYcjfN+Ogr248t7pDKT1mdpBAM7W8Elief6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anand Jain <anand.jain@oracle.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 077/145] btrfs: add back warning for mount option commit values exceeding 300
Date: Tue, 20 May 2025 15:50:47 +0200
Message-ID: <20250520125813.602163824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyoji Ogasawara <sawara04.o@gmail.com>

commit 4ce2affc6ef9f84b4aebbf18bd5c57397b6024eb upstream.

The Btrfs documentation states that if the commit value is greater than
300 a warning should be issued. The warning was accidentally lost in the
new mount API update.

Fixes: 6941823cc878 ("btrfs: remove old mount API code")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Kyoji Ogasawara <sawara04.o@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/fs.h    |    1 +
 fs/btrfs/super.c |    4 ++++
 2 files changed, 5 insertions(+)

--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -285,6 +285,7 @@ enum {
 #define BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR		0ULL
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
+#define BTRFS_WARNING_COMMIT_INTERVAL	(300)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
 
 struct btrfs_dev_replace {
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -569,6 +569,10 @@ static int btrfs_parse_param(struct fs_c
 		break;
 	case Opt_commit_interval:
 		ctx->commit_interval = result.uint_32;
+		if (ctx->commit_interval > BTRFS_WARNING_COMMIT_INTERVAL) {
+			btrfs_warn(NULL, "excessive commit interval %u, use with care",
+				   ctx->commit_interval);
+		}
 		if (ctx->commit_interval == 0)
 			ctx->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 		break;


