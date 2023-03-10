Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45790847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B746EC433D2;
	Fri, 10 Mar 2023 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456499;
	bh=WbRGxJjexTrn32/f2mfDDeqTxPCV2Mqvg6pvIbLkbbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXwZ1fLlr/64hDUTGB582agacOeMxsK6mlfbhuaRR6J5+T1Ihcu74pX6zRlEJr7Nd
	 LWFBjUqeff+9BWOxokMiJsuDe7kn7jePx3qo9uEssRMTlnGRM9E6nFEk7sQHjRQuCw
	 mhLfWcWLSofpXvTtggf/fQDSVW8lPAKYplRQ9ENc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Anton Ivanov <anton.ivanov@kot-begemot.co.uk>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 024/211] um: vector: Fix memory leak in vector_config
Date: Fri, 10 Mar 2023 14:36:44 +0100
Message-Id: <20230310133719.462492111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Yang <xiangyang3@huawei.com>

[ Upstream commit 8f88c73afe481f93d40801596927e8c0047b6d96 ]

If the return value of the uml_parse_vector_ifspec function is NULL,
we should call kfree(params) to prevent memory leak.

Fixes: 49da7e64f33e ("High Performance UML Vector Network Driver")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Acked-By: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index ded7c47d2fbe5..131b7cb295767 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -767,6 +767,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
-- 
2.39.2



