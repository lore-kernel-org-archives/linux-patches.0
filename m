Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72A7286D57;
	Tue, 26 Aug 2025 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208869; cv=none; b=t9E3uhe2tgLeDIX+Zatik22MfCl2/ZFBA/0I1HwVz26ikVMzbjnJ3+S8U//hs4sgSAVK9ShKW19+LE76Fx0cvAyQL4iVFztpoKD7+ywBpgf6uVEol4qQfjg3388xGbO9HOuEn4JkbPkdsBnU/EVmXOX0uVHWTSsDEabbq1yPcAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208869; c=relaxed/simple;
	bh=GSH2jpiudLFknqUEH286hbr8UHubPdzYwg8v+z+LJ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yos/db8RhbekCFWWZWi1CKm3nZddaCYQ6yleUrNbbQnga1oOtYt26W/JS2pZ3zFL8st+te4q48il1JxWp4SXCVKwesIi8Qs3sJxaoLNGCTdLvjCX6Doy6Z235G3NgG/A9TTc76VU2kJLXblE+54s8l72oUQZ848l4j9i+kEe0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FpLrE8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FpLrE8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3C3C4CEF1;
	Tue, 26 Aug 2025 11:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208868;
	bh=GSH2jpiudLFknqUEH286hbr8UHubPdzYwg8v+z+LJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FpLrE8vte86usLhsFH7Lr3m65VOrWC0gjfIrmCiC9ztbYhddIuv9jPa0CBnoZhrT
	 6W6o438sDItwaKN6leEAJegvXO2kcg+KpNnhN9teYpyQW42LmTRN4uV6vr+a1JfDZ4
	 tNzVgFEJeu8sZKwPin0O6/hc3S5P6WgYQ/7yaogw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.12 245/322] powerpc/boot: Fix build with gcc 15
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826110921.970900080@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

commit 5a821e2d69e26b51b7f3740b6b0c3462b8cacaff upstream.

Similar to x86 the ppc boot code does not build with GCC 15.

Copy the fix from
commit ee2ab467bddf ("x86/boot: Use '-std=gnu11' to fix build with GCC 15")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Tested-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250331105722.19709-1-msuchanek@suse.de
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -70,6 +70,7 @@ BOOTCPPFLAGS	:= -nostdinc $(LINUXINCLUDE
 BOOTCPPFLAGS	+= -isystem $(shell $(BOOTCC) -print-file-name=include)
 
 BOOTCFLAGS	:= $(BOOTTARGETFLAGS) \
+		   -std=gnu11 \
 		   -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -O2 \
 		   -msoft-float -mno-altivec -mno-vsx \


