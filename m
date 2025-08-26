Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A3529D26A;
	Tue, 26 Aug 2025 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207551; cv=none; b=BHbOySemCCwP7V8hjTxYO3gfy1qEtjSSO6CI5BVjYiLIBbOiXf5n7lIoNx/atv6Iss/li5dpIneWJ+ci66ovxg1BfxdlDl+nMawabYWGNJL1YsAODqt9rM2Zu3TVP2c4JCC+lXyOtPf4fj8uBf1xOKGtzm9QJBGkiVoNIjonv0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207551; c=relaxed/simple;
	bh=aumXUG9buTLTmTHZXXsDMeubGWn77lJiN6Nds7lTb8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/VLE6TzQCRlF08gbfS0s8WXQ7fkGJ7fIlBmANuoWRFO1SoRncfUUcPoWSVIRpjz8BKrQpqWb7/AQsM+GU35K5kaUo7vbltQzT1EjDGpLnGQxzSf50e/iy+5aPw2mtd+4ve52CQyFLFeUwJ5V460hgeytMLYbqVokaQPDckP7SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlNhkSzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlNhkSzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A78CC4CEF1;
	Tue, 26 Aug 2025 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207550;
	bh=aumXUG9buTLTmTHZXXsDMeubGWn77lJiN6Nds7lTb8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlNhkSzVbFo+orylDPk5JCNGrPVFPDET6426nIdJqT5zlq+AbQekecv53lOAsinCp
	 7BsRBTi5DGIfMHuegZJ3FZKwVHsFeNm7YM5MT6ZgPvjik6tSsVvYMZzOXxSkllGOsr
	 qul6ezxNH3Hv/YUBXCsklFL1lYdcUxXXZJoBHMHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Huang <mmpgouride@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 226/457] xfs: Remove unused label in xfs_dax_notify_dev_failure
Date: Tue, 26 Aug 2025 13:08:30 +0200
Message-ID: <20250826110942.955211569@linuxfoundation.org>
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

From: Alan Huang <mmpgouride@gmail.com>

[ Upstream commit 8c10b04f9fc1760cb79068073686d8866e59d40f ]

Fixes: e967dc40d501 ("xfs: return the allocated transaction from xfs_trans_alloc_empty")
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -350,7 +350,6 @@ xfs_dax_notify_dev_failure(
 			error = -EFSCORRUPTED;
 	}
 
-out:
 	/* Thaw the fs if it has been frozen before. */
 	if (mf_flags & MF_MEM_PRE_REMOVE)
 		xfs_dax_notify_failure_thaw(mp, kernel_frozen);


