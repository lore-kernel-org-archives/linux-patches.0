Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7803DFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3599C4339C;
	Mon, 15 May 2023 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169760;
	bh=2X4k2/iIks3FseQkiid0IWUxRMlvGIKBkbXIxiXk09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1+0kBjcf8+AAXeRgGb004ZX54MiEY0LwL8VpDYCYLmAItBHR+ru8OcDCiJTcQVSd
	 a7C+C8ha4c1d0WB8gSisoUjLN3iTfT0DcCzbKSTtMwnZqzP4h/yIJIrFu2Nsv5kd9f
	 eY9TQEV77kUC3L1SYWVujWvBzu5trEa/dUpzlGbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.3 162/246] sysctl: clarify register_sysctl_init() base directory order
Date: Mon, 15 May 2023 18:26:14 +0200
Message-Id: <20230515161727.495484545@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luis Chamberlain <mcgrof@kernel.org>

commit 228b09de936395ddd740df3522ea35ae934830d8 upstream.

Relatively new docs which I added which hinted the base directories needed
to be created before is wrong, remove that incorrect comment. This has been
hinted before by Eric twice already [0] [1], I had just not verified that
until now. Now that I've verified that updates the docs to relax the context
described.

[0] https://lkml.kernel.org/r/875ys0azt8.fsf@email.froward.int.ebiederm.org
[1] https://lkml.kernel.org/r/87ftbiud6s.fsf@x220.int.ebiederm.org

Cc: stable@vger.kernel.org # v5.17
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1445,10 +1445,7 @@ EXPORT_SYMBOL(register_sysctl);
  * register_sysctl() failing on init are extremely low, and so for both reasons
  * this function does not return any error as it is used by initialization code.
  *
- * Context: Can only be called after your respective sysctl base path has been
- * registered. So for instance, most base directories are registered early on
- * init before init levels are processed through proc_sys_init() and
- * sysctl_init_bases().
+ * Context: if your base directory does not exist it will be created for you.
  */
 void __init __register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name)


