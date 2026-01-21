Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425FE315D48;
	Wed, 21 Jan 2026 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019657; cv=none; b=oYTU94MDdGSg8is06QpDbRiGnGtgOF0fcOD/6v1dea/jBtuZQlPTAH0Gv9kZT+cOPPnpxCAc9InbjapMVZBRQedHGLtB5MC78QYwyZBRD6l5RNZ7qmOY+BkWO9ul067TTUc2zaP3ykZEpJNF+ggE5Maj7J1Zi/9wWA8DxH0xX5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019657; c=relaxed/simple;
	bh=CW64UFivDkPTDultkNbw45YzVtHIa5/avhvLOxkTy4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex/X8zIj6u7E1XK2e62LCuUyFSmzYJM1TYnhfoXajr0+h2eRICtHTMulGVE7wmuoyLA+HeZ3l4/AK2IYbty8j/HWD/qCIPYo2T3uTs6pHqjJebCWo7DlkbWFqsCpHkIuwN4Km+lRIzTpsuhZeafc3A51ohouoi+WWdiqnfmpkoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F93rlHcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F93rlHcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ABAC4CEF1;
	Wed, 21 Jan 2026 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019657;
	bh=CW64UFivDkPTDultkNbw45YzVtHIa5/avhvLOxkTy4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F93rlHcDR2tuAUrEU/CDdUA8haP6f/XztUG6FdW1n1s/9yggK+0tDDZ1EcwOvAfwY
	 OwczPXa3u6iXVIISTvJRTTiQd06mqMZf+C1txAdgvhkn9LumyJLmsdZhqjxLgwt8yi
	 MPwaccsSk14foSx1YhramBk9GC4DITHWgQ0DJdRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 070/139] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Wed, 21 Jan 2026 19:15:18 +0100
Message-ID: <20260121181413.974179703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

commit 6b2d155366581705a848833a9b626bfea41d5a8d upstream.

xfs_rtcopy_summary() should return the appropriate error code
instead of always returning 0. The caller of this function which is
xfs_growfs_rt_bmblock() is already handling the error.

Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # v6.7
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -118,7 +118,7 @@ xfs_rtcopy_summary(
 	error = 0;
 out:
 	xfs_rtbuf_cache_relse(oargs);
-	return 0;
+	return error;
 }
 /*
  * Mark an extent specified by start and len allocated.


