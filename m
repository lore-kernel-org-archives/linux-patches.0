Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D010D52A
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H2cUIW21WZq17g9O2oNgRsa778WFbjBOimotIrmyA/E=; b=nNmP8ACa3bYQFO+va5O1HA9FsY
	7uEoxbwqkYk/qt113tW2SYA9YMG3a2AHu8L7Iv3iQ0EMlgc7BBKKyksmjuEvEnZO0sSPh+srw21Ed
	92vGNiItW9t2AeJ5aH7Je//Kla0sYsQd6yw57DZXv4g5YLEqNM5fx8BqApdQ2WOzt1ETsFacehG28
	1v5ozP5b85IjoFEOhl2RVeEKNDt9QH7O2q/lI+HC3DfepUovBBCkaCjB4ahImpZOYcj2qeiGF+SSR
	bKm0l0YVBiFRo1VjmJYCVnVBvM6yvLikEV5zJHWv1DMHYb3GMsppkfKWHIApcwT0D+DZwuAqLb0xi
	hYGi9dkg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpXS-003FxJ-9n; Thu, 02 Mar 2023 20:28:30 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	john.johansen@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	luto@amacapital.net,
	wad@chromium.org,
	dverkamp@chromium.org,
	paulmck@kernel.org,
	baihaowen@meizu.com,
	frederic@kernel.org,
	jeffxu@google.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	guoren@kernel.org
Cc: j.granados@samsung.com,
	zhangpeng362@huawei.com,
	tangmeng@uniontech.com,
	willy@infradead.org,
	nixiaoming@huawei.com,
	sujiaxun@uniontech.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 06/11] yama: simplfy sysctls with register_sysctl()
Date: Thu,  2 Mar 2023 12:28:21 -0800
Message-Id: <20230302202826.776286-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302202826.776286-1-mcgrof@kernel.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

register_sysctl_paths() is only need if you have directories with
entries, simplify this by using register_sysctl().

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 security/yama/yama_lsm.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 06e226166aab..90dd012b0db5 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -447,12 +447,6 @@ static int yama_dointvec_minmax(struct ctl_table *table, int write,
 
 static int max_scope = YAMA_SCOPE_NO_ATTACH;
 
-static struct ctl_path yama_sysctl_path[] = {
-	{ .procname = "kernel", },
-	{ .procname = "yama", },
-	{ }
-};
-
 static struct ctl_table yama_sysctl_table[] = {
 	{
 		.procname       = "ptrace_scope",
@@ -467,7 +461,7 @@ static struct ctl_table yama_sysctl_table[] = {
 };
 static void __init yama_init_sysctl(void)
 {
-	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
+	if (!register_sysctl("kernel/yama", yama_sysctl_table))
 		panic("Yama: sysctl registration failed.\n");
 }
 #else
-- 
2.39.1

