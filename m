Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D26032
	for <patches@lists.linux.dev>; Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EDFC433C1;
	Tue, 26 Jul 2022 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658867069;
	bh=7gd54/nbcaRoM9aB30mFVnqiO7PL2uNVeOxIWqSYP+4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UuIBmM6OQWMaxlXyBWBxosYneMCLYmvkh6gvrhUJZwYJKYPW8jxA3CaAyTS6Uiwt/
	 1y1w3ty9X/GPc76eE3zOZhIis9y2SCNRm4YGpKsvxZibh97Qq4aPvEXrjeazMKy1TP
	 Zsc2onHqd9J3ZqajMMCAURENjjP/JpYP82VSgueY=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Tue, 26 Jul 2022 16:24:28 -0400
Subject: [PATCH v2 2/4] Makefile: Let's start our version at 200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220726-claim-for-great-pumpkin-v2-2-a99ee69dec8e@linuxfoundation.org>
References: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
In-Reply-To: <20220726-claim-for-great-pumpkin-v2-0-a99ee69dec8e@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
Cc: Konstantin Ryabitsev <konstantin.ryabitsev@linux.dev>
X-Mailer: b4 0.10.0-dev-13c24
X-Developer-Signature: v=1; a=ed25519-sha256; t=1658867069; l=493;
 i=konstantin@linuxfoundation.org; s=20211109; h=from:subject:message-id;
 bh=7gd54/nbcaRoM9aB30mFVnqiO7PL2uNVeOxIWqSYP+4=;
 b=oOfBMRv0FXsmb+vUIPKwKar9VtKvlm+MnxGdcCkS/Wfc4XcbuW7vZxShTBMob/lpwOTKg6lj7h01
 kCOaxG30Cmdfibn1bKzelVg50/r3+xD5MSCII5dUIsEzkoawSCYs
X-Developer-Key: i=konstantin@linuxfoundation.org; a=ed25519;
 pk=fAfUubVyx9rNeSbf8qETNADGwWcptn+Ur6Aaf++c4AY=

Because why not 200?

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index b79c1c18149d..18f749d988e8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
-VERSION = 5
+VERSION = 200
 PATCHLEVEL = 19
 SUBLEVEL = 0
 EXTRAVERSION = -rc8
-NAME = Superb Owl
+NAME = Great Pumpkin
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"

-- 
b4 0.10.0-dev-13c24
