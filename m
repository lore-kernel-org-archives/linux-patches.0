Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCC31C289;
	Wed,  3 Jan 2024 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4yu1agB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6747C433C7;
	Wed,  3 Jan 2024 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302037;
	bh=r/GDLlDE0z3hslXUT0A8tqmH9WQOmjqPQK1wSPX3SBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4yu1agBLC9chhYJbxjnccS9R1cdiu0HFKoz2Y47heZG13GD8zoXoFNsITsM9z2/r
	 EKkK7/6K66DcsO7Yia7tgQNVrh1KBhnS8zjXHvsdWkJZuw2iJclDGL4p4+Lks4i+FK
	 CRRYTdGYh6xDnE/W4DAv42koxxuyQMttC2rIxwSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/49] linux/export: Ensure natural alignment of kcrctab array
Date: Wed,  3 Jan 2024 17:55:47 +0100
Message-ID: <20240103164839.169890893@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 753547de0daecbdbd1af3618987ddade325d9aaa ]

The ___kcrctab section holds an array of 32-bit CRC values.
Add a .balign 4 to tell the linker the correct memory alignment.

Fixes: f3304ecd7f06 ("linux/export: use inline assembler to populate symbol CRCs")
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/export-internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/export-internal.h b/include/linux/export-internal.h
index b842aeecef791..5280194777340 100644
--- a/include/linux/export-internal.h
+++ b/include/linux/export-internal.h
@@ -66,6 +66,7 @@
 
 #define SYMBOL_CRC(sym, crc, sec)   \
 	asm(".section \"___kcrctab" sec "+" #sym "\",\"a\""	"\n" \
+	    ".balign 4"						"\n" \
 	    "__crc_" #sym ":"					"\n" \
 	    ".long " #crc					"\n" \
 	    ".previous"						"\n")
-- 
2.43.0



