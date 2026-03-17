Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D122459DC;
	Tue, 17 Mar 2026 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768251; cv=none; b=RkBZ68W2xU1Hen27T+nQXGaYnidC3LhcXv7NqxmGmYyq92nlozPFSsGFB7hyOAVXX1CS41uE7RdEDMB43jfFSz32nS6tea+mJVxdN6bUE9z6o48IbKwv7o7YcxsBDyjTw1fEIWuiIzEchkKGU1aLnTV0UsgC43tdldHRCBxi/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768251; c=relaxed/simple;
	bh=GNtAyggnVDkDJxt074kTEwdLrQ7qVQ83RgXjFCjtSew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYHegRo+rnJk106D0FZrnvddAyvbVATjO7/801d7OGTlssUXhnj18ATxwUSjzuqAgURo2S5XazCJL/A6VRhZE/5lzoP/uyLyAJGch43qe4Sq+VoGFTO0CxaM+cZ7UPOU3u7wJgsetgyQsSY51ucZ8ns7mSzEiVd1xl+xMM2f8Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GVBLW02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GVBLW02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10913C4CEF7;
	Tue, 17 Mar 2026 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768251;
	bh=GNtAyggnVDkDJxt074kTEwdLrQ7qVQ83RgXjFCjtSew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GVBLW02mYkt0Up993t7QvKNNVRY/tDq/7C6+Z3+9tWdkcgrgIpNIvu0GlZLA8f/3
	 t60mcecztlGbm+pPL0zjnHQSVFeDlE/9bVDU/8qXGkce4k6xn0xKZMcEeZ7njoWb9c
	 D4E9ZLvUh8nImW/6whT+MvfTXluG5/DPUFXnIgy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Souptick Joarder <souptick.joarder@hpe.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 268/333] xfs: fix returned valued from xfs_defer_can_append
Date: Tue, 17 Mar 2026 17:34:57 +0100
Message-ID: <20260317163009.307191743@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


