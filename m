Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4632F15D5D8;
	Mon, 29 Jan 2024 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548421; cv=none; b=GAQHXmX31MkjW/vJSvXcWE7We7hIXNfKx7RbFOrESvCpSprV1Z5kMaGMhpGJjfQFsr9CGs9NXR48AlXn3+YqFdkpShs49OwkSeqn1zPcyXUhyXGl9eHnnBBz1UTy6MSOqC4tocrfXqaquSy1pQJa1Gh+JmRlzAl8NgW9p4H1yYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548421; c=relaxed/simple;
	bh=vFko/+BTPMMhlTgjqzntZvxqnf2hPxD/8ZPIixqsLNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7RwntYmXGUKFjcNnVZJFiAwMFa9JVJ1z+qIS3TWaYmSSnOY9khqt3oQdrowINiavdk7mQ3ukykbx14B7ULkIVy7BzrH6+rZ/QzKe4KyrYMG3UMN6Y6Zzw59f5ZSn0kjaM0CeTyc1WXdeEiWf45to1aotKA8zNXV+xZxOF6f2+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsoJKrPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsoJKrPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2CCC433F1;
	Mon, 29 Jan 2024 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548421;
	bh=vFko/+BTPMMhlTgjqzntZvxqnf2hPxD/8ZPIixqsLNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsoJKrPWE3YkMS0iYWZxh1kpk1ri2T+WNuJqWzD27ABy9X03iE65GeaDx4OM9o04A
	 3xT24ZvX+rQkfMsHayjG46zFscOcCdjVktKadsp5clFqTiDJCfRvpH4+RWnTLDqSaT
	 QvH//3OVxqGxVwRcR1A7i3KhIY7QLIjhpk0eULrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/331] docs: sparse: add sparse.rst to toctree
Date: Mon, 29 Jan 2024 09:01:06 -0800
Message-ID: <20240129170015.035200270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit c9ad95adc096f25004d4192258863806a68a9bc8 ]

Add sparst.rst to toctree, so it can be part of the docs build.

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Suggested-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20230902052512.12184-4-minhuadotchen@gmail.com
Stable-dep-of: c48a7c44a1d0 ("docs: kernel_feat.py: fix potential command injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../translations/zh_TW/dev-tools/index.rst    | 40 +++++++++++++++++++
 Documentation/translations/zh_TW/index.rst    |  2 +-
 2 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/translations/zh_TW/dev-tools/index.rst

diff --git a/Documentation/translations/zh_TW/dev-tools/index.rst b/Documentation/translations/zh_TW/dev-tools/index.rst
new file mode 100644
index 000000000000..8f101db5a07f
--- /dev/null
+++ b/Documentation/translations/zh_TW/dev-tools/index.rst
@@ -0,0 +1,40 @@
+.. include:: ../disclaimer-zh_TW.rst
+
+:Original: Documentation/dev-tools/index.rst
+:Translator: Min-Hua Chen <minhuadotchen@gmail.com>
+
+============
+內核開發工具
+============
+
+本文檔是有關內核開發工具文檔的合集。
+目前這些文檔已經整理在一起，不需要再花費額外的精力。
+歡迎任何補丁。
+
+有關測試專用工具的簡要概述，參見
+Documentation/dev-tools/testing-overview.rst
+
+.. class:: toc-title
+
+	   目錄
+
+.. toctree::
+   :maxdepth: 2
+
+   sparse
+
+Todolist:
+
+ - coccinelle
+ - kcov
+ - ubsan
+ - kmemleak
+ - kcsan
+ - kfence
+ - kgdb
+ - kselftest
+ - kunit/index
+ - testing-overview
+ - gcov
+ - kasan
+ - gdb-kernel-debugging
diff --git a/Documentation/translations/zh_TW/index.rst b/Documentation/translations/zh_TW/index.rst
index d1cf0b4d8e46..ffcaf3272fe7 100644
--- a/Documentation/translations/zh_TW/index.rst
+++ b/Documentation/translations/zh_TW/index.rst
@@ -55,11 +55,11 @@ TODOList:
    :maxdepth: 1
 
    process/license-rules
+   dev-tools/index
 
 TODOList:
 
 * doc-guide/index
-* dev-tools/index
 * dev-tools/testing-overview
 * kernel-hacking/index
 * rust/index
-- 
2.43.0



