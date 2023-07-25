Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C57C1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F4C433C8;
	Tue, 25 Jul 2023 11:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283186;
	bh=F+Rwp7lGlZlOnx5BNDwDpIm65Wxqx7yEi8JJ53nH0vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoNnizZLVLBddldLzwElgffsI4Gn2gAP3IS/rCp2bm80pahnKeSENtklD04wKWCt2
	 R4IA9K7cnNzgPLLaempvS22XULXLHMK7j5eB40twXht5dZOswPTZD321MuWedCQUOY
	 WNm/OD6EPxrcn6qzSoKCiPwkaIZyNE/R8IETWk6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.1 170/183] scripts/kallsyms: update the usage in the comment block
Date: Tue, 25 Jul 2023 12:46:38 +0200
Message-ID: <20230725104513.880881983@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

commit 79549da691edd4874c19d99c578a134471817c47 upstream.

Commit 010a0aad39fc ("kallsyms: Correctly sequence symbols when
CONFIG_LTO_CLANG=y") added --lto-clang, and updated the usage()
function, but not the comment. Update it in the same way.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -6,7 +6,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  * Usage: kallsyms [--all-symbols] [--absolute-percpu]
- *                         [--base-relative] in.map > out.S
+ *                         [--base-relative] [--lto-clang] in.map > out.S
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might


