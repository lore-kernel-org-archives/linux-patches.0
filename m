Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0C8155CB3;
	Tue, 30 Jul 2024 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358065; cv=none; b=EUKj134yCWdUio/WmlSIghstSRPEABc12KUpadWmU317zLeAkJJikq7SoyJN8C0657XFqPqr+0olRePX8r2+3bpHeqBRfZi2la2UQ5MTtLHJjzPnFh5bQykEdQ71s0lsGcZ4FA5gahntLbZPo0zWWTb/nFSUbErJOhWyyPVTdU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358065; c=relaxed/simple;
	bh=phJEi1MDJ/Dsigt52c09WwZZOdsYgS+vJHy5FX/p6Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQkSydv2dF0crVFmNQ9wqfuPqMWb1afvYUJi0VC7a+4wjy5DuBCWpwVoI4cDsktax2cxZvM9F9FX0w0Y8E2B0lkX2nQ2xDO5T3U3+3IFXYpadVhcI7fQ07VB6fK4HeQ00tEKcoKYBf8rh5eGDOR/mLAYhhOYN3sCIudZR6lxN8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPmZ5/uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPmZ5/uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45436C32782;
	Tue, 30 Jul 2024 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358065;
	bh=phJEi1MDJ/Dsigt52c09WwZZOdsYgS+vJHy5FX/p6Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPmZ5/uCMToYr9V53IFqJUcTCczKuIHjYo7iHIlaw03CHYqv5wy4dSrVGRSdEcMz9
	 pjXtaZBLH2/3X/q+PCyWhYuhk6L8ccUaAXZK6+dvJGeS8UwbH0j+lmFJFYFR7S1IoQ
	 l5b4Vnw3eI5EgiTOdzHIIc7kWqhjFxYmRVR+pls0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/568] fs/ntfs3: Missed NI_FLAG_UPDATE_PARENT setting
Date: Tue, 30 Jul 2024 17:47:09 +0200
Message-ID: <20240730151652.462013899@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1c308ace1fd6de93bd0b7e1a5e8963ab27e2c016 ]

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 60a764ebaf570..f8cc49f14c7d3 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1738,6 +1738,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 	attr_b->nres.total_size = cpu_to_le64(total_size);
 	inode_set_bytes(&ni->vfs_inode, total_size);
+	ni->ni_flags |= NI_FLAG_UPDATE_PARENT;
 
 	mi_b->dirty = true;
 	mark_inode_dirty(&ni->vfs_inode);
-- 
2.43.0



