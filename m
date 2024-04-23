Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEAF143C45;
	Tue, 23 Apr 2024 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908674; cv=none; b=mE6/zzrKWBiWy/N+gMadFEFBRhEZN1FCrltn3bEcO9SEYcJfdZvd/gthUyjP+lo03XsySe/8FPIyWhj5t4cbpNiFu1rWADhyyltpQSVaiuNgYdSipJY2Ftjm3bD33fbQ7EjseK2UhchZL6QwvDW/jTYUyhJVrGHzcEC+4vhkKPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908674; c=relaxed/simple;
	bh=PRecqQqoI/JA1/cPpPcLdF8iEszhBTfSyCQ9YyGSc7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyYcMX35WhobxWPkXDBMO5Vaoe/C7y3j4CyWZ1S1fGwMwKtsHSxGyQNrGNnsjL7RtE6UZKR079/Ry5thTLNHADGT6/K2fHyTwzLBTD7Pru8B3yM8byRCvH/fTVBdmF2rjIfR5b4D/Ziw25ViS8jhuQmrHvqD5uBECSsclqW/NOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5yQ8USf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5yQ8USf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEDAC116B1;
	Tue, 23 Apr 2024 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908674;
	bh=PRecqQqoI/JA1/cPpPcLdF8iEszhBTfSyCQ9YyGSc7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5yQ8USf5EhoUVCOmKBzMJ3ZEVqNpttnHqAll4FxWc29Bs6Ls/5OcZHOx+ldATVoC
	 L/DK0TWmAm2ZlEf6vErdooLbvn3DEFLzJQ5baP36IdsuXJBJf19eYBagk6ZifD1LHP
	 P5Myzb+2DEEZ+lAKdHGV9tbwO5P1zr6HHPFpamqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 014/141] x86/efi: Drop alignment flags from PE section headers
Date: Tue, 23 Apr 2024 14:38:02 -0700
Message-ID: <20240423213853.810073642@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit bfab35f552ab3dd6d017165bf9de1d1d20f198cc upstream ]

The section header flags for alignment are documented in the PE/COFF
spec as being applicable to PE object files only, not to PE executables
such as the Linux bzImage, so let's drop them from the PE header.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-20-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -208,8 +208,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE		| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_EXECUTE		| \
-		IMAGE_SCN_ALIGN_16BYTES		# Characteristics
+		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
 	#
 	# The EFI application loader requires a relocation section
@@ -229,8 +228,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_DISCARDABLE	| \
-		IMAGE_SCN_ALIGN_1BYTES		# Characteristics
+		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
 
 #ifdef CONFIG_EFI_MIXED
 	#
@@ -248,8 +246,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_DISCARDABLE	| \
-		IMAGE_SCN_ALIGN_1BYTES		# Characteristics
+		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
 #endif
 
 	#
@@ -270,8 +267,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE		| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_EXECUTE		| \
-		IMAGE_SCN_ALIGN_16BYTES		# Characteristics
+		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
 	.set	section_count, (. - section_table) / 40
 #endif /* CONFIG_EFI_STUB */


