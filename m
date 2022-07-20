Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A653B1
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A27C341CB
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326655;
	bh=SKa8gfknJXLWAVo2Unl8k+ZI0frv0zTiu7pLLqDT/A4=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=YmxgCmPTKZzh7dYmUquYOfdMBuSBPkX/7n//wEskIJ11JhuBoQXAElS9PQvBYPSoL
	 rGXLMm9PgsbZe/OmaYFUycaN1PmdCot9+tQeUCLPWp/28VxQRyQFOupQYPtaiwGZFx
	 ikSCVpxnCaTlqPBadLb12H1WWX4JAr+Dod6oDWqU=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:17:35 -0400
Subject: [PATCH v2 2/3] MAINTAINERS: set Kahless as ultimate maintainer
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v2-2-ddbde3dd27ea@linuxfoundation.org>
References: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=757;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=SKa8gfknJXLWAVo2Unl8k+ZI0frv0zTiu7pLLqDT/A4=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8NUr88++qnb2UdqXk1s2CAWdm/+l4v9ay/QVThN1fqxT
 +NWr1VHKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAitxsY/qd8vLAofa3nfKGD2x3Xt9
 vqeO8TdD3fFVV06kBCpd+e0wwM/129FB//nLXleOOc4t9Ty76H1Hx2eiBssi6n5Mby+28/HeQFAA==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Kahless does not read mail. You have to bring your contributions to him
in person and defeat him in hand-to-hand combat.

Reviewed-by: General Martok <mricon@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 651616ed8ae2..9c503e9006db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22257,9 +22257,9 @@ S:	Maintained
 F:	mm/zswap.c
 
 THE REST
-M:	Linus Torvalds <torvalds@linux-foundation.org>
+M:	Kahless the Unforgettable <devnull@kernel.org>
 L:	linux-kernel@vger.kernel.org
-S:	Buried alive in reporters
+S:	Kahless does not read your mail
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 F:	*
 F:	*/

-- 
b4 0.10.0-dev-45aaa
