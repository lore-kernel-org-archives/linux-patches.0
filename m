Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B86F9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2451EC433C8;
	Mon, 11 Sep 2023 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442752;
	bh=K2lHHz118fyD0vLOby3UUTGqv1EB+RnX8k+y8HcVrDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9+EFvZHE27oXPkxUPoWTUxK3Elq1W4BCCiR87LIXrqBsBWBqjbzu703qBh3SSgkL
	 MYlq1GIPtDDBD2p5693uq+U1Y4vTLMzjMVdlZ1wscgeSVu2PC6XRFKfBIh/4r4feia
	 YWo5S6a2x8aUAb7+tQ0kTqRCz97jTW4grZeCalas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 118/737] arm64/ptrace: Clean up error handling path in sve_set_common()
Date: Mon, 11 Sep 2023 15:39:37 +0200
Message-ID: <20230911134653.799805120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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



