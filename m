Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279A3600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5EDC341C6
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657828354;
	bh=EKR/WAZxlMYDyjcGAZ200Yf+qYw5KxYpSka9TKJVPoM=;
	h=From:Date:Subject:References:To:From;
	b=U5IpaM6dutihUbiISoymd999HptZWHgx0K7I62hOrYWBEuPuE/6XwdeQKMzeyDuF8
	 1avT1PnBIZrlqW4BUiD1n99Oq2WpykYe14ZhNv3hMdfk2M4eo7KOmFobCfmLcqu+LI
	 zdG6DBzgB1ZP1MnEYNIeH2Kdmtu4bRaNX1LEV0FA=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 14 Jul 2022 15:52:35 -0400
Subject: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Message-Id: <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=730;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=EKR/WAZxlMYDyjcGAZ200Yf+qYw5KxYpSka9TKJVPoM=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIulDDZiMhu99Ouvy0swqnKJnlCRGLy5NvHqvvuNM4ylfsr
 +uNWRykLgxgXg6yYIkvZvthNQYUPPeTSe0xh5rAygQxh4OIUgIlk1TH8Lz33ZyXXYZ6bL85/luZoy0
 6dxdagecRdV0pn0cQlTfNl/Bn+Wa/oE33/JKG+3kOVb+UtvUgNKfe8N62XDzb/5GHeyXyKFwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using it as testing grounds for
b4-submit. Do not read anything into this. :)

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 66bffb24a348..2d662349ee5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22183,9 +22183,9 @@ S:	Maintained
 F:	mm/zswap.c
 
 THE REST
-M:	Linus Torvalds <torvalds@linux-foundation.org>
+M:	Konstantin Ryabitsev <konstantin.ryabitsev@linuxfoundation.org>
 L:	linux-kernel@vger.kernel.org
-S:	Buried alive in reporters
+S:	I claim Linux in the name of the Klingon Empire
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 F:	*
 F:	*/

-- 
b4 0.10.0-dev-05523
