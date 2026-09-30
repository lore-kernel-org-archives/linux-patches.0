Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785AA4F93A8;
	Wed, 30 Sep 2026 16:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786289; cv=none; b=kNgsxVyuL7EIPMw6zRkA5G7Z+xsffyT/ajYgQQOjQf7byiOx1Sf5sx3KEHSNzz0J/HgFLVqNalpIvpl1Kuh7cznCFp7qs8n4yA5tPUGaTQ+qxGJzpBupIbo8AYKGfvEpRoQg1oEe6JNEy0fUjzz/VOd31JHNpkNvzeVhMDR7JNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786289; c=relaxed/simple;
	bh=a94Q2Ph3JfVTQOqOT6iL0mQhxK8fo8PBjoTQQV+O5jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giP+BYCaNlh/L5Bjs1XpQHdWjAT4y5X33j+wizl+7wNB+EaBtpKvgUR//lM6GCOHCXQIe+VpESS0TGXM7eWsidu31Z31+4UoFzaTJo4jqiEbLWz7lk8ZJb9He8s2CHJQRmLD38iSvfbzC15VL2gXxlW7PHM51Ia2hhoIDUGaOAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZA+Usq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZA+Usq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894491F000FF;
	Wed, 30 Sep 2026 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786288;
	bh=EdsR6A1f1+ydrT1btePyRy/ATjZ8NeGgy0GvYKoJIMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZA+Usq/5o51RqdTFx2vW4eoLhn/Kk2aAdDTY3Cuzh489LS48IKNl9FrhcFIH3K9C
	 Cv+h8+m0SVpxWO/LwGHajbP3hYrVMPAYwf7PSuvR962HU8Hr1la8vFMUaJ9SAY/7Lb
	 sfFQkJcbExLgC6FtXFAXyktHynh9ddiCCcMROGZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 809/982] selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc
Date: Wed, 30 Sep 2026 17:25:45 +0200
Message-ID: <20260930152434.134426852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit d22c3e0088e85be8131f7a9283f759cdbb20726d ]

The current regex also matches symbols in modules, which makes the
test fail on s390 where name_show is present only once in the kernel,
but also multiple times in modules:

000001b1401cdc20 t name_show
000001b0c05e6c40 t name_show    [mdev]
000001b0c0495f30 t name_show    [i2c_core]

Fix this by changing the regular expression to only match the function
name.

Link: https://lore.kernel.org/all/20260909092954.2200558-1-svens@linux.ibm.com/

Fixes: 03b80ff8023a ("selftests/ftrace: Add new test case which checks non unique symbol")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
index bc9514428dbaf..07b1177c16344 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
@@ -6,7 +6,7 @@
 SYMBOL='name_show'
 
 # We skip this test on kernel where SYMBOL is unique or does not exist.
-if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}" /proc/kallsyms)" -le '1' ]; then
+if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}$" /proc/kallsyms)" -le '1' ]; then
 	exit_unsupported
 fi
 
-- 
2.53.0



