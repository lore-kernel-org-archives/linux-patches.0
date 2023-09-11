Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050501170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E9EC433C7;
	Mon, 11 Sep 2023 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440365;
	bh=QNxt0HOGg1zZ2lHhl0bnyLODwzEJSS5ZT0AbZGtP8Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmnDJgWp5p5+zv/ULb6aPtwBJbfKSwKo2xYt37zRBEKvHpsKePa5av3toCusTTRTx
	 DahRX1q9+ZwDFcL7KirlhUzYUwJndsk13/eReP803XoUI8URHvVdZHXXqcnomWQuTX
	 7ex2dH4jl3YYD74f2JZkogBklkmaDXKXAKr94K/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 036/739] arm64/ptrace: Clean up error handling path in sve_set_common()
Date: Mon, 11 Sep 2023 15:37:15 +0200
Message-ID: <20230911134652.104340925@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5f69ca4229c7d8e23f238174827ee7aa49b0bcb2 ]

All error handling paths go to 'out', except this one. Be consistent and
also branch to 'out' here.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/aa61301ed2dfd079b74b37f7fede5f179ac3087a.1689616473.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 187aa2b175b4f..20d7ef82de90a 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -891,7 +891,8 @@ static int sve_set_common(struct task_struct *target,
 			break;
 		default:
 			WARN_ON_ONCE(1);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 		/*
-- 
2.40.1



