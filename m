Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF22063FD;
	Tue,  8 Apr 2025 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115381; cv=none; b=jnGASVZB5FrrJwcS/no7TcPk8QpgAsVK96qwAjfsZm89XTUy6NxJHm6VyqaIAih78pHboE7HEgMJ8FCiI5VYPV8CKPy01386PSWzU+VEo5f1HJVHtxb8TZLFy06rSUNtcmZx2lMvj6B/f57EH/GtQsKJ1eZ564pEduTSgKLcfRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115381; c=relaxed/simple;
	bh=Z0Hs8qPHL5qWYi/33m61NJ+XsR/Iv6jhAjP7C7Cofxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmdlQ2to0yTWTb5eOpkjCL+he7MmoOHBdqJYXSI4udVxkfv0Hwu4BVS6WApkB96NzjdtSlJDnSZnJHOKa+AaYfBCKSLqT2wnNUAEYx6lcn9z7HgKynFplbxIvQoWpSzmpNgi1yO5FbUY9Vcm7Kk0NeQrGoxiRtLm1RE1nr0EXw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W944K6HD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W944K6HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92674C4CEE5;
	Tue,  8 Apr 2025 12:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115380;
	bh=Z0Hs8qPHL5qWYi/33m61NJ+XsR/Iv6jhAjP7C7Cofxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W944K6HDFH2vF6F2JrmAYdBfrQTx7Ri9EuLzC2yCeS/WZaphsG/rz0w9EYNpcYC1W
	 k5PDQQJpp3+HftF/Cogl77Mj/1dxj73ZURieATAykARVkyNij7+I/2ebYczpen8dg/
	 9QbnsQ7pXZhywkTpG5eygRlijOnuFt/Pkk5VHyDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.13 452/499] x86/Kconfig: Add cmpxchg8b support back to Geode CPUs
Date: Tue,  8 Apr 2025 12:51:04 +0200
Message-ID: <20250408104902.505264533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 6ac43f2be982ea54b75206dccd33f4cf81bfdc39 upstream.

An older cleanup of mine inadvertently removed geode-gx1 and geode-lx
from the list of CPUs that are known to support a working cmpxchg8b.

Fixes: 88a2b4edda3d ("x86/Kconfig: Rework CONFIG_X86_PAE dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250226213714.4040853-2-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -368,7 +368,7 @@ config X86_HAVE_PAE
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7
+	depends on X86_HAVE_PAE || M586TSC || M586MMX || MK6 || MK7 || MGEODEGX1 || MGEODE_LX
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.


