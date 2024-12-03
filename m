Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330111F473A;
	Tue,  3 Dec 2024 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239594; cv=none; b=Cg582qJ8HXU/7LYIC+2IPhsWBA0WT1T9S4oxiw30jApKAn+thZxh4G4mCgpkSrVir7trINvbebiyXJHJtQ3zffFP2iyiS4Gn9gNsHaFoB/TQ64FL6LmZ83GBlEHJYKeOcoZpr/4YjJPE8QhUchwHLVfsPrFGe+RpxbNH155xieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239594; c=relaxed/simple;
	bh=tsd2vyf0dMHA1r4GdT5ewEypEAfbt6yTMcJaD7bSFXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mf6dM7Bqf4OOOrp3dCu/NaVvUMPdBtXXr7WPOH3nnMoPQHJUUZ2g+OurAMxV3AjCZXlKRTTjBB4k08hVaB4sbMCVH7IN/SU8MJ/JAj0iQvVTgfv5OmfJyoN67D2lOXqAyThW0NA7TmzAVog96+Nd1AeAsLcXST8GtxjRSPGVDiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ae2cNmE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ae2cNmE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D81DC4CED6;
	Tue,  3 Dec 2024 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239594;
	bh=tsd2vyf0dMHA1r4GdT5ewEypEAfbt6yTMcJaD7bSFXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ae2cNmE3l11OJqZ5beQ7jnj2GSrP6ldmDRU6xiPMtfmzJ7sNd8cFfBgzECfdjLqak
	 6OmjvuLoB6DHJQ+hMQwlA4h/PR6NvraJt5KxyL+Xl/z8S9CXnK41UAZi22QtNlJUX8
	 uSXAhd8Bhl43aCOLkFrRc9RMHIe2GCdaJ3zxnvqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.11 667/817] tools/nolibc: s390: include std.h
Date: Tue,  3 Dec 2024 15:43:59 +0100
Message-ID: <20241203144021.992691816@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 711b5875814b2a0e9a5aaf7a85ba7c80f5a389b1 upstream.

arch-s390.h uses types from std.h, but does not include it.
Depending on the inclusion order the compilation can fail.
Include std.h explicitly to avoid these errors.

Fixes: 404fa87c0eaf ("tools/nolibc: s390: provide custom implementation for sys_fork")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20240927-nolibc-s390-std-h-v1-1-30442339a6b9@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/arch-s390.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/nolibc/arch-s390.h
+++ b/tools/include/nolibc/arch-s390.h
@@ -10,6 +10,7 @@
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 /* Syscalls for s390:
  *   - registers are 64-bit


