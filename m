Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22643D4E2;
	Thu, 30 Jul 2026 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421166; cv=none; b=O+m/15jNUNSnKjZNDH1BH+A2F8OJU0EfYwNqaIM3NyoliMTAKTvt73m3i2JhcA/N98i+2FGASbpu8fiEF/w7ZZMKPekC+1gBUcnq/4/qGkkFGMYPvXUvIviGH+JTUHU8SNtmwX6eq77TF2ibmC3bSYgDxMmkp+QKM1RFpq0Vqg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421166; c=relaxed/simple;
	bh=kP2FR80B8EToHkgHq8fzz7oYKWrAvsHornPr6FVb4u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMXxApszGR0OxsLTZ2YvQFeFrMeyao/Fy9C61TRwpAUmmSMWKeprANCsIhzDhiig7WNUQAaqvueEcDP2juw5rtHT1TDFHRTvEBFz78oSnVk355wyTDhzWNXZxJzK01rAYntUgo0Iw0NWeLkDKQxCwy+m3D2jhFAsE0rzJ3Buvl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl+MvQMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl+MvQMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BF51F00A3D;
	Thu, 30 Jul 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421164;
	bh=80z8EThO28BHHAY4a6O/kszWY7WFJzTcVriVUBIsyl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cl+MvQMqhCA2V9DVzfVp9V1vdFuPIhm4rZnlWXhXNpUkmvf1/QnfRSfLDRWhphId+
	 a8gzd55II26RrUQtWwrihsERrwhS6wDOtd5ZfvJaMIc+eFenbVrfYO989ZIJhT0Vdj
	 qBiuhWIzc3x0U5HACCCCRkMLtUtGUTc7qlzpgeA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doehyun Baek <doehyunbaek@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 013/744] Docs/admin-guide/cgroup-v2: fix memory.stat doc details
Date: Thu, 30 Jul 2026 16:04:46 +0200
Message-ID: <20260730141444.565144228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doehyun Baek <doehyunbaek@gmail.com>

[ Upstream commit 46d65096ce8d278abf4528e254878c14ddd0b459 ]

Fix minor cgroup v2 memory.stat documentation issues.  Correct the
vmalloc per-node marker now that vmalloc uses the native NR_VMALLOC node
stat, and document zswap_incomp as a byte-valued memory amount instead
of as a page counter.

Fixes: c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC vmstat counter")
Fixes: 5ad41a38c364 ("mm: zswap: add per-memcg stat for incompressible pages")
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed995b..5cc33d87c3dffe 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1570,7 +1570,7 @@ The following nested keys are defined.
 	  sock (npn)
 		Amount of memory used in network transmission buffers
 
-	  vmalloc (npn)
+	  vmalloc
 		Amount of memory used for vmap backed memory.
 
 	  shmem
@@ -1735,7 +1735,7 @@ The following nested keys are defined.
 		Number of pages written from zswap to swap.
 
 	  zswap_incomp
-		Number of incompressible pages currently stored in zswap
+		Amount of memory used by incompressible pages currently stored in zswap
 		without compression. These pages could not be compressed to
 		a size smaller than PAGE_SIZE, so they are stored as-is.
 
-- 
2.53.0



