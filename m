Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0218749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E84C433EF;
	Thu, 12 Jan 2023 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532806;
	bh=V66IeALkdl/dfJg5mV7f8ivYgHhJJ4IbCIczghglw1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyxBv3O/zy0V47Jfdc6xpKbOWBR4XQWHlF2A9ZB9eJQzTJNlZQQqD8i+2Fk1ACwaQ
	 3p1kdToZIBVSIQ891L6BYoinMeKFohNrkihEvK/ZAsUjlk08zp+3LY5GokIWrxidBO
	 OVgjCu2niFsX+XdgT3IMtOjL9/uy75gL4z23eodc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/783] apparmor: Use pointer to struct aa_label for lbs_cred
Date: Thu, 12 Jan 2023 14:49:59 +0100
Message-Id: <20230112135537.515322773@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 37923d4321b1e38170086da2c117f78f2b0f49c6 ]

According to the implementations of cred_label() and set_cred_label(),
we should use pointer to struct aa_label for lbs_cred instead of struct
aa_task_ctx, this patch fixes it.

Fixes: bbd3662a8348 ("Infrastructure management of the cred security blob")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ffeaee5ed968..585edcc6814d 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1161,10 +1161,10 @@ static int apparmor_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 #endif
 
 /*
- * The cred blob is a pointer to, not an instance of, an aa_task_ctx.
+ * The cred blob is a pointer to, not an instance of, an aa_label.
  */
 struct lsm_blob_sizes apparmor_blob_sizes __lsm_ro_after_init = {
-	.lbs_cred = sizeof(struct aa_task_ctx *),
+	.lbs_cred = sizeof(struct aa_label *),
 	.lbs_file = sizeof(struct aa_file_ctx),
 	.lbs_task = sizeof(struct aa_task_ctx),
 };
-- 
2.35.1



