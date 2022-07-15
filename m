Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD4E4C65
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D28EC341CD
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657912830;
	bh=aNq/pYh0vkm3kacLYib/DPAOt4xuABwTnUvF0T519Jc=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=gnE4JXka0Wtm9k7PhDR70jMkeyiuh3ud586MiflpqvtvqC+Q4I4Ui9P2ZgAUFVT6P
	 DjAfk76LUqi/hvOnO48LlVaiMqQ/sKbC1xr5QnFToud1b9mM930r5gEC+Vj9hbOBa8
	 1HBTDSv5Es52ebd7OO/wwtInydF6q5IFGnTQyjIs=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 15:20:31 -0400
Subject: [PATCH v2 3/3] Add myself as ultimate maintainer
Message-Id: <20220707-my-new-branch-v2-3-c378d618b16b@linuxfoundation.org>
References: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
In-Reply-To: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=879;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=aNq/pYh0vkm3kacLYib/DPAOt4xuABwTnUvF0T519Jc=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIu7v0Xaea/yGSZp91x9RczF2nUOx5hWJGxS/bucy9xicfs
 bvoSHaUsDGJcDLJiiixl+2I3BRU+9JBL7zGFmcPKBDKEgYtTACbi6MnwT3mza31Bmfz0Od2mxsw3fu
 43Pmb1+oh1yp4HU8/dWmj49QzDP9tD4ZfVF3J3TdL/XVfgU1QQsmRzlHhGb13gKbVp3ltWcgEA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using it as testing grounds for
b4-submit. Do not read anything into this. :)

Acked-by: Lol Whoelse <mricon@kernel.org>
Tested-by: Mister Mismatchy <mricon@kernel.org>
Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
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
