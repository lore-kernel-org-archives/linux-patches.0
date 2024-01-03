Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B1E1BDDE;
	Wed,  3 Jan 2024 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykPRDtWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5120C433C8;
	Wed,  3 Jan 2024 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301339;
	bh=dceIoPpqtYZ4RtClu5we23to+E5zVSZzu807ioZNxm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykPRDtWeftT2R6B+XLpddaBcmViCkD2dhHLMaYuMySbdjPD0lk7f3F6kkldarHRtj
	 0M7hWPbLpX97y5zzuouAAISXBfdlMg0l9IPic0cpSIqfUBrL4prPkhApgblrwAPJ9f
	 ZHIvM7H/ZwqML42TQUWPHSYcq1El+wTRVry5jM/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/100] linux/export: Ensure natural alignment of kcrctab array
Date: Wed,  3 Jan 2024 17:55:09 +0100
Message-ID: <20240103164908.112860386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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
index fe7e6ba918f10..29de29af9546c 100644
--- a/include/linux/export-internal.h
+++ b/include/linux/export-internal.h
@@ -12,6 +12,7 @@
 
 #define SYMBOL_CRC(sym, crc, sec)   \
 	asm(".section \"___kcrctab" sec "+" #sym "\",\"a\""	"\n" \
+	    ".balign 4"						"\n" \
 	    "__crc_" #sym ":"					"\n" \
 	    ".long " #crc					"\n" \
 	    ".previous"						"\n")
-- 
2.43.0



