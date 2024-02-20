Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E7F152DE5;
	Tue, 20 Feb 2024 21:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463736; cv=none; b=SypWiGOFpLiDDkIWwJy1OdsHMWRhgMfsCTURQsq14KckvPiqosa36sH7MlW6j/Tc4M0487vNVvvF1NPva1onVd4rB6exPB7hb5jUZSQ2SCH2vkLDQrgrSyEXeaD/abqIPj0XMN/4+ZJJLrAnpDWQ5vSE2d93UEH9o3TO42fGMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463736; c=relaxed/simple;
	bh=NPijuwwDEWvQOy2YPEyQkw3gYcFjJsyFwSSPdVLHYVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qzf2LwBIO2h8xFinf2FkN2DQqp7rIexjrKp1BUv5hkF9VOV6+zBoIZDTpSAfISdAn0HM77ghqeclbAaRvivOETmkH1MZByLT9VX2Pe+ceO+Gd01NqzwBddRzNYSraFOHLC9gto67HUJTPiyhRAFehI653Snx2ZVb0XWzK7Lrk0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4p6VcUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4p6VcUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96847C433C7;
	Tue, 20 Feb 2024 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463736;
	bh=NPijuwwDEWvQOy2YPEyQkw3gYcFjJsyFwSSPdVLHYVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4p6VcUwCuR4dFnV81HUWkGWP9oxdNz6NtuiOVYPQ7Mt5FpoSgu2nLhJfmJKIxmNu
	 uYuR4Uq4HHCpxhtx9MoJer+36+PCObCYIo2E2Jw68Ydc4Qy9QEO7Y5Q+uE5pNnHnAl
	 S7Uz0kh2QpGd78Px1TOJJnW2JHzk1yGMpGw7nvfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 136/331] linux/init: remove __memexit* annotations
Date: Tue, 20 Feb 2024 21:54:12 +0100
Message-ID: <20240220205641.841000900@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 6a4e59eeedc3018cb57722eecfcbb49431aeb05f upstream.

We have never used __memexit, __memexitdata, or __memexitconst.

These were unneeded.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    6 ------
 include/linux/init.h              |    3 ---
 scripts/mod/modpost.c             |   15 +++------------
 3 files changed, 3 insertions(+), 21 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -356,7 +356,6 @@
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
-	MEM_KEEP(exit.data*)						\
 	*(.data.unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
@@ -521,7 +520,6 @@
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
 		MEM_KEEP(init.rodata)					\
-		MEM_KEEP(exit.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -574,7 +572,6 @@
 		*(.ref.text)						\
 		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text*)						\
-	MEM_KEEP(exit.text*)						\
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -714,13 +711,10 @@
 	*(.exit.data .exit.data.*)					\
 	*(.fini_array .fini_array.*)					\
 	*(.dtors .dtors.*)						\
-	MEM_DISCARD(exit.data*)						\
-	MEM_DISCARD(exit.rodata*)
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
 	*(.text.exit)							\
-	MEM_DISCARD(exit.text)
 
 #define EXIT_CALL							\
 	*(.exitcall.exit)
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -89,9 +89,6 @@
 						  __latent_entropy
 #define __meminitdata    __section(".meminit.data")
 #define __meminitconst   __section(".meminit.rodata")
-#define __memexit        __section(".memexit.text") __exitused __cold notrace
-#define __memexitdata    __section(".memexit.data")
-#define __memexitconst   __section(".memexit.rodata")
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -798,7 +798,7 @@ static void check_section(const char *mo
 #define ALL_INIT_TEXT_SECTIONS \
 	".init.text", ".meminit.text"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text", ".memexit.text"
+	".exit.text"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
@@ -806,10 +806,9 @@ static void check_section(const char *mo
 	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
 #define ALL_XXXINIT_SECTIONS MEM_INIT_SECTIONS
-#define ALL_XXXEXIT_SECTIONS MEM_EXIT_SECTIONS
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
-#define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
+#define ALL_EXIT_SECTIONS EXIT_SECTIONS
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
@@ -822,7 +821,6 @@ static void check_section(const char *mo
 #define MEM_INIT_SECTIONS  ".meminit.*"
 
 #define EXIT_SECTIONS      ".exit.*"
-#define MEM_EXIT_SECTIONS  ".memexit.*"
 
 #define ALL_TEXT_SECTIONS  ALL_INIT_TEXT_SECTIONS, ALL_EXIT_TEXT_SECTIONS, \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
@@ -832,7 +830,6 @@ enum mismatch {
 	DATA_TO_ANY_INIT,
 	TEXTDATA_TO_ANY_EXIT,
 	XXXINIT_TO_SOME_INIT,
-	XXXEXIT_TO_SOME_EXIT,
 	ANY_INIT_TO_ANY_EXIT,
 	ANY_EXIT_TO_ANY_INIT,
 	EXTABLE_TO_NON_TEXT,
@@ -883,12 +880,6 @@ static const struct sectioncheck section
 	.bad_tosec = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
 },
-/* Do not reference exit code/data from memexit code/data */
-{
-	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
-	.bad_tosec = { EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_SOME_EXIT,
-},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
@@ -1017,7 +1008,7 @@ static int secref_whitelist(const char *
 
 	/* symbols in data sections that may refer to meminit sections */
 	if (match(fromsec, PATTERNS(DATA_SECTIONS)) &&
-	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS, ALL_XXXEXIT_SECTIONS)) &&
+	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS)) &&
 	    match(fromsym, PATTERNS("*driver")))
 		return 0;
 


