Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56013A3838
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340993; cv=none; b=JCVJrgkvsn8UoAd1lvCsz4Sik6d4a0fk34c2CzQzlBE8LunfEtAStX8u3n0Wd9QXnWyfH23Vkii06hcoNLjHKAIu9dIL9F13TPMiiws4bYjvtZUKMu4nM+cSiGxUJWKl2HNbU9EcYyx/ZZwGOB7YhR0T+Xbwf4JjOFvZD2upVqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340993; c=relaxed/simple;
	bh=VZ1CeIaEPQ4tjZX3+zl1uV0AergXarISHSjG87d2ZUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jXPPRTQsYAOiznXv9UrUjtPnE7bzvzeykY1QyjDltS7Vmx4laKq2BFgEZen5tVeVMro/E+ZQ3JMCNakxaeETdTVue25KUaQCgPPJ2A/18uwGyPWJqB/f27ht382OxBTMHicGj4rmKrU4Y9JaEOmgyRvBNcJ8tM3//eDiOeU3c9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KspeoRd+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KspeoRd+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso41676695e9.3
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 01:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774340985; x=1774945785; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1q7SA6JVNH/3GR0PMp06OrljQaqllQySSw17pgvzXeA=;
        b=KspeoRd+7dIKavF1FQ4rEubM3W2rec3maQ5TPgAtOZ9LDy/DMjms4V/IUVw9BrwG87
         I+f8KnAzRfQ5kbL/V3kVHL+cpIlDymcmfc2PoOjugeBUcst94DV+pO6g3gcKzMqAfWee
         ZdDjyDTJAJoaNQC3TaDTmcP2lv/q8r4lKGo15YTWrEWScDpjhr+iqWSS4fCPWLJTJ3YC
         O85Mw1xBRWcdmqBUGlqtmOPjzEG28u4OHxyGGa2xSNEZ8wVhewOIlpExaWNJDWfPEv+0
         Xlrtpq1VrYMfxLoyAdpkr+QioCTUTRAul/0SAOo7jZ3xAk7LgTLDwpNm7HAixHqtyHjb
         B1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774340985; x=1774945785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1q7SA6JVNH/3GR0PMp06OrljQaqllQySSw17pgvzXeA=;
        b=hxqtei+mJXFyPwbSWsHCdkLl4DlAsUk3c1OQllB68/SKkk8WQn5XT9cSiVxGAi7ZbR
         qarVcUdfKNyyVjuWZz6fYwtaxo536Gtd6yNVIl5qgAn1SgFHex24alHKWa06vEbccb/h
         Mz/LehNJYS8ZI8zEiXIccPGs4a58bESLv/fQdwFp149NldG9A+BUGrqbTM0M5fA7aOIN
         YkocWfMoSsJ59uX7TxsU2rF428eA7Pc30Jl8V9lBA+YXzUE8WKQb4tl+W1xJ02nwiImQ
         adngEvcROixrsnX7kV3n7XoBPhuIyVWWwD7KeUWb9+4P0+18CC20jShDgkbwxJOKZtXj
         eNoA==
X-Gm-Message-State: AOJu0YwcAxLC1oTdV1zYpKYjKXMyBr96hq4OU0OMJpVo/PEdj3JqPgoK
	ZQqB3pxzo9ppU3AX0/oAU87lbxQzjydMGsXnngwmwjwwV7m1iDIvWFFb
X-Gm-Gg: ATEYQzxjl21gT0G+JGmcsiqpVlV2ZVeQMCgsaIYKzCzmu6lE/4TtaOPD2tlerKeZyYy
	1ySwTNwNCiuaIw+Xz0iO2dOwcklfga03PoymxTNiqpIXbdU3Vc4T5ItUujVEajV/jbft6bgUGPG
	TBbMCR+aNrBBqEptzTlBLXkR/cFPmj/rs4vKhJmIjL3U/EPza7yzTI6nK/VsuMjBtSnkRCQkdyC
	95a0Y4RGfSsXwmiGAaQbYnX2oziNSWqrF+R/ZNu1bs9idwGbbiT6vic2uf3+DdA2EKl4CDIws88
	pwvxCd4sDXC1pef5625wBWSmiEWeqSczfMGboQlWU0aI4kj49adfPv/t+Vi9RerzLTw3Im0QZ7G
	hakIOJvrzTyLLXisKoifJZHO3sT5VWJSnlZCgLUCPZ0COIb2jaLd/aTMSnIyMqACRhS1bK6wheg
	h+7TfcJSPci/TuZcuLwD8=
X-Received: by 2002:a05:600c:19d3:b0:487:1114:d431 with SMTP id 5b1f17b1804b1-4871114d548mr21893335e9.18.1774340985355;
        Tue, 24 Mar 2026 01:29:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48710fa0e35sm29836175e9.3.2026.03.24.01.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 01:29:44 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] .get_maintainer.ignore: add myself
Date: Tue, 24 Mar 2026 08:29:28 +0000
Message-ID: <20260324082928.3473789-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I don't want get_maintainer.pl to automatically print my email.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
Greg Kroah-Hartman, please, apply this (.get_maintainer.ignore is not listed
in MAINTAINERS)
---
 .get_maintainer.ignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.get_maintainer.ignore b/.get_maintainer.ignore
index e8d2269ba..60b6b2a37 100644
--- a/.get_maintainer.ignore
+++ b/.get_maintainer.ignore
@@ -1,6 +1,7 @@
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
+Askar Safin <safinaskar@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>

base-commit: c369299895a591d96745d6492d4888259b004a9e (mainline)
-- 
2.47.3

