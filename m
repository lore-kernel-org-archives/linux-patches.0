Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F83F65E9;
	Tue, 17 Mar 2026 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766778; cv=none; b=PAnXNDc0RJW8kgk6++vqMcAOpldLmXlI7xqr1GkapYJF5ToO9ZXfjjFY+WlT8YZVe7brt9BurH7eFT9XzCWhItO21I4A8dBspiGAugJ/9OyrHeNJCIEWFkbjlSUNSd2edIh0Tg67b778qLXSAipL++oJyp/jqKqJ1Mqke0IkgkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766778; c=relaxed/simple;
	bh=L8sKnOUp5cVa+F20aSfF+a3eQEcUVwgRsOFo5xNDkVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+iWg6IVFB78/u3d91nwWltqJrrKrJHUIY50hYTme+4K8yg1yUJwpbegN624Xt00Y4yiE0w8c8LrU46ANGPJXoYlT5XQjh+8MgETaf96KSoghaq+vTFAjrTboBMbLDj5ki52L5xHOOgzBrOvgz77vHNaBUo+gYb4BySQ6zormy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8ck1wMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8ck1wMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC61AC4CEF7;
	Tue, 17 Mar 2026 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766778;
	bh=L8sKnOUp5cVa+F20aSfF+a3eQEcUVwgRsOFo5xNDkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8ck1wMrMrASO3tKR4ymWJi3sRFqoVelhP+AXWnGaaztq9on+hiEV4XzeagxVEkd0
	 5rIXYWkhqHycyXgg3PcJq+SNPp6teoY9Qo/cDMlGuyqiwtPIPbjL2qY2jbfmUtHwT+
	 NlRM+GbdY4aJ2IYtp4EUqLAY+uKEBiJ3kXKajMQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Souptick Joarder <souptick.joarder@hpe.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 320/378] xfs: fix returned valued from xfs_defer_can_append
Date: Tue, 17 Mar 2026 17:34:37 +0100
Message-ID: <20260317163018.763252117@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


