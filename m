Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061684;
	b=HWNgk9c20aW7qQ6rJQidGzc39ZE4KF02OHqe8br5rl+9KgJTb1wL8k5bxvXDW2jtW/cQ
	 hNJlcxb+cxpuIEKnDf9Cz5MadeYnBzozWFa3syOGeizcVfQbMZWNnRVu900wjMY153H75
	 zPn4OCA3rwTsbTdBNKd5BGvq/Avsornsqbg3kxuIOXhdCiKXsdNDcjuMfQyHDtf5x0Ooo
	 pTpEyxd3jPzqHThAdzogfEsdOIQqfu0LEqlkFa+FiL7ejUtqkfZVOw0hSs7Hvp5sZdXgI
	 zbNZ7fGomAgQJbAYgpfrEgFlUwZgrUPBkuZjouHyYs3fccAmxDrFSfgd7o0vU/JOZhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIkk8M0yn/VlDRUUVmiPnhCjhyOun6mvXQxwsJR7VRU=;
	b=n2SJb5x1XLjn/oUP/MkuzWlJ4NpVWw3M+w7Jwvva0mjvck+iVPsKdj2YnGpMT7CcbY32
	 Q9BrSSnptObuDAMetELNJb1onQhtI5YdP53HfmI+CqhtQSmbSM4JnRIAACOdqmpbirIAI
	 NanIA2jynOl19fOyPmdNARU3kK7ZtFTpgOewTI0dYNeSPFzVvmOgWW2UK0JP5mxz5oNQM
	 iy3ackKHAEDVqMF6bDYFQvzitmBhX+p1J+NP5ltEHXwv/03swszgeAjxotcrOLkprl/1g
	 b3xiaGbtZWd1K8zqeFZRfSpUdTngMykKeXwdUvjrlw0UefvUjxHPIYdt9uuW9srpwoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaQ4OH6k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74794606A32C;
	Sat,  7 Nov 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaQ4OH6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1190F1F008A1;
	Sat,  7 Nov 2026 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061684;
	bh=uIkk8M0yn/VlDRUUVmiPnhCjhyOun6mvXQxwsJR7VRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaQ4OH6k/uNVpmdefkGFU6os3fA0p4Mssz7Hg3YDRicRORQqRzcyNzRcrd2qbot3k
	 AOrTpJuM1dCHXx7mZyriyeHsXAK+ysEI0wqJ4abItJmXTR/eFsFj4/OBt43a+ZS7Jq
	 OPR8zI2TBpM3GuzOmh/CBxo4M5N+XUVkQShAQw4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0735/1536] xfs: clear set[ug]id mode bits when zapping attr fork
Date: Sat,  7 Nov 2026 08:45:51 -0500
Message-ID: <20261107135018.157648388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit eb20a959760c21e3547cd811d0d9b0b29df98959 upstream.

LOLLM observes that zapping a file's attr fork could result in ACLs
being removed from the file.  Because we have no idea what we're
deleting, we should clear the setuid and setgid bits in addition to the
access mode bits so that nobody can access the file.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1130,7 +1130,12 @@ xrep_dinode_zap_afork(
 	 */
 	if (dip->di_format != XFS_DINODE_FMT_BTREE)
 		dip->di_forkoff = 0;
-	dip->di_mode = cpu_to_be16(mode & ~0777);
+
+	/*
+	 * Zapping the attr fork could remove ACLs, so we clear suid/sgid and
+	 * all access mode bits.
+	 */
+	dip->di_mode = cpu_to_be16(mode & ~(S_ISUID | S_ISGID | 0777));
 	dip->di_uid = 0;
 	dip->di_gid = 0;
 }


