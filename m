Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731E29A1;
	Tue, 17 Feb 2026 20:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361531; cv=none; b=Ir95eogokZIlShD7zzPc9iG2krR4ygC5MNfqAMZvBB0J0PKuM9IfuYx1x4Drdvlki+cfV1YJP/XC3BfuCUkupnZ+OFxOUfxW50yNNwGIO23u2OtrA3DokhzydGvQ3YEeBO3DljxuwZiPvkD7KDLrW/b8kIqC2GcWrG27CFO0XWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361531; c=relaxed/simple;
	bh=ZKJrD5wUOEFCRjFOBSLlb0F0QHLRUMsrGGX8AVlWe2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDAQQI+5vHYiwsosrDNxn8XGku4vY52MOXBZX+rpPzbTC7rJHfofpNlx8km9QCw4/wiCvuiOS3cdi2G+JYpnrKpZCBlkF9miY059PMa8yE6Vti2G4j/a/oYJx3f8lkv8D1UWwSvFIqTkkdNyHQOrjMv/DXDd3Mnc+b4LNU3/QqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HX5LglaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HX5LglaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E50C4CEF7;
	Tue, 17 Feb 2026 20:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361531;
	bh=ZKJrD5wUOEFCRjFOBSLlb0F0QHLRUMsrGGX8AVlWe2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HX5LglaWlQ/rYJ9+6K+1nh2XKifm+g6J5OM7BSWYi17QVKF+sMZcdrHGPcTqNXqnG
	 3TBKRhQlnhar5r5n9FebBwGWB7FYw6Tfx4MKV/FotPIwHdAPqUIa9sDllscGSlkbOK
	 rkgtn+UIIJs7Xm+1mUe0MqPWBk/JA1yZ/gFdas10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 33/43] f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly
Date: Tue, 17 Feb 2026 21:32:13 +0100
Message-ID: <20260217200007.740395658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 0eda086de85e140f53c6123a4c00662f4e614ee4 upstream.

Sysfs entry name is gc_pin_file_thresh instead of gc_pin_file_threshold,
fix it.

Cc: stable@kernel.org
Fixes: c521a6ab4ad7 ("f2fs: fix to limit gc_pin_file_threshold")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -749,7 +749,7 @@ out:
 		return count;
 	}
 
-	if (!strcmp(a->attr.name, "gc_pin_file_threshold")) {
+	if (!strcmp(a->attr.name, "gc_pin_file_thresh")) {
 		if (t > MAX_GC_FAILED_PINNED_FILES)
 			return -EINVAL;
 		sbi->gc_pin_file_threshold = t;


