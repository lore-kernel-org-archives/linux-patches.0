Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE39446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22665C433C8;
	Sun, 13 Aug 2023 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962543;
	bh=A87liQJZt1QETltZwySfFJ9Bx67cktbkLe9ZLwz4Ghs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYr5ybYxQ7SIlx6+WkN17em9+d1ykr4iAvFx7T5KoRQwNE6u4B66C4r6r6B5kgWlK
	 XybELEZpxTq5BiBa5gqjZkhSaKGT5Jk06feWid63nBsYmaXb+ZE0jplJWtLlxF+7P0
	 Yi1QOCeGIdpRl2JX7SM5xYs3hiroq2nwQ6/b5+qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 068/149] x86/speculation: Add cpu_show_gds() prototype
Date: Sun, 13 Aug 2023 23:18:33 +0200
Message-ID: <20230813211720.833664748@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit a57c27c7ad85c420b7de44c6ee56692d51709dda upstream.

The newly added function has two definitions but no prototypes:

drivers/base/cpu.c:605:16: error: no previous prototype for 'cpu_show_gds' [-Werror=missing-prototypes]

Add a declaration next to the other ones for this file to avoid the
warning.

Fixes: 8974eb588283b ("x86/speculation: Add Gather Data Sampling mitigation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/all/20230809130530.1913368-1-arnd%40kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpu.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -72,6 +72,8 @@ extern ssize_t cpu_show_retbleed(struct
 				 struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_spec_rstack_overflow(struct device *dev,
 					     struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_gds(struct device *dev,
+			    struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


