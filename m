Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250338F49
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B366DC4339B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778832;
	bh=kE6a0+oZZ6YgDtqCzkJDrC8W3w1ykVhTzNzusBBmzwA=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=2gzFsTYIG8Uvlz+CvMB16aqLSzPpbKoqgrL9wtdpGtdBwX/8jYLyu1FoFvkHPxNaS
	 TKXTyIPL14Mx//JoDw7hj9JIpYKX27snVKMInu2P5QSKgmUFUuTYGyczW0wOL+1/hk
	 B83Tq5s0CHoteneBE9NaPGVB5VA0PZMgWbUoriEM=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 02 Mar 2023 12:40:19 -0500
Subject: [PATCH v13 2/3] Junk babootich
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-test-endpoint-send-2-v13-2-047ec9929bec@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v13-0-047ec9929bec@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v13-0-047ec9929bec@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=665;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=YOCWK2SYjo0JERkJzLLZbnCMPAPntxIgY9Mym0Fcknw=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7vd3HY9RyXfw+n5vysoI7aaEz147uD/cntFXqOn9r
 Pz63RVuHaUsDGJcDLJiiixl+2I3BRU+9JBL7zGFmcPKBDKEgYtTACayLZzhv//bJPna6ZwHg91P
 7dhtqnJx5oPA76siI1rtxIIOXA+Mm8jI8O960bN9Z/+e02rccPLPuxpV2W292ncmZqZr5RsF9bJ
 lMwEA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

From: Konstantin Ryàbitsev <mricon@gmail.com>

This is junk.

Cc: Will Deacon <will@kernel.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Bubba Babootich <devnull@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 952d354069a4..114b14101182 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ VERSION = 6
 PATCHLEVEL = 0
 SUBLEVEL = 0
 EXTRAVERSION = -rc3
-NAME = Hurr durr I'ma ninja sloth
+NAME = Hurr durr I'ma ninja pirate
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"

-- 
2.39.2

