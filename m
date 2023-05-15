Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E470FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFABC433D2;
	Mon, 15 May 2023 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169040;
	bh=LBuqxzUURxy6JBHyX4sQ1p/puLomcRGyhP/qbfuoyCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEAmjGCrCUKgCcxMf6cy+0Kq9Lr4Gr828iKJ8cxp5NYl+3GoeuZ6LK4lBuEF/oUoz
	 00tH9LSuyk3O5Qzdxbq9Gm8JEya23wJ+ruOM8rvs3iz0QBu6kyFFCt3P42VrvaQclb
	 XdGwSQelGSXj3a5q2XuXrIhITmOLb5wXOF1j7Gow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/191] ia64: salinfo: placate defined-but-not-used warning
Date: Mon, 15 May 2023 18:25:29 +0200
Message-Id: <20230515161710.609453330@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0de155752b152d6bcd96b5b5bf20af336abd183a ]

When CONFIG_PROC_FS is not set, proc_salinfo_show() is not used.  Mark the
function as __maybe_unused to quieten the warning message.

../arch/ia64/kernel/salinfo.c:584:12: warning: 'proc_salinfo_show' defined but not used [-Wunused-function]
  584 | static int proc_salinfo_show(struct seq_file *m, void *v)
      |            ^~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20230223034309.13375-1-rdunlap@infradead.org
Fixes: 3f3942aca6da ("proc: introduce proc_create_single{,_data}")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/salinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index aba1f463a8dd4..b889db4492c8d 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -580,7 +580,7 @@ static int salinfo_cpu_pre_down(unsigned int cpu)
  * 'data' contains an integer that corresponds to the feature we're
  * testing
  */
-static int proc_salinfo_show(struct seq_file *m, void *v)
+static int __maybe_unused proc_salinfo_show(struct seq_file *m, void *v)
 {
 	unsigned long data = (unsigned long)v;
 	seq_puts(m, (sal_platform_features & data) ? "1\n" : "0\n");
-- 
2.39.2



