Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56CA19BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CDDC4339B;
	Wed,  7 Jun 2023 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170550;
	bh=awLwyRpuLvxzkYp1+BuQee70cH6x2ekPPiLJGmfacb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqk02clzkKElsqKjSyI4eXqAGFVADQu+gB06Phmo5LYmJlCaMOa+cOdlCHBCS9GRc
	 ruqaFoebBU84+8P/X1ycmxfU2bqs7NkF/FAqE2G2ggiwb9KG4JR8e2DErOBO+2zGHk
	 x8X6LF2j0lyD2bvnz9iGUN4jKi6KDaSw9FJpIkdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/225] atm: hide unused procfs functions
Date: Wed,  7 Jun 2023 22:15:21 +0200
Message-ID: <20230607200918.564746918@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fb1b7be9b16c1f4626969ba4e95a97da2a452b41 ]

When CONFIG_PROC_FS is disabled, the function declarations for some
procfs functions are hidden, but the definitions are still build,
as shown by this compiler warning:

net/atm/resources.c:403:7: error: no previous prototype for 'atm_dev_seq_start' [-Werror=missing-prototypes]
net/atm/resources.c:409:6: error: no previous prototype for 'atm_dev_seq_stop' [-Werror=missing-prototypes]
net/atm/resources.c:414:7: error: no previous prototype for 'atm_dev_seq_next' [-Werror=missing-prototypes]

Add another #ifdef to leave these out of the build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516194625.549249-2-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/resources.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index 2b2d33eeaf200..995d29e7fb138 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -400,6 +400,7 @@ int atm_dev_ioctl(unsigned int cmd, void __user *buf, int __user *sioc_len,
 	return error;
 }
 
+#ifdef CONFIG_PROC_FS
 void *atm_dev_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	mutex_lock(&atm_dev_mutex);
@@ -415,3 +416,4 @@ void *atm_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	return seq_list_next(v, &atm_devs, pos);
 }
+#endif
-- 
2.39.2



