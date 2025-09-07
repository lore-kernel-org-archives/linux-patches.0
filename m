Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AEC17BB21;
	Sun,  7 Sep 2025 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276791; cv=none; b=LAknLVWDEqrljtBSNU39FoYpPgL9Ry55UYgvw6mTh6YCD4pYMdtnt33ekt0h6JoMJzRyYmYznqC4PINu31T8EIc7kUsmI6jR27IgzNDNw07S+nQhW7tFWQkqsXuo8DRyINksPyPqv0JrLR7Fam1Gy45qMn7DVVMSYi7L1Gxv05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276791; c=relaxed/simple;
	bh=DoBqYWrUT5+LYQhAxgCLfaQgIF/iwMB/wfH5LEnMXGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtuXdN15UE0zF+PMJeVOLsgCZCm3e++4HwEeeI3b+yGENbkCXDapTlxC9IWLd/d4OlJWVIIvOX2HOo4WbUJS8R5u9A1IJN1pMYiNlOsl/jLV4eRwcs8Qp4ZevHDElzs2gdfUInZn8rZQuxeXJxlBfDf7rsCysYlE8AT/7dDv1Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wxr4cWLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wxr4cWLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C88C4CEF0;
	Sun,  7 Sep 2025 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276791;
	bh=DoBqYWrUT5+LYQhAxgCLfaQgIF/iwMB/wfH5LEnMXGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wxr4cWLMKAdX9/TtK5u8XpZtVLXgwiLmTEgtd6gdIR8RzfKSOOVFIupqrVCAf3i0F
	 SAst133tMdv5Vh38+fc2xvZX8douUd5bSF6KOHDfsxX37VLaDH+G1hPM61go5CSVUd
	 Ie6JIvG30yLjX5hVaFbQgiHMDdwCHA06YCCpCP6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjiao <zhangjiao2@cmss.chinamobile.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/121] tools: gpio: rm .*.cmd on make clean
Date: Sun,  7 Sep 2025 21:59:08 +0200
Message-ID: <20250907195612.724387237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhangjiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 931a36c4138ac418d487bd4db0d03780b46a77ba ]

rm .*.cmd when calling make clean

Signed-off-by: zhangjiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20240829062942.11487-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: ed42d80f3bae ("tools: gpio: remove the include directory on make clean")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/Makefile b/tools/gpio/Makefile
index d29c9c49e2512..ed565eb52275f 100644
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -78,7 +78,7 @@ $(OUTPUT)gpio-watch: $(GPIO_WATCH_IN)
 clean:
 	rm -f $(ALL_PROGRAMS)
 	rm -f $(OUTPUT)include/linux/gpio.h
-	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete
+	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
 	install -d -m 755 $(DESTDIR)$(bindir);		\
-- 
2.51.0



