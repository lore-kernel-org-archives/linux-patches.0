Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ECC1FDA89;
	Mon, 22 Sep 2025 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569727; cv=none; b=sbbEPYHdtjnggsihxde5s3CfNYLFj82HCC5j+7tfgfNTEm+Z/3FHRZV6/PCdZD7Yy6tPFZZ7fqjZ+Hfiykanzafxhh0MRLFZujluJZG6vHjKXPk98LKGM7rzOSrpGAio7hScTk3d231+5VRQ4SGrg0y3azVD7/S8rr8DzzFv9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569727; c=relaxed/simple;
	bh=MKIdmqTMbpv6dKcnEuo5pR94u7BxEI0NrWbvKEeskic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxpZHG42GQcYy5MYhPl36Zvg3oBgLsUgY6qWd7U/yLHKLgsGN8fkBGO4OLvCZmRjXUfYJ4eK6mFJ0tPxPl4M8SOnRRIVrLjiMfJ0afQ0fOXP3sqXvbCXGkCBYr7qeDGiY3kf/51HwCAfeRLt+6ez7VB+GCadMT1J5g+1394YPIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYK6jMJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYK6jMJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0E0C4CEF0;
	Mon, 22 Sep 2025 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569727;
	bh=MKIdmqTMbpv6dKcnEuo5pR94u7BxEI0NrWbvKEeskic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYK6jMJ8i1V9gogQBLCcmbK6P2Dg+NeCtlnpem5RpF8kux8Kmh3Kb98KbqXgARCLf
	 WMQNpAYknt9L8+qf/RVe2ARk6+AFUwRS/ZKQcxzUEcK5+yb5e9/dzNs8FQRkAqq0OU
	 hk16z174r1YY9mYrzOjoXj9y77kfh/dx+55Y7bxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 34/70] LoongArch: Check the return value when creating kobj
Date: Mon, 22 Sep 2025 21:29:34 +0200
Message-ID: <20250922192405.521818108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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
@@ -72,6 +72,8 @@ static int __init boardinfo_init(void)
 	struct kobject *loongson_kobj;
 
 	loongson_kobj = kobject_create_and_add("loongson", firmware_kobj);
+	if (!loongson_kobj)
+		return -ENOMEM;
 
 	return sysfs_create_file(loongson_kobj, &boardinfo_attr.attr);
 }


