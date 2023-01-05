Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534ED8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B624FC433F0;
	Thu,  5 Jan 2023 13:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672924049;
	bh=qluLUvDEEZhDwT0RZaesZh+vNgq8LpA6e4Hcp1dsIjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1L6yyYyMbotpth0XIXWKUmjaBT0EUp0QjezxQKVgbOfxlOB9WL92ZQnFqWiPu9EO
	 C+7OFuJ2p6Sa6Loz+6Kha07STiIf1jY62i+e9yFmRLusMbEwy+oVVrXap6FPtZSRyQ
	 2ePn1E4Qi8g6sjCPL1xS7/YMTdD/1mEdn6Gg90Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rickard x Andersson <rickaran@axis.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Martin Liska <mliska@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 217/251] gcov: add support for checksum field
Date: Thu,  5 Jan 2023 13:55:54 +0100
Message-Id: <20230105125344.790817468@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rickard x Andersson <rickaran@axis.com>

commit e96b95c2b7a63a454b6498e2df67aac14d046d13 upstream.

In GCC version 12.1 a checksum field was added.

This patch fixes a kernel crash occurring during boot when using
gcov-kernel with GCC version 12.2.  The crash occurred on a system running
on i.MX6SX.

Link: https://lkml.kernel.org/r/20221220102318.3418501-1-rickaran@axis.com
Fixes: 977ef30a7d88 ("gcov: support GCC 12.1 and newer compilers")
Signed-off-by: Rickard x Andersson <rickaran@axis.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Martin Liska <mliska@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -84,6 +84,7 @@ struct gcov_fn_info {
  * @version: gcov version magic indicating the gcc version used for compilation
  * @next: list head for a singly-linked list
  * @stamp: uniquifying time stamp
+ * @checksum: unique object checksum
  * @filename: name of the associated gcov data file
  * @merge: merge functions (null for unused counter type)
  * @n_functions: number of instrumented functions
@@ -96,6 +97,10 @@ struct gcov_info {
 	unsigned int version;
 	struct gcov_info *next;
 	unsigned int stamp;
+ /* Since GCC 12.1 a checksum field is added. */
+#if (__GNUC__ >= 12)
+	unsigned int checksum;
+#endif
 	const char *filename;
 	void (*merge[GCOV_COUNTERS])(gcov_type *, unsigned int);
 	unsigned int n_functions;


