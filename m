Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E25021882B;
	Mon,  2 Jun 2025 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876047; cv=none; b=XjTN04Km5PHggDIaOCzZ8EBtKGeEOeorXpAwm6U91FOVtbZfpUDX2uTV2QAJViwRwY1Yt9fr12KBL5tp4RSI97Gi/1w/hfdjLRekhQ8z/vv4cXIfgX6yAaRayDj9pN/S2BxAefgZkfY//7XbBXP5p9uqdl9u750kDNY08KpAgtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876047; c=relaxed/simple;
	bh=rg3MTiV7obZefuXwnJ0PpUOHcmnZofmwN3ipaqbll9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uqcj+GWBJ8KainqWSYX8m6rORygIS9UWRFPTR12+cpksHOBw7dKxyrbsM3n+1JMm1As3DQsQnswnrbfocq/ylsICir3wvEUj7BtRzh37PGvICm8PESclSOaqVzAYW4axywRuSZ84mYB2fuFoTlBfBLRco3sdS6p/H9ndvpwJcrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6DmpLaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6DmpLaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71520C4CEEB;
	Mon,  2 Jun 2025 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876046;
	bh=rg3MTiV7obZefuXwnJ0PpUOHcmnZofmwN3ipaqbll9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6DmpLaGWGWUw2FqD4c79IybXjQIqHVY0+m/uDNvpH8kJwCmSgDqlA8M+OzyRfhhm
	 3QEeP85OC86wJo+JIP6F4Oq9fO87TA9FFiO0GfnzrMvpN9dX+TAeAe91Qvn53yPB20
	 Z+dutWoCBXyA2fZbJGDEUTlXtaHgSan0Zbas70wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/207] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Mon,  2 Jun 2025 15:46:35 +0200
Message-ID: <20250602134259.683203012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa42add73ce9b9e3714723d385c254b75814e335 ]

If the client should see an ENETDOWN when trying to connect to the data
server, it might still be able to talk to the metadata server through
another NIC. If so, report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 4fed292de029f..a55eec241657d 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1258,6 +1258,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



