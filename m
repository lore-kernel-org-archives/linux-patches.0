Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2413BC0C;
	Mon, 23 Dec 2024 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970218; cv=none; b=PFOwUi2AriF6L6pcOpCpPOfZS/x/JZXzYADP/Bxii9Wk7eGAsoG5BhZ58cFfT+npjT17xyJ2Qdpv0vg8Kt0DibcSaU6RRxd8JtPeo9l78dVU1ofs1s/4tiUnGdmDDM/WGaOlNmAiWOIvDXtDUskq4OnMBq8wA9BQQNMliwPNH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970218; c=relaxed/simple;
	bh=TZtkIpYN53PQ/BqvOUwuaU+0MPPcsotEgJ7Akpv8sYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+2MOr+DwKO0bB0OiQwg9+IERafQilXpHQEoOnn6DBT8A3uO3bYJVVueqIOX7VIUs7M+b96N+9re7I2Brq/PJlXZuQaZOxBPtEkokx/NQfuj1O3z60qTuy1rCc8rDD0TD3l1oc2ypwcXgU49RkCznlNxzBGW+MA0u8bLg7XPvKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WC/tvvKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC/tvvKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B1C4CED6;
	Mon, 23 Dec 2024 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970217;
	bh=TZtkIpYN53PQ/BqvOUwuaU+0MPPcsotEgJ7Akpv8sYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC/tvvKyZ+6SadF2qcCQRQSBKJsHQWqzI7OHCPFppWxWVpSh7bFcxEppWVheacG46
	 O5DKyPPkJ1oPZAlMa/eeROh2fWZSNr305eKGJr/F0arKLBs5sd52+9kSXNe2yX5ld2
	 0UN74hicMGD3pGRZ0V2dBIb1kRGqkr/mLWPAtMNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/116] xfs: fix the contact address for the sysfs ABI documentation
Date: Mon, 23 Dec 2024 16:58:09 +0100
Message-ID: <20241223155400.299734618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 9ff4490e2ab364ec433f15668ef3f5edfb53feca upstream.

oss.sgi.com is long dead, refer to the current linux-xfs list instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index f704925f6fe9..82d8e2f79834 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -1,7 +1,7 @@
 What:		/sys/fs/xfs/<disk>/log/log_head_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current head of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -10,7 +10,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current tail of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -18,7 +18,7 @@ Description:
 What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log reserve grant head. It
 		represents the total log reservation of all currently
@@ -29,7 +29,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/write_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
-- 
2.39.5



