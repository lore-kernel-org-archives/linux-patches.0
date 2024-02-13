Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3655FEFF;
	Tue, 13 Feb 2024 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845270; cv=none; b=LGcLs9oA2qEn9V++XKjv10lowb4J3XdpijeegrepNbLMqqGOJtP8E7r/ihIvrTQggaH6RPkh19WDpkXi4v4sPIt99vl7lc+eSTbqf9LBcudz//T/oos9Jz5AznH6gKBOJko5WIGBXs+U/i2U8b+ZYpW6lH0ueEtIWAJYoIju5Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845270; c=relaxed/simple;
	bh=GnZQgJDZZKYf4cMDN12j/zmF8F8j5zijFwxmFfz9dPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLnvcBi7mwY/ee01cCx96PxrXj1nYWHKBBUbjxDOqjwWAnKZhr2K/nWC0OWtcSoyl+n1lDFek3vmrpkTj6DTrcUgGzr0UkDj/UPaHseG+Dh/LLkJJ//1LUgV4rUo9jsPpBVp84xMEPpda5yl5QA9VNF7HGsf+ors7NmCHVhBh5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKkSYq1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKkSYq1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC95AC433C7;
	Tue, 13 Feb 2024 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845270;
	bh=GnZQgJDZZKYf4cMDN12j/zmF8F8j5zijFwxmFfz9dPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKkSYq1Jxzwwv80NGFRnkk4wHOceBp0wAcCEW+oFoWX8hv6WERy2c1Geo2csPcZEY
	 lL7eEnRfxBFXY5511lunSBK2ySNm8pf7OgKkmLnaq5mzsV55zjMaRIBYw9kUqG48bv
	 ZI7PuWMgcXCof58JJoZzw9b8kjC9LZb1EUEDyIBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/121] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Date: Tue, 13 Feb 2024 18:20:41 +0100
Message-ID: <20240213171853.926570658@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

commit a2e4388adfa44684c7c428a5a5980efe0d75e13e upstream.

Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
intention was to select DEBUG_FS, since the feature relies on debugfs to
export the related scrub statistics.

Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ed0bc8cbc703..567fb37274d3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select XFS_DEBUG
+	select DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.43.0



