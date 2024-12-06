Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EEA13A863;
	Fri,  6 Dec 2024 15:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498225; cv=none; b=u3ofVCrc8QliE4IEUB4s+57BDggc5E5JpuTlO2aSmNjMR1eYzMpROGGtkVfTr95SZ7UokbZMFRXDRhm4yyKYKsESD3vvkoO+J+gOKmgv+LQDvC9bTEZzwYF22yeqS/bVsvJXOzxTkQS8B5y0cM00W6NKlmIngA7IeYHN9Shc+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498225; c=relaxed/simple;
	bh=GORZNuPot/XAZs0ujYqcJWrId1GNcrurIqxq5wazflw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZeLbVnN+GLyYznu3sgwwlpHsYbAu5+tsHvnTsXcN0Fa+ePVb0kr3+ddfblzKpnpNU9scpTopD7I3rxAFIgriDi8czyIxxdPKtPS1QPxbEcnz7zHbZ/wuoavTzW8GzJzRRD1PdwsJFTf38r5QFpvFKH2eI4ilTV26y7vl13IgqVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcakuEqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcakuEqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66757C4CED1;
	Fri,  6 Dec 2024 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498224;
	bh=GORZNuPot/XAZs0ujYqcJWrId1GNcrurIqxq5wazflw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcakuEqpQTntYLU9lkWcwXokz35Z5gJL1xrKr4Ki8+7S+EiJUsQbCRtnQ0bT0VSxl
	 0YkLiqzc8+QPv0jyRDXzpvQkX114uX873M5/fDGsk4WzGd0bc4p1acWEp2/az0HU1/
	 9eJk+Ia089WT2YlmDduRiF0/4uDO3yz0kJKtzDLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.6 490/676] tools/nolibc: s390: include std.h
Date: Fri,  6 Dec 2024 15:35:09 +0100
Message-ID: <20241206143712.500675326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/include/nolibc/arch-s390.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/nolibc/arch-s390.h b/tools/include/nolibc/arch-s390.h
index 2ec13d8b9a2d..f9ab83a219b8 100644
--- a/tools/include/nolibc/arch-s390.h
+++ b/tools/include/nolibc/arch-s390.h
@@ -10,6 +10,7 @@
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 /* Syscalls for s390:
  *   - registers are 64-bit
-- 
2.47.1



