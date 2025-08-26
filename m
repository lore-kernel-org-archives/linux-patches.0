Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2E92BD00C;
	Tue, 26 Aug 2025 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207545; cv=none; b=e6Xt5856l0ErfPSgDMGao+uGfIw7hJQlKScgouIC3OwYFw7Yo2nQ0+uv9EP8hJOpPdmUYK4Av7gR+arViKujrluj/O+BHueDXn1WA/eMVzoV7hJvlbyRE4BYTedwZUrVpp0t+LAwFHatSMVDRfzuKIrgscmkZzn3QmJuZna2xDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207545; c=relaxed/simple;
	bh=yiEir1uWVmCQh9+A0tC3KDsFy/LmLRCeVSzZaGfGUMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU3Fsghe6JA4d0i0251Nc/uhP7RLNXynyyRJJD63/YPV1Eailv5eXxUnhb/ngh6dgF+86cmtkeH7E0STaYeeb6kd25HXZ0T8YIqutO5wYelXiQXEnMMNxkwm3080Sdi+GDy4+KzrksZsONUa0CCoMSmjcZHH7VUZvB/F7BxBh/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enTTXqQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enTTXqQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B18AC4CEF1;
	Tue, 26 Aug 2025 11:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207545;
	bh=yiEir1uWVmCQh9+A0tC3KDsFy/LmLRCeVSzZaGfGUMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enTTXqQ1E7nmn0NuERmDubKEatqDNS0QDqCeiYXgJ3USe5pAPuCuQdmyJboI9mynp
	 /1LHEMmzBum0JXKSwZGNaJdQMA1pZsrxV7FkGUarYPsRJPsKj+hDOko8onjhtaEJ8o
	 MkqfymWnS9HSAEMGYb0R4pjTMzzqWrUOg7XbKSp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 224/457] xfs: improve the comments in xfs_select_zone_nowait
Date: Tue, 26 Aug 2025 13:08:28 +0200
Message-ID: <20250826110942.903608912@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 60e02f956d77af31b85ed4e73abf85d5f12d0a98 ]

The top of the function comment is outdated, and the parts still correct
duplicate information in comment inside the function.  Remove the top of
the function comment and instead improve a comment inside the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: d2845519b072 ("xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_zone_alloc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -654,13 +654,6 @@ static inline bool xfs_zoned_pack_tight(
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
 
-/*
- * Pick a new zone for writes.
- *
- * If we aren't using up our budget of open zones just open a new one from the
- * freelist.  Else try to find one that matches the expected data lifetime.  If
- * we don't find one that is good pick any zone that is available.
- */
 static struct xfs_open_zone *
 xfs_select_zone_nowait(
 	struct xfs_mount	*mp,
@@ -688,7 +681,8 @@ xfs_select_zone_nowait(
 		goto out_unlock;
 
 	/*
-	 * See if we can open a new zone and use that.
+	 * See if we can open a new zone and use that so that data for different
+	 * files is mixed as little as possible.
 	 */
 	oz = xfs_try_open_zone(mp, write_hint);
 	if (oz)


