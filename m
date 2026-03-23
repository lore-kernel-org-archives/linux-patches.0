Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC7A1A6828;
	Mon, 23 Mar 2026 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275701; cv=none; b=R2vvGST8r1OG9PkDko6e1LYtIg9XEttGnbghPWptrQLN+CZsWtigahD+U1hldXlwoy0M3hlKPSplOc8HqKANJS1N13gaoeuPpfjt7icqD0/UhElen1djjKddS/f25kbwqtLWazGBLEsMADYaULWWHOfmJdvOG4S4tgGBI2LUAoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275701; c=relaxed/simple;
	bh=KSRDL2BX2A6zExgQbfASdtIeC+MxtnaRwTxf+QydpBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjOcRqSffbtg4J26OGFZGnpSXL35ORP/vUGNbSmM5oT6kOo5KvEUsgrz1sgBGf51lgbUga5pU97tjLBoiv1C6Xd8LKQmQrQnMBO1EoMO9ezBqflRAOS2fAr5hxI0a9TXMW00Cq8qZJ2Jyzk8ClTl1I6ht/Un0VBgMKSHQGapB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUTNlWq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUTNlWq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69F3C4CEF7;
	Mon, 23 Mar 2026 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275701;
	bh=KSRDL2BX2A6zExgQbfASdtIeC+MxtnaRwTxf+QydpBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUTNlWq9MwWs28C9fOmfwfVn2dPTJQl73YDwapIwyDyE+FwDdkR16KI8U6hSmRCzn
	 o5kTYNWHhlv5ck7ubCH4NuzPSLu1nNYH13uTQzVTVX/z33thi1YQOcs9ZCmA+5LSzZ
	 hg7gOXgvyJsKLE3wVj5AXJrnudlvhAJNqRvRh3Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Souptick Joarder <souptick.joarder@hpe.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 187/460] xfs: fix returned valued from xfs_defer_can_append
Date: Mon, 23 Mar 2026 14:43:03 +0100
Message-ID: <20260323134531.145631002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Carlos Maiolino <cem@kernel.org>

commit 54fcd2f95f8d216183965a370ec69e1aab14f5da upstream.

xfs_defer_can_append returns a bool, it shouldn't be returning
a NULL.

Found by code inspection.

Fixes: 4dffb2cbb483 ("xfs: allow pausing of pending deferred work items")
Cc: <stable@vger.kernel.org> # v6.8
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Souptick Joarder <souptick.joarder@hpe.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -809,7 +809,7 @@ xfs_defer_can_append(
 
 	/* Paused items cannot absorb more work */
 	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
-		return NULL;
+		return false;
 
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)


