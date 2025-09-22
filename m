Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E600A2F2910;
	Mon, 22 Sep 2025 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569944; cv=none; b=s1Bn7CGcv9meEZ16V8LZteIovwi0q0gpSqPy/zfkCnOCEj2oj7+Jtkkv8GLORLD3bmKQc3aeZsUPzvIJ2NnHWkssBS3gLhYS8GtOsaNAhLtGk0IjVzcBtcX6lzMD9VfGXT9CTReK5mkWYSgaDBh61JAfDxL+F2yrmQv6/Qf5ZzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569944; c=relaxed/simple;
	bh=lNnUsJKVchHS+lR4ocjt1NxRiL3R74DVus5C8UtAW2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJLRIxCunQpCSEbEeBrcsT61ocPovzZKA8elKpggdIX+sZWrlCQ4/MWICGN872Xwp3u+pJzo/Hu9BPyTb7GJpv0OYaYNh+AeJeVLOLmU/i1JYucdT6hB3YF9apMqFhZHJMFThqsddocrhfE90s8EECtMaR2zYtdFPPNXWE9UNqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYZhtjjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYZhtjjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74723C4CEF0;
	Mon, 22 Sep 2025 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569943;
	bh=lNnUsJKVchHS+lR4ocjt1NxRiL3R74DVus5C8UtAW2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYZhtjjMrPUL6N31OkwYcatPzxaPxfOOtznr6Gg+gDROjCt4HXWZdGbcSXU56Fkzw
	 Shba3Ao7lqoI8JETt+MMYkMfWLDVXaXU4rb52BgE1xR6TIJi/i07GQQG92BxDhPQ1V
	 GwIIzNJKxQ63qdZTDwNAbwAN0znFyS8+UyPYPl9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 050/105] LoongArch: Check the return value when creating kobj
Date: Mon, 22 Sep 2025 21:29:33 +0200
Message-ID: <20250922192410.226071731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 51adb03e6b865c0c6790f29659ff52d56742de2e upstream.

Add a check for the return value of kobject_create_and_add(), to ensure
that the kobj allocation succeeds for later use.

Cc: stable@vger.kernel.org
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/env.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/kernel/env.c
+++ b/arch/loongarch/kernel/env.c
@@ -109,6 +109,8 @@ static int __init boardinfo_init(void)
 	struct kobject *loongson_kobj;
 
 	loongson_kobj = kobject_create_and_add("loongson", firmware_kobj);
+	if (!loongson_kobj)
+		return -ENOMEM;
 
 	return sysfs_create_file(loongson_kobj, &boardinfo_attr.attr);
 }


