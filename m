Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8937A6FB1;
	Tue,  5 Dec 2023 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1C8i6bUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16484C433C7;
	Tue,  5 Dec 2023 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747060;
	bh=CH8k+C5Ck+GT2anpNvk2VRpx3A3MVI8AwVKgPnXPBN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C8i6bUeW9Vv/aix9KD7iav/EmdPbbbvq+M4E9G/EB2O15cIJ7Cl4llM/uo+4RGzL
	 8aO9F/Gi/Py9I1A6D5wJh3qLGFKeTW48waHbOctoBzpcd4u3fkdyavKrnyVAsxT7vX
	 34CEV8QDATZqYXBgKcTlBbridxZiZ3QroX+2yTB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 036/107] parisc: Mark ex_table entries 32-bit aligned in assembly.h
Date: Tue,  5 Dec 2023 12:16:11 +0900
Message-ID: <20231205031533.734596646@linuxfoundation.org>
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

commit e11d4cccd094a7cd4696c8c42e672c76c092dad5 upstream.

Add an align statement to tell the linker that all ex_table entries and as
such the whole ex_table section should be 32-bit aligned in vmlinux and modules.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/assembly.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/include/asm/assembly.h b/arch/parisc/include/asm/assembly.h
index 75677b526b2b..74d17d7e759d 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -574,6 +574,7 @@
 	 */
 #define ASM_EXCEPTIONTABLE_ENTRY(fault_addr, except_addr)	\
 	.section __ex_table,"aw"			!	\
+	.align 4					!	\
 	.word (fault_addr - .), (except_addr - .)	!	\
 	.previous
 
-- 
2.43.0



