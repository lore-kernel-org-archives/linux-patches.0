Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F8B4C8C
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E239C34115
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 20:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657915481;
	bh=vrJg913REtBhJXtzjUMzKbDV9ZudnRcOmO8cQm2Itig=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=Tn/iDzd0th6iLE4KenKenCPZXK6AnJhMewwOipp3BK2B3eDM6lty+xHT1ocGzweDr
	 SWkRcDRlW1bkd8MH5FWjt0G7OfPYU67Kf2TRa61fsjxahaf8oTncRjPme4F3rEaC4c
	 iLUbwg8J5rD461cj+pD9IhTHMJdr+BNxc6R5K9/4=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 16:04:41 -0400
Subject: [PATCH v3 2/3] Our version goes to 11
Message-Id: <20220707-my-new-branch-v3-2-feb2652699b2@linuxfoundation.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=523;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=vrJg913REtBhJXtzjUMzKbDV9ZudnRcOmO8cQm2Itig=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIunoioz62eNEWpPzQu/hbvzgdzd70Nsviizr733+Kuy1IH
 9+bu7ihlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjARoTsM/yO3tnzbu0d1jtgyh6/bT2
 ZWnr1Sw6h97uDjwJZUp5m/Tu9i+Kd5j2HipmuTPKVuH7ZI8WwuV+9WTmTZspT94KrumM81TzkB
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I'm using this series as testing ground for
b4 submit.

Acked-by: Lol Whoelse <mricon@kernel.org>
Tested-by: Mister Mismatchy <mricon@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index 990d2ee79186..51b4bd808d46 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-VERSION = 5
+VERSION = 11
 PATCHLEVEL = 19
 SUBLEVEL = 0
 EXTRAVERSION = -rc5

-- 
b4 0.10.0-dev-05523
