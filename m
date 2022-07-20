Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524E53AF
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85321C341C7
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326019;
	bh=1YEf3hDRSEQAWwuudDfIYQo/04my2E9O3V5Pg8pnuqM=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=rU1ttiGFNkTlteXmue1uQAdN6kdQOcUa7jPNnlWtDMl7PXqLpUGcRiv93KLYwh9BI
	 oCDtj0xBQtNtjuTz7l1nPOzR9tGf1xKPZJ/t03SPoZLiqbaEFayi1Zq4Mb+WSzRGMt
	 cF1giY+5EsvnVHv8zwhvYpM/fZ4hPAHgyP6mtrDY=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:06:59 -0400
Subject: [PATCH v1 2/2] MAINTAINERS: set Kahless as ultimate maintainer
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v1-2-f787d95bfb7a@linuxfoundation.org>
References: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=708;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=1YEf3hDRSEQAWwuudDfIYQo/04my2E9O3V5Pg8pnuqM=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8DCzeUWxx3bne2VJGIpsMH4Uc0zdQJxF6RRDpI/xNqF9
 k5k6SlkYxLgYZMUUWcr2xW4KKnzoIZfeYwozh5UJZAgDF6cATKSfjeG/r8Ju9q+Bx5cU3th4o7LA3/
 SF7aaD7rOborI2KG3g2PHHmJGhq3/ru5fzmFXnW8euUZpyoffFT8n/msbsrhVsz52P1l/mAAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Kahless does not read mail. You have to bring your contributions to him
in person and defeat him in hand-to-hand combat.

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
