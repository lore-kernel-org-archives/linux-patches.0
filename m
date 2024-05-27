Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AEA1863F;
	Mon, 27 May 2024 19:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837418; cv=none; b=F7HdlfiApc0brVWfjwN+MfvAoW2PRepdyrnnTFV3ctXdyc/p0JYfOyiQ2Vh2U84I8H42C4cr1VJcoCsEgH3hKhLBSktYnE61sk/vbszlsHMI62uXtJCMS8RrRhQzDfRyq2GqqbZ4tAIn0sL2nno3MVYlbHsIA+m11pv3F4zNlvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837418; c=relaxed/simple;
	bh=Ng3uYXRnVYx32yAC9wuZdqhHEytI11frQC9FShPE8/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLjKOAMftrtJgUKtGYZnfMo8e7Y5YYM0VdNe8062Z0OQLKDWmXUzCXqPIKjCGhBaxJLkgLw+CYk0ESjVBdKUDiw9OMn6RS0SwcI+nFEU+tcJcH3tIlUYiDYjcGGKLgOGZ5u8ydSQh708MagwMDR234sourYFxic9PXw9uiJFK3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m51vizVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m51vizVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ABAC2BBFC;
	Mon, 27 May 2024 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837418;
	bh=Ng3uYXRnVYx32yAC9wuZdqhHEytI11frQC9FShPE8/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m51vizVLxUQA41vyPC4Da9GwXtebe/FRGlewKR9ARfDYeAr6LJZrbGy1w7LoCCwoH
	 kF17G0FS0hnu1jSZtpz9rOlTAVaX3oFVno3uN6DKLMfWe69H+NI4dsQTCbWiPi2kS/
	 /kuF7yWeiRooP4drRUkeTha412s/qxf1AiRCP5YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yao <wangyao@lemote.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 410/427] modules: Drop the .export_symbol section from the final modules
Date: Mon, 27 May 2024 20:57:37 +0200
Message-ID: <20240527185635.401324074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yao <wangyao@lemote.com>

[ Upstream commit 8fe51b45c5645c259f759479c374648e9dfeaa03 ]

Commit ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
forget drop the .export_symbol section from the final modules.

Fixes: ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
Signed-off-by: Wang Yao <wangyao@lemote.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/module.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index bf5bcf2836d81..89ff01a22634f 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -13,6 +13,7 @@ SECTIONS {
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
+		*(.export_symbol)
 	}
 
 	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
-- 
2.43.0



