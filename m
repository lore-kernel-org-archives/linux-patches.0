Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37FB3446AF;
	Tue, 16 Dec 2025 11:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884493; cv=none; b=ZIlhQG5uTsYqYMHzkW4rdseRJMQgSpAyYR623q7MS7AHr9nqcRvVkYRVP+kIGIKL1HU0X5KQTSTJ1u1fgRovEGfNBH5oX7dAS+5pMPpeFkhiFx1lj6kmJ7hEBdrmzzamt28laEHJaRM2dXTLbVFcF7V5JvFK7liZ7b+YPhUa62I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884493; c=relaxed/simple;
	bh=NByymMPEts248j57jcHcdNoemSukincLAIDnF5DWPo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFRb4Lx55ZfThRqYFZwRN2JZrGVycpO/rwqQnepOHLhhU4CeRKsK41JSqEOay3E43bQshzZBB1424jjQKui16t7K2d3UGy7gj+nbZgo9IwEEPoDuJQ9YgT1feXXjWfPNpci9QxNQyQkYVE1nexbzeZs7JKHxypm5c6FKgzmaMQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3sg3GN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3sg3GN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DEEC4CEF1;
	Tue, 16 Dec 2025 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884492;
	bh=NByymMPEts248j57jcHcdNoemSukincLAIDnF5DWPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3sg3GN1Wu++9gyQrepELXLEqGZRcO9zXlhu9RK/zxH5ifDmYNC1VUoAm7BLEJso7
	 BU6Z+sFxG746SUwh02urAQWfzO7Cd7eWcOQaHeCMGeuzzDM/yFoVEEw7n/AHgJdoBa
	 MqDJz58FbvubADdVhkHUhhZDbDtqGGe0E/xvnrZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/354] fs/ntfs3: out1 also needs to put mi
Date: Tue, 16 Dec 2025 12:12:24 +0100
Message-ID: <20251216111327.325042535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 4d78d1173a653acdaf7500a32b8dc530ca4ad075 ]

After ntfs_look_free_mft() executes successfully, all subsequent code
that fails to execute must put mi.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index ed38014d17505..ec2be861db33d 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1069,9 +1069,9 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 out2:
 	ni_remove_mi(ni, mi);
-	mi_put(mi);
 
 out1:
+	mi_put(mi);
 	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
-- 
2.51.0



