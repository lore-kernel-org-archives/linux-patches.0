Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178612BE65E;
	Tue, 26 Aug 2025 11:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208390; cv=none; b=L3cZt/eWJS7Qk/ankPM2Y5U3n5XemuqlooRFPpwCiJjJnQ2ybD4JTu0oEvvZAC4XIbaaYkDhnlVO1ikW+YczjR1WZ/QUaaVcZTazYLfB37JZb4xeBwrChADG0rVRsrBXA8HoRTh1M4alVweaF0ViTxJ1NeN8gW+1IWg4inL6JVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208390; c=relaxed/simple;
	bh=5sOn6I5wOvJPKAG67BKLkVQpdb0dvudgDx+3ZoFijto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak/jOoDigoQQChUBQukBLsrhMLwJCPXuKQhx08uYVKG+W9Emju/uXZK7Gf07xJtuovmhv/zCIPVKtt7jrYJndYV8tUXXDmA0gkPI7YBmvSEbrgKWpwUFwRDHEGqTjJygLiYB770owPxCMnMWoR5r4Q8UHR6kGHouns5ZND/Sv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHZOfd1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHZOfd1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA69C4CEF1;
	Tue, 26 Aug 2025 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208389;
	bh=5sOn6I5wOvJPKAG67BKLkVQpdb0dvudgDx+3ZoFijto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHZOfd1UfNdPcTJrTsjqhmkaybrVRyMoKK83X+ve1zu63RVpiUnO6EtI0IRkdkyNy
	 7LGEeGh+1Y0P7hw7MOBaRV4u2+ThQy0tCwU7dulgwaVdxBVid5fsPow5ESR8tLIMhe
	 X0P108DwLHCWShYjFftcYxkL9fi5FRr2wim2Ma/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.12 092/322] parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826110917.944220605@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 305ab0a748c52eeaeb01d8cff6408842d19e5cb5 upstream.

For building a 64-bit kernel, both 32-bit and 64-bit VDSO binaries
are built, so both 32-bit and 64-bit compilers (and tools) should be
in the PATH environment variable.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -39,7 +39,9 @@ endif
 
 export LD_BFD
 
-# Set default 32 bits cross compilers for vdso
+# Set default 32 bits cross compilers for vdso.
+# This means that for 64BIT, both the 64-bit tools and the 32-bit tools
+# need to be in the path.
 CC_ARCHES_32 = hppa hppa2.0 hppa1.1
 CC_SUFFIXES  = linux linux-gnu unknown-linux-gnu suse-linux
 CROSS32_COMPILE := $(call cc-cross-prefix, \


