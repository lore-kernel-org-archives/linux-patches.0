Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289E17A2EA;
	Mon, 22 Sep 2025 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569579; cv=none; b=LJryvzByOc9OwNd9z+aTuv8FDN6OPnOXFKZ80nfWlkJ1ZKbdwJxy+UMNjEhEOx8cabWLZA8lTxcC1VIVWPEm+WQvxWjBNi4Pg7EjsaYB+C5n2sZX4bNwV0lRowQLLqGIY8Ueovfw5ZTys9uM6MptYwsyk2UAMsclI1U6V8/ua44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569579; c=relaxed/simple;
	bh=zaBkIEjL/G0NMRpwVPoGg461ywyiIdHbQ8s9Fb713pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf4mNrn81OCAgpSmzP4+Mk/mhDwoxERRf+JlnxbecFcHSe8PoARhrSwIEjLpZb7uboiMNcgn6BiEIEZCQIIKgrIyg1mls+8J62/6oIiXV0ga41ClgqfHE4UEOE/B8eS9rKZu18Ns5XHtqde3h6Wy2SLatDRZWtUPnwtNCiF8tQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNAtsRQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNAtsRQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF2BC4CEF0;
	Mon, 22 Sep 2025 19:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569579;
	bh=zaBkIEjL/G0NMRpwVPoGg461ywyiIdHbQ8s9Fb713pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNAtsRQAemuF6Bh6oAjoNDWRzROyWI6IPXMuUPwTfiLmG1O95Fb0QjVV/VIOZFn9+
	 BEduo2X921lneuuoG/GPwIK2dVcuF0dgZddouE/IrET2QAIMS04BGRd4AdLWJefpNP
	 y0FNGV36789JgshHUCatQJySBmdQk1jmpKhzyJtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 26/61] LoongArch: Check the return value when creating kobj
Date: Mon, 22 Sep 2025 21:29:19 +0200
Message-ID: <20250922192404.271285305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,6 +70,8 @@ static int __init boardinfo_init(void)
 	struct kobject *loongson_kobj;
 
 	loongson_kobj = kobject_create_and_add("loongson", firmware_kobj);
+	if (!loongson_kobj)
+		return -ENOMEM;
 
 	return sysfs_create_file(loongson_kobj, &boardinfo_attr.attr);
 }


