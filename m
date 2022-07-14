Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCA3601B
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B03BC3411C
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657828354;
	bh=bV62dC7FH/10gtPEnis1GfiSvoCLwwQ4YSBArV0d++Q=;
	h=From:Date:Subject:References:To:From;
	b=xJO3Onxz8FIbd7ixFWR+BghGkWn0HEWoX482WMRxmh1gWYe7S5HTYyHhUbGwWufbY
	 xUCQLoY3/rUfBRycxV64aJZo1CVD+m89AQ0bUk5NWRUKJmA1OqTttoRnaTI1jbxb47
	 v9HQp/fXuVKy+5V5s7OLXrsRP7uca1CSpPFkA9Lw=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 14 Jul 2022 15:52:34 -0400
Subject: [PATCH WIP v1 2/3] Our version goes to 11
Message-Id: <20220707-my-new-branch-v1-2-8d355bae1bb5@linuxfoundation.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=431;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=bV62dC7FH/10gtPEnis1GfiSvoCLwwQ4YSBArV0d++Q=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIulDAV9Xhd4meUe7PuTRen0O9377f2z1o0VUV7Skme7trN
 Zz/+6ChlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjCRb74M/9QrfIWU1uVtsv0QuCX93+
 NL75dt3/n75P+e2QtzVrjdaa9mZDhZwfUjcfXHo80BKyUTGXWKZD5ZdcxPn9xYfuTepeAZEiwA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I'm using this series as testing ground for
b4 submit.

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
