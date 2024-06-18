Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7726C156C6D;
	Tue, 18 Jun 2024 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715647; cv=none; b=CSpl5DGVIOZIcuWnLZ8EB6/F9G6Am8TorCapBDIcoreCzl0luN6CohfS7KpL85Leb6gvrO+Aldvw9YT18wTAPDs4wTxRtIWdJVB7HDUnapjYUa3FUE+mPjXfGzKLNgnT9/vkckJMrT2yapf93WIgEWWrkz+mNV+FhjIRubrR3/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715647; c=relaxed/simple;
	bh=/Ik2TozViE9njApuO7SRwucjyA534RMi1b9N/LEQ8Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpsMiLDzoi+vKX5S0hkag5I2PZy86QaapFmrhla6OFj8ZQzoTbQw6vHsmsk4IKXXp6xh/gQ1MSESfnneob/KF5IQk2fDts5BQju7fQyV0pMPiQ/AbiPcBtO0SkZoUclK+0dKGToeo4wM636eQncRy414tvsii4eYso0uFNQuqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKmfA1d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKmfA1d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FD0C3277B;
	Tue, 18 Jun 2024 13:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715647;
	bh=/Ik2TozViE9njApuO7SRwucjyA534RMi1b9N/LEQ8Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKmfA1d5mK6uJuUw4IuBsg6pZsLUNuqOZjYD4Xei1pnk2jquumYLcOtMZqRJy16p6
	 tf3igLh1vFndqNxvdmItxQkqja0dZ6bdnAQy2lHbDf+vzFoLn17v7dhtvdkSkutJPs
	 xkl3BZZF6PqIxhxSdu3Fx3xi+ZjZGrunMrWx67DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/770] lockd: update nlm_lookup_file reexport comment
Date: Tue, 18 Jun 2024 14:33:21 +0200
Message-ID: <20240618123420.694539084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit b661601a9fdf1af8516e1100de8bba84bd41cca4 ]

Update comment to reflect that we *do* allow reexport, whether it's a
good idea or not....

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index e02951f8a28f5..13e6ffc219ec9 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -111,8 +111,9 @@ nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
 	INIT_HLIST_NODE(&file->f_list);
 	INIT_LIST_HEAD(&file->f_blocks);
 
-	/* Open the file. Note that this must not sleep for too long, else
-	 * we would lock up lockd:-) So no NFS re-exports, folks.
+	/*
+	 * Open the file. Note that if we're reexporting, for example,
+	 * this could block the lockd thread for a while.
 	 *
 	 * We have to make sure we have the right credential to open
 	 * the file.
-- 
2.43.0



