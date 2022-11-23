Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844651C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20D5C433C1;
	Wed, 23 Nov 2022 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194284;
	bh=NgcgWbgq+NHzd1MVDmZVgA4UGHow7sBhCZKIKBlN88o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKBoli9W+wE8IDtdw7bZHAx/SdEneLMQWhR+ejHPvEEAA85JVQDRsRBuGmk9tHV07
	 kDO9FRAYs3GtEEsOCiXcp2HwiWZGX88UZuDFDlXE3oNRR3Pjnrj7cL0LNbgjeW4pTE
	 qjwfTqsT/pJNIMMit3H9vAo349M/2UNpX8X9F+X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 034/114] cert host tools: Stop complaining about deprecated OpenSSL functions
Date: Wed, 23 Nov 2022 09:50:21 +0100
Message-Id: <20221123084553.199336838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6bfb56e93bcef41859c2d5ab234ffd80b691be35 upstream.

OpenSSL 3.0 deprecated the OpenSSL's ENGINE API.  That is as may be, but
the kernel build host tools still use it.  Disable the warning about
deprecated declarations until somebody who cares fixes it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/extract-cert.c |    7 +++++++
 scripts/sign-file.c    |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -23,6 +23,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -30,6 +30,13 @@
 #include <openssl/engine.h>
 
 /*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
+/*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
  * should use PKCS#7 instead.  Switching to the older PKCS#7 format restricts


