Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BDA1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D563C433D2;
	Wed, 28 Dec 2022 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244940;
	bh=ExFAmNH5mIw0yinUvm0KNakICdbGLYc9L+GW9mv+vhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JevjTesgv93d3dJ79hSLsOSUEgaXSIzYB+h/Obb1xKbHBPCRo9c1US6sM+vfhnUJP
	 kTemIVvUIDuyx8hD6fRiW03QH656lC2Bq3EkYH2Y00lkW2EdPPE+w4K8ZbHAg5smUS
	 4NFPgValYCilqqedH9ES7U462JKtaXkI7Pp5H6LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0803/1073] powerpc/pseries: Return -EIO instead of -EINTR for H_ABORTED error
Date: Wed, 28 Dec 2022 15:39:51 +0100
Message-Id: <20221228144349.821035968@linuxfoundation.org>
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

[ Upstream commit bb8e4c7cb759b90a04f2e94056b50288ff46a0ed ]

Some commands for eg. "cat" might continue to retry on encountering
EINTR. This is not expected for original error code H_ABORTED.

Map H_ABORTED to more relevant Linux error code EIO.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-4-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 32ce4d780d8f..cbea447122ca 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -111,7 +111,7 @@ static int pseries_status_to_err(int rc)
 		err = -EEXIST;
 		break;
 	case H_ABORTED:
-		err = -EINTR;
+		err = -EIO;
 		break;
 	default:
 		err = -EINVAL;
-- 
2.35.1



