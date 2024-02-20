Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF6414A4E6;
	Tue, 20 Feb 2024 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464327; cv=none; b=pizJfXNSGqcoDj/cKmjR8oySsNi8a89p4eydG7NO8SCrmhA1PeJa2jJ4ln5b4+tR1zyTIUE0IR95aIc5ly5x3+ltpVFTIEdbS7mafK/nP8S/S3YVAHnRH6UuDJe41PGcHY20Ewd3b9B/GsEG3Op7v/LWArzirh8C5TZlkQAeI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464327; c=relaxed/simple;
	bh=qtj4be/Xp8sIvHyEONNYgOHaTQvTnbvPAz0AEbLopkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0cMqoyrMLXamc8qmBSi0jozNvgNVXMYdMnNd6Bh8pIeFO+QFwTPxPKwcNWvIsgoSeKIS3RFGSA+hAhLqTh5YilqnGxhGh6ULWT6f8a827teJZr6U1FaoMWnYew3bCbj3MrpE5R4obSXYZhrJdiUNUAij3AiV4UJfY6BCp9vKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agw9fVXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agw9fVXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0DCC433F1;
	Tue, 20 Feb 2024 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464326;
	bh=qtj4be/Xp8sIvHyEONNYgOHaTQvTnbvPAz0AEbLopkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agw9fVXZaTV8KRF2euc2CwZkEQWE53jhBdGn328/J8a0rq1GmqqAWZc1gRdoUNBqQ
	 VM/6rdjw5p7axy9LENrt9bFUNd/DlloqM8NOyzqjdnXQtHea/hun5x1BsbMOsp5rzr
	 ZBo4nAwA05nh5S4/BQfjSZ4a0HFTzi5irYfQTnnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 322/331] x86/boot: Drop references to startup_64
Date: Tue, 20 Feb 2024 21:57:18 +0100
Message-ID: <20240220205648.343348537@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit b618d31f112bea3d2daea19190d63e567f32a4db upstream.

The x86 boot image generation tool assign a default value to startup_64
and subsequently parses the actual value from zoffset.h but it never
actually uses the value anywhere. So remove this code.

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-25-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/Makefile      |    2 +-
 arch/x86/boot/tools/build.c |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -89,7 +89,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vm
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|efi32_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|efi32_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -60,7 +60,6 @@ static unsigned long efi64_stub_entry;
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
 static unsigned long kernel_info;
-static unsigned long startup_64;
 static unsigned long _end;
 
 /*----------------------------------------------------------------------*/
@@ -264,7 +263,6 @@ static void efi_stub_defaults(void)
 	efi_pe_entry = 0x10;
 #else
 	efi_pe_entry = 0x210;
-	startup_64 = 0x200;
 #endif
 }
 
@@ -340,7 +338,6 @@ static void parse_zoffset(char *fname)
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
 		PARSE_ZOFS(p, kernel_info);
-		PARSE_ZOFS(p, startup_64);
 		PARSE_ZOFS(p, _end);
 
 		p = strchr(p, '\n');


