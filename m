Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761C11C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9EDC433EF;
	Wed, 28 Dec 2022 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244935;
	bh=ezD3OB3O7kZpJCovwCHyicXwG+VlHnom3ed48kJ43qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMe7dlX1wnbAWr5EmyJO2DWchq0sLDE5odSFqcyQfRmjAxikkYSQDYsIxcKsYBbxr
	 wu/WTEEbUI4PxOl3gqQ16hfyP7B1/aCNJsW6NP56El0ijr8rLD+6lApATH/nQEI+Sm
	 8kL3MmzC/orguojRgyOXtUQbGWhPvybgNbqcmc9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0802/1073] powerpc/pseries: Fix the H_CALL error code in PLPKS driver
Date: Wed, 28 Dec 2022 15:39:50 +0100
Message-Id: <20221228144349.793846343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit af223e1728c448073d1e12fe464bf344310edeba ]

PAPR Spec defines H_P1 actually as H_PARAMETER and maps H_ABORTED to
a different numerical value.

Fix the error codes as per PAPR Specification.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-3-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h      | 3 +--
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 8abae463f6c1..95fd7f9485d5 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -79,7 +79,7 @@
 #define H_NOT_ENOUGH_RESOURCES -44
 #define H_R_STATE       -45
 #define H_RESCINDED     -46
-#define H_P1		-54
+#define H_ABORTED	-54
 #define H_P2		-55
 #define H_P3		-56
 #define H_P4		-57
@@ -100,7 +100,6 @@
 #define H_COP_HW	-74
 #define H_STATE		-75
 #define H_IN_USE	-77
-#define H_ABORTED	-78
 #define H_UNSUPPORTED_FLAG_START	-256
 #define H_UNSUPPORTED_FLAG_END		-511
 #define H_MULTI_THREADS_ACTIVE	-9005
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index f4b5b5a64db3..32ce4d780d8f 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -75,7 +75,7 @@ static int pseries_status_to_err(int rc)
 	case H_FUNCTION:
 		err = -ENXIO;
 		break;
-	case H_P1:
+	case H_PARAMETER:
 	case H_P2:
 	case H_P3:
 	case H_P4:
-- 
2.35.1



