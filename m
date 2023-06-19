Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CDD10960
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75FC433C0;
	Mon, 19 Jun 2023 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170849;
	bh=OAXPy3wpiQhM255WLShy5Vhb05cx7afxa7QjflIereA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpQBzgCae+oYSYS4aqxA9CdMkRiMEynwTYDEDBlbINrPKXVtIbuAnPsyth95mXsx/
	 v1CQ6yw4630pVq6cq53w1RVuLclX9JP2gfe+dE3qMDealjs8jmqBccYL3cMyZZVUtk
	 okZsK0fMfp1CZzfxudT/Xx5EVEheBvbAPxEbOOMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Immad Mir <mirimmad17@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.3 057/187] LoongArch: Fix debugfs_create_dir() error checking
Date: Mon, 19 Jun 2023 12:27:55 +0200
Message-ID: <20230619102200.436516706@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Immad Mir <mirimmad17@gmail.com>

commit 41efbb682de1231c3f6361039f46ad149e3ff5b9 upstream.

The debugfs_create_dir() returns ERR_PTR in case of an error and the
correct way of checking it is using the IS_ERR_OR_NULL inline function
rather than the simple null comparision. This patch fixes the issue.

Cc: stable@vger.kernel.org
Suggested-By: Ivan Orlov <ivan.orlov0322@gmail.com>
Signed-off-by: Immad Mir <mirimmad17@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/unaligned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/unaligned.c
+++ b/arch/loongarch/kernel/unaligned.c
@@ -485,7 +485,7 @@ static int __init debugfs_unaligned(void
 	struct dentry *d;
 
 	d = debugfs_create_dir("loongarch", NULL);
-	if (!d)
+	if (IS_ERR_OR_NULL(d))
 		return -ENOMEM;
 
 	debugfs_create_u32("unaligned_instructions_user",


