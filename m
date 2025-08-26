Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50EF267386;
	Tue, 26 Aug 2025 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207287; cv=none; b=sGdy5j8MX1ovVKQA7J5C9HT2ndnw61KRKj3IH/fxB1Y4Cn3YQXrujCh44ClmfJj4bUHZunzl6+3yYWq82Ra3heDW/t+G4Y/EuTZTXWCbjej04PMje0vDvBawmoD2TR7LHyPKugvdYBmTuqnF6sXZD2dcc1iCgUirxmzRaUABNB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207287; c=relaxed/simple;
	bh=D6CwOuQ3I7wBiMUzDGTq5uj4kIgIWAw4n/SDWLUv2UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNH16grHnvmuaX4iHFGj9KVvve09PLVXG7SijTuqxQNct1JzYftzDu17TOQI0j7Gd6tlUO1D7Gg9Iq3FWEOIT5k3Bh9dnsxaFi3dPY3hcPICsYVu1ACE3mN3pCQId8ClVWAofXM348X/1iHFa03dvUdKOdDY6i4E2d6DCVjRhbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Giign18d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Giign18d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47545C4CEF1;
	Tue, 26 Aug 2025 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207287;
	bh=D6CwOuQ3I7wBiMUzDGTq5uj4kIgIWAw4n/SDWLUv2UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Giign18dHf1C8oSiYawmWcxBMuUD+YMV69CkaJgS1nnJBVLovp37z6GT8PyfcLFmE
	 tkllURMqi/Z2rAyJyH3pKl1rkNn0IGqh7953QLsRL7VK1OvHQ2TTzppt+7LcHJNOsM
	 h0ty6ElIkF04wCcad49vy32QM8SyuBPV7jBqvg9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.16 124/457] parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers
Date: Tue, 26 Aug 2025 13:06:48 +0200
Message-ID: <20250826110940.438194377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


