Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22045196C7C;
	Tue, 26 Aug 2025 13:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214909; cv=none; b=n5wgfF6J4cujDWt8HXZGvewuueCR7q7ZLv+ZWtFVsCUNyHVSqlFh4bkMJ2+kytkU4TwLJ8ii7Xpw7Ag9y4wBOxJzK0PTHRogAMTy2kBuiG+4hZgJc97Y3Nm3NWbyuRlZpdzuS05L4hvqcPWClXKb/QyDgMuU8oVPyelk3S+olCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214909; c=relaxed/simple;
	bh=NJcANyMcr7nj4qtqahjWMFURurftgHdlcxPZSeOIKPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW+PR9i6YueqOW8uymEDvkJSBnZik1yeH7ScKi8CKLU9xU4p86/1BYP87G5sD1upw7nzQE0OICwjdkwrt/f1ig2hz9/rAZCT6ihc9HlMTYM54o+kI2FXCvuPM7yT57E8cmlPFQFBuYVY6rsdNh7wtonSIaDf523qgZ9KncNVvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDt9k/ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDt9k/ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4A8C4CEF1;
	Tue, 26 Aug 2025 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214908;
	bh=NJcANyMcr7nj4qtqahjWMFURurftgHdlcxPZSeOIKPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDt9k/ldfhOzCX1XZhM8KMMc8s7NJlOQfWG3A+6Kao6BNtV+mu8aqCflbzx6nzACd
	 FTHphXSecUycTvd61ao74PA8Llq+m8lBCRJucf2HVapRtoJxPrF42n2vmj5Gvq5epz
	 ZgKBwufOkD6o5Dkmq5rBhSl+bJb7GJq0SqO4HsYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.1 314/482] parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110938.561541011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


