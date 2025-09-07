Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5821F1921;
	Sun,  7 Sep 2025 20:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276411; cv=none; b=NiPssF+cISHuwzHuYVO4XO/p7xPZVUJwERiErQ/cOdxUvzpXzWiXe5KR/qBVdiwTm4ZV/Qj1thkQUcmiKeRo4x2vUc/zbKtK5AxIJIm2PTWkf9FOzcsx1rR9uPT4ldjUyshjHk35sM+79RzpPMiXk4h644hPWvUnM4THUxSuaDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276411; c=relaxed/simple;
	bh=ZSJP/df9KSCWl5sruw0QGPUVG7z7FBHekDEhZ1Dq/DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGjKE/4+M1y8Z6mop7P/F3Mg6aa+bA28ZvMTIWRGeNT9OWPkKjGXrfq1bvJTA9f/9kOr1UbFnp3zg+hGsNGanlyMgfWHHsHeK+n3aAcWnb+mBCwNpATpSFZ3r3K6CzgHtDt6H5433bcCPDwLxKcHelCatIrQ3ilxLH7Ql95XRXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DI731v7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DI731v7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F212DC4CEF0;
	Sun,  7 Sep 2025 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276410;
	bh=ZSJP/df9KSCWl5sruw0QGPUVG7z7FBHekDEhZ1Dq/DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DI731v7l2shV1gOHD6PvSBoBSwxOJ44kgAUcomtBlnvv0EYqk5+o+b/tE7DXBpo2g
	 R7Ocq8xywXiizJm4Xlh29BH9hgMnUplnSkOmLrMdJXIo904HlPE/jYfQTr3SMVx4/D
	 KxAz7cSny+TMYPJqjAdgnzXar4eIFss4Y+lgvPTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjiao <zhangjiao2@cmss.chinamobile.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/104] tools: gpio: rm .*.cmd on make clean
Date: Sun,  7 Sep 2025 21:58:52 +0200
Message-ID: <20250907195610.128606995@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



