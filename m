Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483A114A4E6;
	Tue, 20 Feb 2024 21:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464311; cv=none; b=AjY4nAsnoVKWfXkmBny2ynShKFIm4I/2YiGb/QBW3LUY1i8lbCxHTIAsF3rgVicvePhz5HYKG2LDziS7AwVhC7G7SAdYSErw74DVV72cWWsGn+QJBwyM4iBxmUOVk/vutqvG8FFiVKZHfbzcikylNM6CFrFtnm9bN7G3GjwLFRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464311; c=relaxed/simple;
	bh=N0wGQ+hUoPg3hDPvePFDE1nZh5GSQG+ulI2Yw6oROjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRZsMjIZlIqvrM3e5oyCH+TqSzS9imusv3/mvr19O9uBKHI+b01rEpXsbMVoPoHkpPDgmso8GFn9vXb2En9zFuKvIjDB27DRLUbKzu4qadnMtNT47b0gistKYSPeOXR3pk/b5aYgnX314V9CYf7HYToCggGnTShVSXzilxB8MzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLtmbICN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLtmbICN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA93C433C7;
	Tue, 20 Feb 2024 21:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464311;
	bh=N0wGQ+hUoPg3hDPvePFDE1nZh5GSQG+ulI2Yw6oROjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLtmbICNA3qHUJ9+DIsCHb2LMutcnegoKr1+0NN+rqBD2ANykFGD5tsEOqgwkyxBq
	 4UfUBVGk0CtJMxgUG1/o8N31TCNOdx1UQ4zi18xo0J0NDpHdu7Js0HkNXG94TKkrNM
	 0N/RYg7rLTvqRCxzvmBQeIl4ES69ztIojNVEPU2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 318/331] x86/efi: Drop alignment flags from PE section headers
Date: Tue, 20 Feb 2024 21:57:14 +0100
Message-ID: <20240220205648.214789171@linuxfoundation.org>
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

commit bfab35f552ab3dd6d017165bf9de1d1d20f198cc upstream.

The section header flags for alignment are documented in the PE/COFF
spec as being applicable to PE object files only, not to PE executables
such as the Linux bzImage, so let's drop them from the PE header.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-20-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -209,8 +209,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE		| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_EXECUTE		| \
-		IMAGE_SCN_ALIGN_16BYTES		# Characteristics
+		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
 	#
 	# The EFI application loader requires a relocation section
@@ -230,8 +229,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_DISCARDABLE	| \
-		IMAGE_SCN_ALIGN_1BYTES		# Characteristics
+		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
 
 #ifdef CONFIG_EFI_MIXED
 	#
@@ -249,8 +247,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_DISCARDABLE	| \
-		IMAGE_SCN_ALIGN_1BYTES		# Characteristics
+		IMAGE_SCN_MEM_DISCARDABLE	# Characteristics
 #endif
 
 	#
@@ -271,8 +268,7 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	IMAGE_SCN_CNT_CODE		| \
 		IMAGE_SCN_MEM_READ		| \
-		IMAGE_SCN_MEM_EXECUTE		| \
-		IMAGE_SCN_ALIGN_16BYTES		# Characteristics
+		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
 	.set	section_count, (. - section_table) / 40
 #endif /* CONFIG_EFI_STUB */


