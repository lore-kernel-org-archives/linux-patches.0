Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D736B672;
	Tue,  8 Jul 2025 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993264; cv=none; b=gQwprxtpUG+hUBZBBLCPtPjg878Y4kNapNH/Oza9FrPuI0mgG6CWTcNE8m0A9QqBi/rHYHo6Tc4fP/PijujTN+MGWSP8xR9h5gqvUPuRjTOkqU/zntI6TiQdl7w4lJyxaQb4Eu/Jw1WIIqstYiQxDtQ75CI5h//tpWazvk5hLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993264; c=relaxed/simple;
	bh=HMFoFSnRh4UKaZw8CuTzNzPuAfTn/lv7GD12DvqI8Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv8o1cDo6khmZlU4b2v8mKSyBZbWnn4NuycrBz2/I0P0DK3sSTfPaluck2HPm5ZdtYSnP5DqhphdikEPMXALpD4jXrd77uUrdq5kd6mG0o8m5BXRNIwBJA44bzH1JlgVv5ZLTmVecLg+Ecvb1dqZ2XVdC/l6PP3DfcyIawSf2NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB6q6kgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB6q6kgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3A1C4CEED;
	Tue,  8 Jul 2025 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993264;
	bh=HMFoFSnRh4UKaZw8CuTzNzPuAfTn/lv7GD12DvqI8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB6q6kgbla/ziNuQxOA9f36/wjsTKNDYfAfwP3Et3t7Hq2MVZDdhl7UAa74fgcO9S
	 mzMWWDwMzIuUdMGicI3tikhICR5WryEXVjAd3BJ89Cd3VaX2XAqLTeNR3dZ6uL9qfn
	 RJDj6Rmh1KAFaqnyL4bFZUgxxoMaKMSdtrNiul3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rostedt@goodmis.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.15 015/178] xfs: actually use the xfs_growfs_check_rtgeom tracepoint
Date: Tue,  8 Jul 2025 18:20:52 +0200
Message-ID: <20250708162236.945882988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit db44d088a5ab030b741a3adf2e7b181a8a6dcfbe upstream.

We created a new tracepoint but forgot to put it in.  Fix that.

Cc: rostedt@goodmis.org
Cc: stable@vger.kernel.org # v6.14
Fixes: 59a57acbce282d ("xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250612131021.114e6ec8@batman.local.home/
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6484c596ecea..736eb0924573 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1259,6 +1259,8 @@ xfs_growfs_check_rtgeom(
 
 	kfree(nmp);
 
+	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
+
 	if (min_logfsbs > mp->m_sb.sb_logblocks)
 		return -EINVAL;
 
-- 
2.50.0



