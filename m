Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C7C3419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cTowki7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A22C433C8;
	Mon,  9 Oct 2023 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859515;
	bh=FgnKFMADbxsUyx4Wf3So8CP24dusaJrA63EVJ0obm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cTowki7Y88H8X41Zewblyiv9Vf8X9GOSqQVCgeHqo8mqbZTCH3z06vcm74SvBAc8
	 09j2YZnS8XX59BbQ0v1ctSUvu6Gu/cyLWYz2iT7sD6vYs79K7skrnkb3H0oAgPHzZ7
	 G40cblKCTYYm2EIakVvPW8xX2l3Aiup4WETi3nLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Goel <vishal.goel@samsung.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Munehisa Kamata <kamatam@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/91] Smack:- Use overlay inode label in smack_inode_copy_up()
Date: Mon,  9 Oct 2023 15:06:18 +0200
Message-ID: <20231009130113.121946269@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Goel <vishal.goel@samsung.com>

commit 387ef964460f14fe1c1ea29aba70e22731ea7cf7 upstream.

Currently in "smack_inode_copy_up()" function, process label is
changed with the label on parent inode. Due to which,
process is assigned directory label and whatever file or directory
created by the process are also getting directory label
which is wrong label.

Changes has been done to use label of overlay inode instead
of parent inode.

Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
[4.19: adjusted for the lack of helper functions]
Fixes: d6d80cb57be4 ("Smack: Base support for overlayfs")
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 4f65d953fe318..a09a9c6bbdf63 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4612,7 +4612,7 @@ static int smack_inode_copy_up(struct dentry *dentry, struct cred **new)
 	/*
 	 * Get label from overlay inode and set it in create_sid
 	 */
-	isp = d_inode(dentry->d_parent)->i_security;
+	isp = d_inode(dentry)->i_security;
 	skp = isp->smk_inode;
 	tsp->smk_task = skp;
 	*new = new_creds;
-- 
2.40.1



