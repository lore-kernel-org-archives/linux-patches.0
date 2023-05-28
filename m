Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB773611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CCAC433EF;
	Sun, 28 May 2023 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301605;
	bh=3ntl2lY/aek3N/AIFT3IKVBA0Vwt1ss6CL0VEupRMfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GcSfbuzNJ4UeAnPVX0RPuALT1QA0H2dYMAfWeMqs1NIrY4alAn5eVtUBCKYlkwIX
	 /U6QuG/yd/AwwENs4X61glkFdmO7tkhpz1ABlpWyCBsY609JdTj1o6QQNAOl7LbKDb
	 s7TLKOQaiMgmcdthlotCyKutKV6M/STgpCqIxy/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@mellanox.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/132] lib/string_helpers: Introduce string_upper() and string_lower() helpers
Date: Sun, 28 May 2023 20:10:35 +0100
Message-Id: <20230528190836.585596733@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 58eeba0bdb52afe5c18ce2a760ca9fe2901943e9 ]

Provide the helpers for string conversions to upper and lower cases.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 3c0f4f09c063 ("usb: gadget: u_ether: Fix host MAC address case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string_helpers.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index d23c5030901a2..0618885b3edc7 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_STRING_HELPERS_H_
 #define _LINUX_STRING_HELPERS_H_
 
+#include <linux/ctype.h>
 #include <linux/types.h>
 
 struct file;
@@ -72,6 +73,20 @@ static inline int string_escape_str_any_np(const char *src, char *dst,
 	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, only);
 }
 
+static inline void string_upper(char *dst, const char *src)
+{
+	do {
+		*dst++ = toupper(*src);
+	} while (*src++);
+}
+
+static inline void string_lower(char *dst, const char *src)
+{
+	do {
+		*dst++ = tolower(*src);
+	} while (*src++);
+}
+
 char *kstrdup_quotable(const char *src, gfp_t gfp);
 char *kstrdup_quotable_cmdline(struct task_struct *task, gfp_t gfp);
 char *kstrdup_quotable_file(struct file *file, gfp_t gfp);
-- 
2.39.2



