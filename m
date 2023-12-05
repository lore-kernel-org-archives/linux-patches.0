Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C36FB1;
	Tue,  5 Dec 2023 03:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5QOYr7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07540C433C8;
	Tue,  5 Dec 2023 03:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747124;
	bh=+SodoJYQY64nHNF3+S6yzKgSsSPsBFtZAAua1sON5oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5QOYr7apGQHYXsQxh2OSOENJrxEHhGxg0hFD0XcxvAF5qcrkYTD1lTmrVV+AGyCs
	 HL8ScssVQdK5L+AZI+qJMip5WhrBHv2J1D9TqMRwrbw0hqtaOi8gAeNur2LiDVQcLH
	 xLu6FbKdVV5nELHAIphgui4kV2o4MIIapSwj47Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 043/107] parisc: Mark altinstructions read-only and 32-bit aligned
Date: Tue,  5 Dec 2023 12:16:18 +0900
Message-ID: <20231205031534.065909290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 33f806da2df68606f77d7b892cd1298ba3d463e8 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/alternative.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/alternative.h b/arch/parisc/include/asm/alternative.h
index 1ed45fd085d3..1eb488f25b83 100644
--- a/arch/parisc/include/asm/alternative.h
+++ b/arch/parisc/include/asm/alternative.h
@@ -34,7 +34,8 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end,
 
 /* Alternative SMP implementation. */
 #define ALTERNATIVE(cond, replacement)		"!0:"	\
-	".section .altinstructions, \"aw\"	!"	\
+	".section .altinstructions, \"a\"	!"	\
+	".align 4				!"	\
 	".word (0b-4-.)				!"	\
 	".hword 1, " __stringify(cond) "	!"	\
 	".word " __stringify(replacement) "	!"	\
@@ -44,7 +45,8 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end,
 
 /* to replace one single instructions by a new instruction */
 #define ALTERNATIVE(from, to, cond, replacement)\
-	.section .altinstructions, "aw"	!	\
+	.section .altinstructions, "a"	!	\
+	.align 4			!	\
 	.word (from - .)		!	\
 	.hword (to - from)/4, cond	!	\
 	.word replacement		!	\
@@ -52,7 +54,8 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end,
 
 /* to replace multiple instructions by new code */
 #define ALTERNATIVE_CODE(from, num_instructions, cond, new_instr_ptr)\
-	.section .altinstructions, "aw"	!	\
+	.section .altinstructions, "a"	!	\
+	.align 4			!	\
 	.word (from - .)		!	\
 	.hword -num_instructions, cond	!	\
 	.word (new_instr_ptr - .)	!	\
-- 
2.43.0



