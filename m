Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D5848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6AEC4339C;
	Fri, 10 Mar 2023 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458206;
	bh=femLk/G21cWkDK85w7A/7MbapcoWiK8uWhe6w1wRuoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJI/Wf13dZCgnpDdP8O+ZBj2/AxcmYhrl+AeMlff/ozJeDLTE36WI3TS8zN9mvaK3
	 MHfg2iFPSgTcrhNx5wk24mccFsIERhKc7CwGtj9JII/MpNMdLUYYateTogkyA+8AKL
	 hleL/f+kntgCADSIdDejrq+MA5Gr3GLaXcktEtfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Anton Ivanov <anton.ivanov@kot-begemot.co.uk>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/252] um: vector: Fix memory leak in vector_config
Date: Fri, 10 Mar 2023 14:39:30 +0100
Message-Id: <20230310133725.095607138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index 50ee3bb5a63a9..b0b124025b486 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -741,6 +741,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
-- 
2.39.2



