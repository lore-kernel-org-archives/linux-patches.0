Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E4018E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWzEMcTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3078DC433C7;
	Mon,  9 Oct 2023 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858394;
	bh=xgpOjScup7vB1+tm2S1GN5HBUFws7WjRlbNMyOKOhqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWzEMcTTF9/466RzVYDM1cLadY73Z6GLe1oZ+WsAbj4OdQwkAD5I+/k1K2RBwoSNi
	 OOFXgwm95evdkfGyp0J0sdpmTNIeHzkt1gVA9z3dytOtbqdrrueW+u18gyjsRvKLJD
	 5ijB6n8PFnMAJNQL5MPssgEqarvLei0PMFQgsi8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Goel <vishal.goel@samsung.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/131] Smack:- Use overlay inode label in smack_inode_copy_up()
Date: Mon,  9 Oct 2023 15:01:52 +0200
Message-ID: <20231009130118.513723050@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Goel <vishal.goel@samsung.com>

[ Upstream commit 387ef964460f14fe1c1ea29aba70e22731ea7cf7 ]

Currently in "smack_inode_copy_up()" function, process label is
changed with the label on parent inode. Due to which,
process is assigned directory label and whatever file or directory
created by the process are also getting directory label
which is wrong label.

Changes has been done to use label of overlay inode instead
of parent inode.

Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index bff67bedd838f..9e48c8b36b678 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4544,7 +4544,7 @@ static int smack_inode_copy_up(struct dentry *dentry, struct cred **new)
 	/*
 	 * Get label from overlay inode and set it in create_sid
 	 */
-	isp = smack_inode(d_inode(dentry->d_parent));
+	isp = smack_inode(d_inode(dentry));
 	skp = isp->smk_inode;
 	tsp->smk_task = skp;
 	*new = new_creds;
-- 
2.40.1



