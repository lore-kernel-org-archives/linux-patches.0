Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D25615C14B;
	Mon, 23 Dec 2024 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970580; cv=none; b=YmDYAIGbHRK3kRp+aZOXSXCHmbeqoGm6iBpC3wM7ctlKrUvpAzT1okj9tOxOm5AQXi6EceruX5Ul9+5GUn014qdqo3IB+mAMgf9z/JOM48MklvU/e/cOf4kZ4GK8g8Wg2jwuHu1VDvSt4xSn4gCRXF7Bq7qGHm/cSoWh8NHeiB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970580; c=relaxed/simple;
	bh=tTb+TFVTD0INmTuqT7feVXs3QrIOeNKG0WjwUye2hss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPnFdr6xE3D2IR/fwbcFmlESYZtAmgEhXoHmCzY8BHUPtWl+CRnUuau0KUQGxa3a8vEs+zFlspQP1rxVgPRNWKR5dO15gcj2wpuQLp+9J6Wev+EyO835bFgVW2QynvBZIEgg+r+2C1vJ55AHncs0rp5lkKGwEXf2OC8qJzvKiJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPzaJ6RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPzaJ6RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9F5C4CED3;
	Mon, 23 Dec 2024 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970579;
	bh=tTb+TFVTD0INmTuqT7feVXs3QrIOeNKG0WjwUye2hss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPzaJ6RDn4z9Wzu54HFJnmoEupULHvQZeuQfi5ZEyKH/bMumooJtm07NuZIy5h60B
	 yMOEAfBQy3IZ97ykzO1LiJSHUYcU2MohaDqEi2y2QgsWgOsao85wdo+nO71GisxITM
	 q8O01/pNycS6hjKU/BMzOr/Es62slfVYBImMEFHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weining Lu <luweining@loongson.cn>,
	Li Chen <chenli@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 096/116] selftests/bpf: Use asm constraint "m" for LoongArch
Date: Mon, 23 Dec 2024 16:59:26 +0100
Message-ID: <20241223155403.296882886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 29d44cce324dab2bd86c447071a596262e7109b6 upstream.

Currently, LoongArch LLVM does not support the constraint "o" and no plan
to support it, it only supports the similar constraint "m", so change the
constraints from "nor" in the "else" case to arch-specific "nmr" to avoid
the build error such as "unexpected asm memory constraint" for LoongArch.

Fixes: 630301b0d59d ("selftests/bpf: Add basic USDT selftests")
Suggested-by: Weining Lu <luweining@loongson.cn>
Suggested-by: Li Chen <chenli@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: stable@vger.kernel.org
Link: https://llvm.org/docs/LangRef.html#supported-constraint-code-list
Link: https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/LoongArch/LoongArchISelDAGToDAG.cpp#L172
Link: https://lore.kernel.org/bpf/20241219111506.20643-1-yangtiezhu@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/sdt.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/bpf/sdt.h
+++ b/tools/testing/selftests/bpf/sdt.h
@@ -102,6 +102,8 @@
 # define STAP_SDT_ARG_CONSTRAINT        nZr
 # elif defined __arm__
 # define STAP_SDT_ARG_CONSTRAINT        g
+# elif defined __loongarch__
+# define STAP_SDT_ARG_CONSTRAINT        nmr
 # else
 # define STAP_SDT_ARG_CONSTRAINT        nor
 # endif


