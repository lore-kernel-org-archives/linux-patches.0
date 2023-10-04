Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E921D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYtbJHx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDE9C433C9;
	Wed,  4 Oct 2023 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443591;
	bh=BLj+0Ng5NQN1C2/turNlPDGQcteRRJsC311slMu5Sj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYtbJHx0IukNsHJbC4WxGRPQrGNj/K8we252Nm3Psk2/WP4Xi9XJ3AJI0/PFgwIZH
	 1p9ObqgXKs17ipBRYpQdXM00ycusHE9ivDmHlVXwSOAC0HNugwaooSoznCCuj3LUAx
	 0SNCH2u/qYBrwjuos+B7PGRwdckwnaIlv7G13/ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Wen <puwen@hygon.cn>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 210/259] x86/srso: Add SRSO mitigation for Hygon processors
Date: Wed,  4 Oct 2023 19:56:23 +0200
Message-ID: <20231004175226.937548096@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Pu Wen <puwen@hygon.cn>

commit a5ef7d68cea1344cf524f04981c2b3f80bedbb0d upstream.

Add mitigation for the speculative return stack overflow vulnerability
which exists on Hygon processors too.

Signed-off-by: Pu Wen <puwen@hygon.cn>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/tencent_4A14812842F104E93AA722EC939483CEFF05@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1282,7 +1282,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
 	VULNBL_AMD(0x17, RETBLEED | SMT_RSB | SRSO),
-	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB),
+	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB | SRSO),
 	VULNBL_AMD(0x19, SRSO),
 	{}
 };


