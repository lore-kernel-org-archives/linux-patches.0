Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9579C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6173C433F0;
	Thu, 12 Jan 2023 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533347;
	bh=seJvWumFKoobQXpi66eWDWoKRUZ3vb+5cnh0u7iGPwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM2kw3excVaqF59y7pbMvRT8Qo+b2TbWec+xBuwXlP3IJPqKUEc2Km7R3AcaqAxjR
	 Fa6yWP3LqHllGA/XaCZfeDTSHLt89/tVumqSdo1VqPV6JSR9tjYd5CqlFmMiRq7/2O
	 tROS/HPdcYXh1TqTOt2vc2L8TNAR1I0yxrTtxM4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Bai <baihaowen@meizu.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/783] powerpc/eeh: Drop redundant spinlock initialization
Date: Thu, 12 Jan 2023 14:52:46 +0100
Message-Id: <20230112135545.110602147@linuxfoundation.org>
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

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 3def164a5cedad9117859dd4610cae2cc59cb6d2 ]

slot_errbuf_lock has declared and initialized by DEFINE_SPINLOCK,
so we don't need to spin_lock_init again, drop it.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1652232476-9696-1-git-send-email-baihaowen@meizu.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 7ed38ebd0c7b..6ad8bda06345 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -846,8 +846,7 @@ static int __init eeh_pseries_init(void)
 		return -EINVAL;
 	}
 
-	/* Initialize error log lock and size */
-	spin_lock_init(&slot_errbuf_lock);
+	/* Initialize error log size */
 	eeh_error_buf_size = rtas_token("rtas-error-log-max");
 	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
 		pr_info("%s: unknown EEH error log size\n",
-- 
2.35.1



