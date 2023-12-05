Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08D66AA0;
	Tue,  5 Dec 2023 03:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1nHP6nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAF6C433C9;
	Tue,  5 Dec 2023 03:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746586;
	bh=rRyT1sQz1S13wSze56ONPrCUqFDKydoOpP0YRBxBcZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1nHP6nnKrSp+CFYOcL7e4CGAG+Y6lJpL77rwgUx3qQeTxkHscXLmAhqSBpVyrVIT
	 uttOeDv3mU3DmDpeMN/w+KL3brd+z5jJIY0A68JDWd1Lxu2OFswkhzwUATfA4k6++v
	 zJ9ZKNQaoht43NXoFFFpduYhRXybXytAzk/A2ULQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 057/134] parisc: Mark ex_table entries 32-bit aligned in uaccess.h
Date: Tue,  5 Dec 2023 12:15:29 +0900
Message-ID: <20231205031539.138770240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

commit a80aeb86542a50aa8521729ea4cc731ee7174f03 upstream.

Add an align statement to tell the linker that all ex_table entries and as
such the whole ex_table section should be 32-bit aligned in vmlinux and modules.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/uaccess.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -41,6 +41,7 @@ struct exception_table_entry {
 
 #define ASM_EXCEPTIONTABLE_ENTRY( fault_addr, except_addr )\
 	".section __ex_table,\"aw\"\n"			   \
+	".align 4\n"					   \
 	".word (" #fault_addr " - .), (" #except_addr " - .)\n\t" \
 	".previous\n"
 


