Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB232C21E6;
	Fri,  9 Jan 2026 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961754; cv=none; b=ewaXwSDIydU7wXymkQXaQoRXAS7hvOeitL13h5/zBVRv0uwK76W80q4/Vw1De4w58QjPZaHxOs6bCEi2UMavvpuNnSXF5oBsrUFEQjc1CPd45AR4v3/Ki3/eYkBgVF9abO5yoR8sC47xoo6uqBceIJZl8vHm42/scxUCjfjU4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961754; c=relaxed/simple;
	bh=QudukGPPp24z2uzWNlHZeaBlU/x4go1EJijIuR503dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPcfLXXWjAwhG503gjbqJOFyN0/QAHmletyGTf+vtFR3glxGnAnh7VEg/iC39bQFu+NYUuNl96RkVMnmaFDFrvucMIRbS+piWbc2xuMI3zMZ0nRcGOGuH9hFBMTuYLXFs37ZGi7KkTgAEDOKbHJMvYPgPZlDV+SVfx8SPNp134s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6+Eacad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6+Eacad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DBC4CEF1;
	Fri,  9 Jan 2026 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961754;
	bh=QudukGPPp24z2uzWNlHZeaBlU/x4go1EJijIuR503dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6+EacadkcW/wYMyeYsE0JUhUdG9l3YvW14cGR+/QRVbU5xopO7PO/nkgGIP1kFWa
	 SqVcJ1CGtwi/lOv0shz6FkVse+hKQg9RQFsJhd1H3nKzTMrEcAevzDi32ogPmARTWx
	 W/4cQuNh9wcwjCiIbsGJ5t9oLrq0TEgljM2/0XLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/634] fs/ntfs3: out1 also needs to put mi
Date: Fri,  9 Jan 2026 12:36:42 +0100
Message-ID: <20260109112122.110578846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fb572688f919f..f1f5b84e2ef17 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1067,9 +1067,9 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 out2:
 	ni_remove_mi(ni, mi);
-	mi_put(mi);
 
 out1:
+	mi_put(mi);
 	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
-- 
2.51.0



