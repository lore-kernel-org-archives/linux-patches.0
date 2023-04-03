Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BDD6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF194C433EF;
	Mon,  3 Apr 2023 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531910;
	bh=Fl/vlYeUW39Md15nQwyr5HWiNGCg1oAAvbVd102TIUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZwAGcWoaNFQbOtBzohCrz4csvTwFqT9oAM8wEgpwHdrrYQgS0Q7pK6fin5ZvcTbO
	 XOkEmhwCgItAZMLOUwaDQmmaPhis3yMX1BbOmVmeB0ufaPreyTMNB1+/V8ugbmmHbW
	 J6ylMtXXp1F1kedJ40uxN2lBKpr+FU2APJ/mxuls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <wangborong@cdjrlc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/173] serial: fsl_lpuart: Fix comment typo
Date: Mon,  3 Apr 2023 16:07:08 +0200
Message-Id: <20230403140414.708212383@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Wang <wangborong@cdjrlc.com>

[ Upstream commit 374e01fa1304e1eabd2cd16f750da3ecaeab069b ]

The double `as' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Link: https://lore.kernel.org/r/20220803104208.4127-1-wangborong@cdjrlc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1be6f2b15f90 ("tty: serial: fsl_lpuart: fix race on RX DMA shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 32cce52800a73..bab296c5a0211 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2766,7 +2766,7 @@ static int __maybe_unused lpuart_suspend(struct device *dev)
 		 * EDMA driver during suspend will forcefully release any
 		 * non-idle DMA channels. If port wakeup is enabled or if port
 		 * is console port or 'no_console_suspend' is set the Rx DMA
-		 * cannot resume as as expected, hence gracefully release the
+		 * cannot resume as expected, hence gracefully release the
 		 * Rx DMA path before suspend and start Rx DMA path on resume.
 		 */
 		if (irq_wake) {
-- 
2.39.2



