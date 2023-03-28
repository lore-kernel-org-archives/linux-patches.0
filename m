Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C828BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04295C433EF;
	Tue, 28 Mar 2023 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016008;
	bh=n82/7W0su+MOOrevUJFXo4y4UwqE7XEodnsU/kgLeQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqos13UCT/GU59aP6IMXoaL0NfA3M7lIu1r72e7Qn5RcmYZX6OqEEO+ouLO7Y31y1
	 a9MrqssU/R3uDISIQOuG884mMPjGPiT7LuQZx2PT8LshwTZe+mUWf7LHT/enOVo7Jz
	 v/VHCxIBCrEmCgxQfiMVfmotkaI4kn3YE35nFB3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <wangborong@cdjrlc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/146] serial: fsl_lpuart: Fix comment typo
Date: Tue, 28 Mar 2023 16:41:34 +0200
Message-Id: <20230328142602.898525162@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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
index e1ff109d7a14b..892c3cd83705b 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2866,7 +2866,7 @@ static int __maybe_unused lpuart_suspend(struct device *dev)
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



