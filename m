Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772678F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE994C433C7;
	Sun, 16 Jul 2023 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540397;
	bh=dGwZ3X4u0r5uuysRh/4+zBwfddZLS52aHSW5pleXJRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk6+NnOD8vqy2pCyN8MdcifaKBFIg9KwUqniRBV6IQv+t6DLZzIHyBPXJRg/1X2AB
	 jsRSbyy+/9+NdnMS//yE6L366o+Jslf3wzeUYNXuxtVoItmMBP9KxftLVSC/+BzeV3
	 0FOL3GzW96ORAu0sAertMliFMlIn39xNuGMXKGOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 341/591] modpost: fix off by one in is_executable_section()
Date: Sun, 16 Jul 2023 21:48:00 +0200
Message-ID: <20230716194932.730342846@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3a3f1e573a105328a2cca45a7cfbebabbf5e3192 ]

The > comparison should be >= to prevent an out of bounds array
access.

Fixes: 52dc0595d540 ("modpost: handle relocations mismatch in __ex_table.")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9e370e77f52d1..e6be7fc2625fd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1297,7 +1297,7 @@ static void default_mismatch_handler(const char *modname, struct elf_info *elf,
 
 static int is_executable_section(struct elf_info* elf, unsigned int section_index)
 {
-	if (section_index > elf->num_sections)
+	if (section_index >= elf->num_sections)
 		fatal("section_index is outside elf->num_sections!\n");
 
 	return ((elf->sechdrs[section_index].sh_flags & SHF_EXECINSTR) == SHF_EXECINSTR);
-- 
2.39.2



