Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E060213B7AE;
	Thu, 23 May 2024 13:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470585; cv=none; b=FJ7O8SU4Rb+Tn/hu/nR8XnSK+dNa+KcQhp7mIpYFKgpGRw6gFfCwM/TVqiYQSun5pfFQsQCmpn/4GLgULglsOfasjD8/3w+8tKHkUgfgLz9lqyfiqzV3CNAjozcAdIaijPkIjJMhqdLxW8kMYdypsFBZhwGlf6TSRbYKnXlNRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470585; c=relaxed/simple;
	bh=aP9g8aQAz8I1Mbfn8craBV9ZAgYx/0Ih3GwIDubRUfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwe7xHzPO1PDGHje3jskHDJ1ia3cZaR3Bf2+lxvczmYqGZcUQTtyDaKf5FzQJVLz6qp3/GEZthyVe1XIDnFAsl5WtsaQ3UbnGzMPY7TNy8jDje38afSY1L7T0HjhZBdKGaqS7LioiThvBWMwHsCIZThGJYvYT5OlfAJyZ6lsgns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zRNWO3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zRNWO3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCA6C32781;
	Thu, 23 May 2024 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470584;
	bh=aP9g8aQAz8I1Mbfn8craBV9ZAgYx/0Ih3GwIDubRUfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zRNWO3eYH5G7BS/PY+D8P97FJeOkeIeK3KfNT3l6HBce14oqkZCTAwRSEi8uVV/A
	 FQMjfStDPYJc0X+OcBYIzfKDv81vk8ySKKQTwvHVhuHWnU2lL2Y7cH6WupwDbjJLai
	 zaL6TotBjtMJOcYEp1KPaUbanMOuzqwrweyzlRYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/102] cifs: print server capabilities in DebugData
Date: Thu, 23 May 2024 15:12:30 +0200
Message-ID: <20240523130342.667779894@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 52768695d36a44d352e9fb79ba27468a5363ab8d ]

In the output of /proc/fs/cifs/DebugData, we do not
print the server->capabilities field today.
With this change, we will do that.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index c53d516459fc4..058e703107fc7 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -438,6 +438,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		if (server->nosharesock)
 			seq_printf(m, " nosharesock");
 
+		seq_printf(m, "\nServer capabilities: 0x%x", server->capabilities);
+
 		if (server->rdma)
 			seq_printf(m, "\nRDMA ");
 		seq_printf(m, "\nTCP status: %d Instance: %d"
-- 
2.43.0



