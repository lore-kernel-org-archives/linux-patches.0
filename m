Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06E469D
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 01:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jsperbeck.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHZkHVAZ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a92864859bso3680807b3.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 18:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698285455; x=1698890255; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WaJiW8ZqUlaOkGekwXpkEpdhjo6wn/mCZGxdsbuO8+0=;
        b=sHZkHVAZysdRafpsS4TDHf8cDr/qd0sJTWLy/AfT/q498+r/uZIvLsYEfL5Y80TVme
         oaTsF1u99LNrjZSwHU6OlWJaF1NtgAcTuvTCLkoyGSGFWUwwRXyubobTG+ZMxIRrfrHf
         R/Nhu4190T6bbilVAMfTEAJ9RpWz01jduJCkyN//6qNaSkVM+OOUBvN5DKQTMsiamss6
         ge0pwCskyOGzK9Zo+N1a7SVOY37WY/JqeJCgxVA72/aakInYXHzIKt0u/cfToIWNBn9v
         iiWj8pss7C3KKODDV2bxouTl9rjL/QvegpreoVbQtlOipp130Qg1GckJqbyRBUCrk3Vh
         jnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698285455; x=1698890255;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WaJiW8ZqUlaOkGekwXpkEpdhjo6wn/mCZGxdsbuO8+0=;
        b=Q/0GzSfZn7PyyNBc51RYv//+HmFli6GhTzf7kBDyDURxyGuNOjYYiGJQXZSRMQ8ddt
         yfoBowOOkieYpUZTwgBBI6raTWNhn3dK7rLrngkhXTnpNsi1aS3m9AXIbrnQFcoqYstQ
         oWuoGgntQsj6n2eyyqZWs0DNpjxFvT5JtgMBOfQbDWetiCv7bPDu0GupcltgGtI/Mi3Q
         lrwi0SfcyAnKGl5xpbMhceCFQzM2NzhRTMLww74gajbHZtAAJXhWq9/IqMjLMBnjzx4N
         0FDsupkxUF3H35Vzr8Q5HinQT/qIRIzRS951J4Qvt8DuNWUAWoq0rcZglvIyXqTn6/Uu
         u9Cw==
X-Gm-Message-State: AOJu0Yw13QjcRVEqI+Jza9xdk3FhqkjQlDxZ20nJqPFjdvQrZS5e0y8z
	wW79v7b1o2KE516bULEImsRHJ3mn84GZIjM=
X-Google-Smtp-Source: AGHT+IF4p1oV+2CqeMCMlv/k56PYabc6mXGjVHsj9UjxG+nv9+k46ltCltThkTDsUQgq23/EshVv1Y5T12VaYCM=
X-Received: from jsperbeck7.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:26dc])
 (user=jsperbeck job=sendgmr) by 2002:a81:4c8f:0:b0:59f:3cde:b33a with SMTP id
 z137-20020a814c8f000000b0059f3cdeb33amr145545ywa.6.1698285455478; Wed, 25 Oct
 2023 18:57:35 -0700 (PDT)
Date: Thu, 26 Oct 2023 01:57:28 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231026015728.1601280-1-jsperbeck@google.com>
Subject: [PATCH] objtool/x86: add missing embedded_insn check
From: John Sperbeck <jsperbeck@google.com>
To: gregkh@linuxfoundation.org
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, 
	peterz@infradead.org, stable@vger.kernel.org, jsperbeck@google.com
Content-Type: text/plain; charset="UTF-8"

When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
was backported to some stable branches, the check for dest->embedded_insn
in is_special_call() was missed.  Add it back in.

Signed-off-by: John Sperbeck <jsperbeck@google.com>
---


I think 6.1.y, 5.15.y, and 5.10.y are the LTS branches missing the
bit of code that this patch re-adds.


 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f8008ab31eef..cb363b507a32 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2478,7 +2478,7 @@ static bool is_special_call(struct instruction *insn)
 		if (!dest)
 			return false;
 
-		if (dest->fentry)
+		if (dest->fentry || dest->embedded_insn)
 			return true;
 	}
 

base-commit: 7d24402875c75ca6e43aa27ae3ce2042bde259a4
-- 
2.42.0.758.gaed0368e0e-goog

