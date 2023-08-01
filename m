Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14F41F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BABC433C9;
	Tue,  1 Aug 2023 09:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883032;
	bh=LQxBeP3jiXLti73sf7JueMSehpo0kMd32jrw08jXhxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgkeLQY8LcYkGWRVHGAWb+7iXg6smepikVOftR3J+ff/qD1MlCDynmoaJx/vWHaBc
	 yZWtS6DZLfUHe9//DPqJhbw1aQc+nkX9XQB5lJN/WnbCFwShELw9sESkHUE7L67O9W
	 H35voz7QKdUXH+x1JXYBRQaYfGjW3xsvSz5GmBwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.4 063/239] i40e: Fix an NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Tue,  1 Aug 2023 11:18:47 +0200
Message-ID: <20230801091927.932957572@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Ming <machel@vivo.com>

[ Upstream commit 043b1f185fb0f3939b7427f634787706f45411c4 ]

The debugfs_create_dir() function returns error pointers.
It never returns NULL. Most incorrect error checks were fixed,
but the one in i40e_dbg_init() was forgotten.

Fix the remaining error check.

Fixes: 02e9c290814c ("i40e: debugfs interface")
Signed-off-by: Wang Ming <machel@vivo.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 9954493cd4489..62497f5565c59 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -1839,7 +1839,7 @@ void i40e_dbg_pf_exit(struct i40e_pf *pf)
 void i40e_dbg_init(void)
 {
 	i40e_dbg_root = debugfs_create_dir(i40e_driver_name, NULL);
-	if (!i40e_dbg_root)
+	if (IS_ERR(i40e_dbg_root))
 		pr_info("init of debugfs failed\n");
 }
 
-- 
2.39.2



