Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44414C7A
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A70C3411E
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657915481;
	bh=uWHZjvei9Xo4mazj+JqgkAd5yRK1WgQ8rH8hxKL5hgg=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=gVxX7tlfUKgCUfuugCJsUS3/X+e7cOQHEZX6IWndQKoEV3CrJAn0Xpd+x3TRFlJeI
	 k/TDcwHMflUhZNeET7uOqHQ+KwzUoPnDcLLsPZAGppG031to+cqVDoKwRKjbawugvD
	 jBM39ZUT9aDLsIuA3/kSLkFta4Mhcb00RDfWHPuU=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 16:04:42 -0400
Subject: [PATCH v3 3/3] Add myself as ultimate maintainer
Message-Id: <20220707-my-new-branch-v3-3-feb2652699b2@linuxfoundation.org>
References: <20220707-my-new-branch-v3-0-feb2652699b2@linuxfoundation.org>
In-Reply-To: <20220707-my-new-branch-v3-0-feb2652699b2@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=797;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=uWHZjvei9Xo4mazj+JqgkAd5yRK1WgQ8rH8hxKL5hgg=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIunoh8OVehSfsGQ95nyyOTKyKur3ILOGNxSvPYCTMt3eTY
 pR9+dJSyMIhxMciKKbKU7YvdFFT40EMuvccUZg4rE8gQBi5OAZiIcSzD/4p1Si3v1jTcjp79YYH0Li
 uHBQ3VZmomeyaskFFd1/fIPpeR4WutTLKQnZeUaumP+S6edufu3TNwtPDYPufasxUT9n2oYwMA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using it as testing grounds for
b4-submit. Do not read anything into this. :)

Reviewed-by: Sockpuppet Extraordinaire <mricon@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 66bffb24a348..1abdb1c2bfe8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22183,9 +22183,9 @@ S:	Maintained
 F:	mm/zswap.c
 
 THE REST
-M:	Linus Torvalds <torvalds@linux-foundation.org>
+M:	Konstantin Ryabitsev <konstantin.ryabitsev@linuxfoundation.org>
 L:	linux-kernel@vger.kernel.org
-S:	Buried alive in reporters
+S:	I claim Linux in the name of Kahless the Unforgettable
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 F:	*
 F:	*/

-- 
b4 0.10.0-dev-05523
