Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D51737F726;
	Wed, 21 Jan 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020376; cv=none; b=KlZmvtD72bnl0ihhkvGO3a83agcLuTeRIJBxnobpeplHImKFcaYF3iX53MbYnoeri8FSLe4HuLECq3GisY0jR/ohkqdFvy0uiiuUyFK7SU0JOezkxJ1G87xrIaOfcGo1pB5eNcdLP62KISe5kyevw1rf11f79bZjzyxneKJfKMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020376; c=relaxed/simple;
	bh=mcRBUsujINfM19tk947T3JYXz6XJsSyDAuIfrHNvOf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO3YFi84spNjgtnkjvGKjgTBdeVIjOMZPG4KPCiRe8v1jY+r69W736JtcbQPy44T32DMlMmZttyfpUxRyuOmh4225nDhv4RvxLjoNbCIUIU+G2xnHp/7BFQ3y4PGOk8jYCwhtiyze+oEd1zN+T46O5b/LBc2CEGi6GA0BPgKr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtkjpZzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtkjpZzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B412C4CEF1;
	Wed, 21 Jan 2026 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020376;
	bh=mcRBUsujINfM19tk947T3JYXz6XJsSyDAuIfrHNvOf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtkjpZzosplGYvxm/oPMrTeCTl7dLTEF+vaMxFAidizc3Fbhp7ilF8lOFC2XuJApv
	 Re19DPQ+PufWjmohYD3BSd71QBLXPbbw7LPWG8t7dYY+DhH95pl8dMhHBsN1l1mkRw
	 PjFVVifU89FqZV6bZ5GxBmnqtEIbwqupnbnj9Yb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 106/198] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Wed, 21 Jan 2026 19:15:34 +0100
Message-ID: <20260121181422.367507331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
@@ -126,7 +126,7 @@ xfs_rtcopy_summary(
 	error = 0;
 out:
 	xfs_rtbuf_cache_relse(oargs);
-	return 0;
+	return error;
 }
 /*
  * Mark an extent specified by start and len allocated.


