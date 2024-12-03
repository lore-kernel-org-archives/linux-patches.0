Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736181FAC30;
	Tue,  3 Dec 2024 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239957; cv=none; b=oILLGMwWHZU/DmHw7qiYlH3i9TvtGX5CftEpWC0TYn56vaQ+ZkPGWHlxomaRS+qPLLW8ENxnEdJS8gTaE2TDmuv2PqvjTmOeE/FH3ssGjcsHGGcTvMAU64EUOFo5oE4IhmLcphJfPR6Ps692bS//PS8tSmIzpjPxHu2AP5H3xso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239957; c=relaxed/simple;
	bh=E0NMorDQRCNZA7f2OZOQUSlx4zsLya2ICNw7/rQE2Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXYoCINicSaiE55qKlfBk+HQWka8z8JOYvGnfVmaWTub4lCZrGLqJy+9MGM9bJwuozxOBB71XPbvxI87s2cdz31/VXgrRCaupvNeSiAhMZFn2ix0fbvAkwUhQTacRYKrYXvEovcdI56HsbRFDE7STJCTqHnifNk2rdBPbXdGu0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lE9P1Upz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lE9P1Upz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AB2C4CECF;
	Tue,  3 Dec 2024 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239957;
	bh=E0NMorDQRCNZA7f2OZOQUSlx4zsLya2ICNw7/rQE2Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lE9P1UpzDdqrpBdN5Aw4w9Lj1v5o3Jqlml+GsNpYWVOPUn4CM58cPZhXnrhLuW4+z
	 JMKU49fr6MMc23w7x6waldHThJvP+JIcG5F5Q/h9+HFHdcyo4rz6cxLoYMtNwQGfiW
	 yTuhhGMAXd2HessYnjhOf1C53pMZRk/tkskpvLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 793/817] x86/Documentation: Update algo in init_size description of boot protocol
Date: Tue,  3 Dec 2024 15:46:05 +0100
Message-ID: <20241203144026.965137426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit be4ca6c53e66cb275cf0d71f32dac0c4606b9dc0 ]

The init_size description of boot protocol has an example of the runtime
start address for the compressed bzImage. For non-relocatable kernel
it relies on the pref_address value (if not 0), but for relocatable case
only pays respect to the load_addres and kernel_alignment, and it is
inaccurate for the latter. Boot loader must consider the pref_address
as the Linux kernel relocates to it before being decompressed as nicely
described in this commit message a year ago:

  43b1d3e68ee7 ("kexec: Allocate kernel above bzImage's pref_address")

Due to this documentation inaccuracy some of the bootloaders (*) made a
mistake in the calculations and if kernel image is big enough, this may
lead to unbootable configurations.

*)
  In particular, kexec-tools missed that and resently got a couple of
  changes which will be part of v2.0.30 release. For the record,
  commit 43b1d3e68ee7 only fixed the kernel kexec implementation and
  also missed to update the init_size description.

While at it, make an example C-like looking as it's done elsewhere in
the document and fix indentation as presribed by the reStructuredText
specifications, so the syntax highliting will work properly.

Fixes: 43b1d3e68ee7 ("kexec: Allocate kernel above bzImage's pref_address")
Fixes: d297366ba692 ("x86: document new bzImage fields")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20241125105005.1616154-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/x86/boot.rst | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/arch/x86/boot.rst b/Documentation/arch/x86/boot.rst
index 4fd492cb49704..ad2d8ddad27fe 100644
--- a/Documentation/arch/x86/boot.rst
+++ b/Documentation/arch/x86/boot.rst
@@ -896,10 +896,19 @@ Offset/size:	0x260/4
 
   The kernel runtime start address is determined by the following algorithm::
 
-	if (relocatable_kernel)
-	runtime_start = align_up(load_address, kernel_alignment)
-	else
-	runtime_start = pref_address
+   	if (relocatable_kernel) {
+   		if (load_address < pref_address)
+   			load_address = pref_address;
+   		runtime_start = align_up(load_address, kernel_alignment);
+   	} else {
+   		runtime_start = pref_address;
+   	}
+
+Hence the necessary memory window location and size can be estimated by
+a boot loader as::
+
+   	memory_window_start = runtime_start;
+   	memory_window_size = init_size;
 
 ============	===============
 Field name:	handover_offset
-- 
2.43.0



