Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F9F28EB;
	Wed, 23 Apr 2025 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421832; cv=none; b=rQAANm/Emh8bzNPKYiT8VXeAWZpJ+WRFT4783hFw4MH+MZy8knQPFGWaTheX2FPHHw0ZKnwgnaQ4/4fi/FcZ7PVHRYjg/8B4z32dEy0hBgDx2IFjbPt2xzffUMawuYCOONVuaSt8HdNKNBkJ7XW7rYaUKQo1Y+0ch+cHvuFu7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421832; c=relaxed/simple;
	bh=CK+Hhj0cwlAsf8AbLbFfrDWK2eIVDuVDD0xo4r2chuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DB2uu8YCLIw2khaT+tAhIaJlAM5W/u2HRIciNWD23lIXCG6NBKgVWU0N8/PQqMvYKEev987z9K0FYpFxE/mEQfGGvouRF+s+ZqDbkMAEigrZpwtyWnaGWUtKNsdwk6KYGELHzo66fPXhbDDHfO0zURVxLGq5zwqNkTn2Vjr4KIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J42skv6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J42skv6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DCBC4CEEC;
	Wed, 23 Apr 2025 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421831;
	bh=CK+Hhj0cwlAsf8AbLbFfrDWK2eIVDuVDD0xo4r2chuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J42skv6RxUo5Pvab0cYBRFSqcEZroUyirxk2bdm2mUTPWpkpEZPnpDLfNq1HiWn7+
	 mJUAqmzcKEU+oeAQlkSqgH3RSJh0glC98RPeJBW4kaFIdUmc9nJKMdtEpGFp93qvZY
	 BtaW/Akjf5JbBwOpKJ0tCBV/jjAeqbMEqYsTq7s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.14 238/241] MIPS: dec: Declare which_prom() as static
Date: Wed, 23 Apr 2025 16:45:02 +0200
Message-ID: <20250423142630.295271079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 55fa5868519bc48a7344a4c070efa2f4468f2167 upstream.

Declare which_prom() as static to suppress gcc compiler warning that
'missing-prototypes'. This function is not intended to be called
from other parts.

Fix follow error with gcc-14 when -Werror:

arch/mips/dec/prom/init.c:45:13: error: no previous prototype for ‘which_prom’ [-Werror=missing-prototypes]
   45 | void __init which_prom(s32 magic, s32 *prom_vec)
      |             ^~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:207: arch/mips/dec/prom/init.o] Error 1
make[5]: *** [scripts/Makefile.build:465: arch/mips/dec/prom] Error 2
make[5]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/dec/prom/init.c
+++ b/arch/mips/dec/prom/init.c
@@ -42,7 +42,7 @@ int (*__pmax_close)(int);
  * Detect which PROM the DECSTATION has, and set the callback vectors
  * appropriately.
  */
-void __init which_prom(s32 magic, s32 *prom_vec)
+static void __init which_prom(s32 magic, s32 *prom_vec)
 {
 	/*
 	 * No sign of the REX PROM's magic number means we assume a non-REX


