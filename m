Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E1101DE;
	Thu,  3 Jul 2025 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555745; cv=none; b=Ww77XtuIok+JVDd/Pu1YRFK8tXD1PqCwXf0yfaAMtO9VJwsxbgwGBQgNlKNxb07lKCVwoE89z5EDH3H4fCHr/Yf7dHeldQVI25xKCaiN4KqxkhKjKnXUL6JWhTpv2heiyzQ4J8Qvby13vSJB3tM3cK4TyLzgsAbbiv8+yvAaZUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555745; c=relaxed/simple;
	bh=fEq8uHDq933BvqMqmWkcXrC1untgundPo8vh4CfgZeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8TNYscE9DGrg7AJtgjA2PVYqvzxoHs8y9iucitJ4HlPh/TrfO4T4b2CuN64QtZ7wLQ4tM27E+GXl0nLIIaoMaSUXKU+Y/N5ExZgT1v+Q/9mx+SZ4gNNaXeSM2A9z7SiIs8Nr3k/9SwJ54/rX7jGQeWXTqEO61EC+A0a9yCUG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3j7P93V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3j7P93V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DEDC4CEE3;
	Thu,  3 Jul 2025 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555745;
	bh=fEq8uHDq933BvqMqmWkcXrC1untgundPo8vh4CfgZeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3j7P93VLrKwgDINelNTcmn65gCARN+41mgkNgVmzBh+A8DZZpK87/o3u+75jGtxe
	 RaxDXK3jlkefrNXPEcOQkbX/zf7J+yiNAesvquyECN9XRZt2BV1/Bf54B0ULKyeHyX
	 g5Xe3Hzt1R18zSwBfNmJrvBoVar/r0xGUdjYtWR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.6 109/139] drm/ast: Fix comment on modeset lock
Date: Thu,  3 Jul 2025 16:42:52 +0200
Message-ID: <20250703143945.438640264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 7cce65f3789e04c0f7668a66563e680d81d54493 upstream.

The ast driver protects the commit tail against concurrent reads
of the display modes by acquiring a lock. The comment is misleading
as the lock is not released in atomic_flush, but at the end of the
commit-tail helper. Rewrite the comment.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 1fe182154984 ("drm/ast: Acquire I/O-register lock in atomic_commit_tail function")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.2+
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250324094520.192974-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_mode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1868,9 +1868,9 @@ static void ast_mode_config_helper_atomi
 
 	/*
 	 * Concurrent operations could possibly trigger a call to
-	 * drm_connector_helper_funcs.get_modes by trying to read the
-	 * display modes. Protect access to I/O registers by acquiring
-	 * the I/O-register lock. Released in atomic_flush().
+	 * drm_connector_helper_funcs.get_modes by reading the display
+	 * modes. Protect access to registers by acquiring the modeset
+	 * lock.
 	 */
 	mutex_lock(&ast->ioregs_lock);
 	drm_atomic_helper_commit_tail_rpm(state);


