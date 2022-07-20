Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241486ADF
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73C8C341CB
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658339821;
	bh=zYXVVnUzBNmKedEca3ViX35yDj8WpBiVC3/GHf/bEFA=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=XtlaLbmylykgPOU1K+DStND/A9x9REEWx3sJQEEAxQT6DetMfVwFgRFMYhrvuYs9X
	 qZIGTFrbRiCqgn5jgjxWxxHZf1yJ2L5H9vwE5gA0qYSNnVBOGeMC/VZEo0KFeNUNsM
	 0MfCn8gE6HcBGbH6GUxLR/rc0C3Zo5SD88BjT7t8=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 13:57:01 -0400
Subject: [PATCH v3 2/3] MAINTAINERS: set Kahless as ultimate maintainer
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v3-2-7874906a7515@linuxfoundation.org>
References: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v3-0-7874906a7515@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-e2b6f
X-Developer-Signature: v=1; a=openpgp-sha256; l=870;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=zYXVVnUzBNmKedEca3ViX35yDj8WpBiVC3/GHf/bEFA=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJuOL69c8DigCUn+w7HIitPX4u7O08UF2rMv5NUEZ+8PcNt
 VQ1DRykLgxgXg6yYIkvZvthNQYUPPeTSe0xh5rAygQxh4OIUgInwzmBkaA9vZQm4Ol/gixLb9rAFyS
 uSjXitrZympasK3I3cFCdcxMjwZ43m4gNvp/3lWP9+qrXaCR5G99Pvrxw6umD67if9vV83cQEA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Kahless does not read mail. You have to bring your contributions to him
in person and defeat him in hand-to-hand combat.

Reviewed-by: General Martok <mricon@kernel.org>
Tested-by: Gowron son of M'Rel <devnull@kernel.org>
Reviewed-by: Voq the Pale <konstantin.ryabitsev@linux.dev>
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
b4 0.10.0-dev-e2b6f
