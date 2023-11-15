Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AED63DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPLx8By1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E011AC433C7;
	Wed, 15 Nov 2023 19:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078259;
	bh=GXubPC61tG2H4K6UjtFmQTBoKlIyv8Ls/J65GfpH4BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPLx8By14UdVERlJn/IjLH5hdnRnTejXH5Kz3vYVANwG5lbm9+Az5k4eD4azGGAgL
	 7szXp0C23SIW2hZOThDZ4WYYAXOZnf9irgocogI1YoYG5cjOWDkvd0CLyMQGkYtqBS
	 +dav4159164yABcntq3QYMLDuMXYl63gjKuNJolU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/379] crypto: hisilicon/qm - delete redundant null assignment operations
Date: Wed, 15 Nov 2023 14:24:45 -0500
Message-ID: <20231115192657.531261273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 7bbbc9d81be588ae4fb28b5b202e4421dbfef197 ]

There is no security data in the pointer. It is only a value transferred
as a structure. It makes no sense to zero a variable that is on the stack.
So not need to set the pointer to null.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 5831fc1fd4a5 ("crypto: hisilicon/qm - fix PF queue parameter issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 07e1e39a5e378..a878a232ef5b5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1773,7 +1773,6 @@ static void dfx_regs_uninit(struct hisi_qm *qm,
 		dregs[i].regs = NULL;
 	}
 	kfree(dregs);
-	dregs = NULL;
 }
 
 /**
-- 
2.42.0



