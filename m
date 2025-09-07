Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C989C17BB21;
	Sun,  7 Sep 2025 20:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276794; cv=none; b=XQTjkTIqNtS1JkpfUQo0noTtOlc98ySqJ4MePic07xp1tOT6NHuKjRZla6+5H2/wyjnV8OBkaQCMefgtjQD4ULMaYSvhwNd2YjCvy+BaJi5x/Uva84XLNO5F68VBdN0F/4v5htqEPxeqYRA/1T8HDseIQw+1HusYpwbz5KBwlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276794; c=relaxed/simple;
	bh=gf12MweqRvaG41qjwBk/7KI/+7bY6ccMdv9vXzx+GjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmtxxpCxUs6Bv1Si7Ozid+m0+GUhuVVQ2QyRJYafyoAF12nv70VbnbYep1p51M/9JUh6lnmWIEBS8NfLPG0AkivruMAX5EYQQJjVCOBq8opAzedwnHB9SGbe6cJv+612mMVGUa6AN8FLAJiN2UAkNwPwLnAXZpLITZwty6G/aR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJ/Lpj0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJ/Lpj0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242ACC4CEF0;
	Sun,  7 Sep 2025 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276794;
	bh=gf12MweqRvaG41qjwBk/7KI/+7bY6ccMdv9vXzx+GjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJ/Lpj0/Gz5YtD8P01OQG/NyJVNVzZueymuP1jgzO0QwQGFgQ3jLbN+qJGUl0E/fB
	 KY5Ihwd7g7KtCZ19GoNkXlBKCm8/J/SjXwBCA0wzOENB2h86wGX/uIEufrUY1FD5e8
	 fB4aRd7/JjpKRxsMJAIIworfmaiZ2TaQKR3P2cUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/121] tools: gpio: remove the include directory on make clean
Date: Sun,  7 Sep 2025 21:59:09 +0200
Message-ID: <20250907195612.747150157@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit ed42d80f3bae89592fbb2ffaf8b6b2e720d53f6a ]

Remove the generated include directory when running make clean.

Fixes: 8674cea84dc6 ("tools/gpio: move to tools buildsystem")
Signed-off-by: Zhang Jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20250903063621.2424-1-zhangjiao2@cmss.chinamobile.com
[Bartosz: add Fixes tag, improve the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/Makefile b/tools/gpio/Makefile
index ed565eb52275f..342e056c8c665 100644
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -77,7 +77,7 @@ $(OUTPUT)gpio-watch: $(GPIO_WATCH_IN)
 
 clean:
 	rm -f $(ALL_PROGRAMS)
-	rm -f $(OUTPUT)include/linux/gpio.h
+	rm -rf $(OUTPUT)include
 	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
-- 
2.51.0



