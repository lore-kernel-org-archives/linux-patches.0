Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A69A54BFB;
	Thu, 30 Nov 2023 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB0ImYrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA133C433C8;
	Thu, 30 Nov 2023 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361754;
	bh=sMmYvQuMCDpHcreqb66nhqJQC75JkbYq3EJry5jCoik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XB0ImYrD1NifhGseE5miWEG+8ZFUOkDmbSPUzvyJpJqPOklgY4H+YAH1jaTil30cT
	 vPDwQ9xc+bSTPV/AOWEV5aLnMJugC4b63bAgLnTQeRsJNiLKV0UGTewr0PAHRyMf4O
	 /US99DIN1Rhq1PujxGRvXPKUD6tBWQBD76dta+Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/82] cifs: print last update time for interface list
Date: Thu, 30 Nov 2023 16:22:05 +0000
Message-ID: <20231130162137.040637369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 05844bd661d9fd478df1175b6639bf2d9398becb ]

We store the last updated time for interface list while
parsing the interfaces. This change is to just print that
info in DebugData.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: fa1d0508bdd4 ("cifs: account for primary channel in the interface list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index ed396b186c5a4..8233fb2f0ca63 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -457,8 +457,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 			spin_lock(&ses->iface_lock);
 			if (ses->iface_count)
-				seq_printf(m, "\n\n\tServer interfaces: %zu",
-					   ses->iface_count);
+				seq_printf(m, "\n\n\tServer interfaces: %zu"
+					   "\tLast updated: %lu seconds ago",
+					   ses->iface_count,
+					   (jiffies - ses->iface_last_update) / HZ);
 			j = 0;
 			list_for_each_entry(iface, &ses->iface_list,
 						 iface_head) {
-- 
2.42.0



