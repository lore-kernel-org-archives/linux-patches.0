Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C30C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7531C433D2;
	Wed, 28 Dec 2022 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244930;
	bh=Lw4hn/Jernb32hTCgisRANQ4N/Uaj2mNKeJosIodLEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxFjU/oSpDlyWOrMUv7Ooc6MlKrzOev3AHuDjNeqoZNSicEOi4n6tI691iGKM5b51
	 txmYSdKpHdhiZwXITCXHi85YyWC7k/B0rGZzj6pveIw+APMxzVGf4er+u+qBt8Nr9H
	 hmUBGekINlw/t4UTQiFYxGj9wcd4CKDt6cl8lwjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0801/1073] powerpc/pseries: fix the object owners enum value in plpks driver
Date: Wed, 28 Dec 2022 15:39:49 +0100
Message-Id: <20221228144349.766705076@linuxfoundation.org>
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

[ Upstream commit 2330757e0be0acad88852e211dcd6106390a729b ]

OS_VAR_LINUX enum in PLPKS driver should be 0x02 instead of 0x01.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-2-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.h b/arch/powerpc/platforms/pseries/plpks.h
index c6a291367bb1..275ccd86bfb5 100644
--- a/arch/powerpc/platforms/pseries/plpks.h
+++ b/arch/powerpc/platforms/pseries/plpks.h
@@ -17,7 +17,7 @@
 #define WORLDREADABLE 0x08000000
 #define SIGNEDUPDATE 0x01000000
 
-#define PLPKS_VAR_LINUX	0x01
+#define PLPKS_VAR_LINUX	0x02
 #define PLPKS_VAR_COMMON	0x04
 
 struct plpks_var {
-- 
2.35.1



