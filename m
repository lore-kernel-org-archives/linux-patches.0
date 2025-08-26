Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16202252900;
	Tue, 26 Aug 2025 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213933; cv=none; b=LusHjvxcr7zh8MOiwUZk4v0tH3+sCryaW034+N8J4ECHOq7bvrbZrBxU3xF2Em9kR1OxxaxqJQWSPlFZZCOazoLsb1pkV/B7VYOlfEvuc/voO3i2QPgCMZovQNZHNnT2ogQHtUAbTyQkjQfD9xzUBQg4hA8XFtAecpnqj/lrEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213933; c=relaxed/simple;
	bh=0rGm+7WsAfPKyuPIXAZQC/khyJELsrtNGCg6O4tRLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mitl/2jEB8WfyB663DmHv9yyANMaD92FFpIcjuFz629yLI+LnL30haynel2LiIfRF2iNiK+oTVjANriUw7zslKOK0w/kUe+PKMC5PniF0nnZNJr0s7pQEh8Zkcfw/XIqUOFIwjWD6pU+pMONlQvwTDlnyLQ2q/Mkshm3xo8Zf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSKK6CkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSKK6CkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4CC4CEF4;
	Tue, 26 Aug 2025 13:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213933;
	bh=0rGm+7WsAfPKyuPIXAZQC/khyJELsrtNGCg6O4tRLF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSKK6CkKZn8zHdynjfXLNSjxbzrYFOglnrmsUxyL0TViSGZdj65w4Xcn78XGqRrJn
	 pJ88PE2bGZ1soLf/Zs9QhUaNP763EFYPbaAch9SKYve3aR96tuVukJvYgi9a/2WfwJ
	 O6kT7adlsRy/0j8LvYhwzHdCkgdd0n/Px0OwOMVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 534/587] powerpc/boot: Fix build with gcc 15
Date: Tue, 26 Aug 2025 13:11:23 +0200
Message-ID: <20250826111006.592029116@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -72,6 +72,7 @@ BOOTCPPFLAGS	:= -nostdinc $(LINUXINCLUDE
 BOOTCPPFLAGS	+= -isystem $(shell $(BOOTCC) -print-file-name=include)
 
 BOOTCFLAGS	:= $(BOOTTARGETFLAGS) \
+		   -std=gnu11 \
 		   -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -O2 \
 		   -msoft-float -mno-altivec -mno-vsx \


