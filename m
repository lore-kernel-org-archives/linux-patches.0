Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294D0DF49;
	Tue, 26 Aug 2025 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213565; cv=none; b=nz937XLPtVWt/uBgXI20/ZSrjAei4z1dyiN+O6Gk6oNM1LVeD9wVX34D/RIP0WwG5s78qFbMqN07A3lNwI+XJGmRyNWByF7Zdsh9eV3PZM2donkVNmUOP3Jg9Zc6ZqLfslY/poLWRQBHpR5RwNouhvXqZiFsjZuutkA7kQOCtZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213565; c=relaxed/simple;
	bh=8iI2xos0uhPTYbqZV+yBTuKMqN879heue3iGpn4Z5gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/vBHYn9Rgs5NBzpvoc0DbvnuHQ1h8V6Y6ws6xdSCz1r/txGF6t5AWXatkjKo8/WnUCLIONCzr6dsNIBVw0owS99kzAxZUmPJ+ls0/8aYqXUnT8BpBnSZYOqkAE72jM2Tmz9OXR2Dach4BMIWAPVxvxcOxjVMPbF2VnmdIQH8iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpIZPIE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpIZPIE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D7C4CEF1;
	Tue, 26 Aug 2025 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213565;
	bh=8iI2xos0uhPTYbqZV+yBTuKMqN879heue3iGpn4Z5gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpIZPIE9rB/2iEJeBow1icDegmoLg8DaoEZiVSejTYKCZO5aR2JQySAxvUCj6UDsh
	 v3xHO8F18M7i2WC1YMri4mEYX+ZBWuM5SK3lDYFI5ADXQ6+GHDMTWXYFkAERrbleNl
	 dUjiY96RdxoE8mvMa4PHnad6cEKwtyg3JmyGS8zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.6 395/587] parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826111002.970194964@linuxfoundation.org>
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


