Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AB6FB1;
	Tue,  5 Dec 2023 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP0jba/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED1C433C8;
	Tue,  5 Dec 2023 03:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747088;
	bh=J1WuRZzCXI9Plrk2SirEP+aiz3FUmx4lHnVCY9E4CTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP0jba/0lHXiX6R+x7P4v5o2qj7aMO95+pR20BWS5xEzkRXSts2fwwYqLZyu1xbEO
	 cPm/i/+p+OwEB7APctrpayh/dzQUkEPePlDWpzVD7qbzRroErfS0fDbl8L3Oa0tl4k
	 wFqFsaJ3rRFMt+xdBiOXPqILu690VA+E1kP4Aauk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 037/107] parisc: Mark ex_table entries 32-bit aligned in uaccess.h
Date: Tue,  5 Dec 2023 12:16:12 +0900
Message-ID: <20231205031533.778801211@linuxfoundation.org>
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

commit a80aeb86542a50aa8521729ea4cc731ee7174f03 upstream.

Add an align statement to tell the linker that all ex_table entries and as
such the whole ex_table section should be 32-bit aligned in vmlinux and modules.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/uaccess.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index 2bf660eabe42..4165079898d9 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -41,6 +41,7 @@ struct exception_table_entry {
 
 #define ASM_EXCEPTIONTABLE_ENTRY( fault_addr, except_addr )\
 	".section __ex_table,\"aw\"\n"			   \
+	".align 4\n"					   \
 	".word (" #fault_addr " - .), (" #except_addr " - .)\n\t" \
 	".previous\n"
 
-- 
2.43.0



