Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52FE170A13;
	Mon, 24 Feb 2025 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407854; cv=none; b=RQB5e4y1e6sGAyKJfh5ERrcXrU0cpaJj/qwIR509Z7PolhukQI9KVz9T3bxaF/gn6vBx9CdrzHIEo/dzS6+6jKd0iL8akvNMr9dbbR/7DlTiMcXIL/hjGq1xWw34SGThP/bpRagqGlMUOn00ucoAXpvP4Q1cilyForwmy34IpW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407854; c=relaxed/simple;
	bh=zBFXPSoC/B860rO6OIsyYYUwo32Lp7Gu/8uT8aIU1b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV+4ucFiWJnLSo65LKGz/h2D9aNxtY1QkivbL3+XEKbfBKWwIOzvBHGutsGbx18GhsSEFBEcBigbTb4X8fVLV86SVATPZrmiHtPtODn7ABQTHSPvli57/wgugR4bN2Qnni3stCN5iD9c7z2inaJoS4jgi3tVmPokAUaGMgc4Tz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8bWqijf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8bWqijf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6412C4CED6;
	Mon, 24 Feb 2025 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407854;
	bh=zBFXPSoC/B860rO6OIsyYYUwo32Lp7Gu/8uT8aIU1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8bWqijfMtEUyliWriN3GhEwzvgW2RBQBn7CVZsV4bk0QBm5Ff46bylSMrkN9m4My
	 yKV694sLncsTQB2hFmlNJSnm3cVZZpwwbyYorysDxYCOi1aODwrskfCTTzwRu1IDHK
	 cohadIV9bFib/kyUmfLfNAP9Kzj8UaQIhePrA4sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Andrew Kreimer <algonell@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 005/140] xfs: fix a typo
Date: Mon, 24 Feb 2025 15:33:24 +0100
Message-ID: <20250224142603.218077947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Andrew Kreimer <algonell@gmail.com>

commit 77bfe1b11ea0c0c4b0ce19b742cd1aa82f60e45d upstream.

Fix a typo in comments.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1820,7 +1820,7 @@ xlog_find_item_ops(
  *	   from the transaction. However, we can't do that until after we've
  *	   replayed all the other items because they may be dependent on the
  *	   cancelled buffer and replaying the cancelled buffer can remove it
- *	   form the cancelled buffer table. Hence they have tobe done last.
+ *	   form the cancelled buffer table. Hence they have to be done last.
  *
  *	3. Inode allocation buffers must be replayed before inode items that
  *	   read the buffer and replay changes into it. For filesystems using the


