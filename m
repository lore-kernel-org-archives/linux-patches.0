Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAE03D349E;
	Thu, 15 Jan 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499963; cv=none; b=Yxb7tKPh9kc4R2e9R5oILusW2WMu4XwRcEQGGm4TL2T2l7HM2VAl9wJNmMczE81Wi98IufW6hhaQYdBOoDq3RgLyOQtFmjwvLTzcuqCvch+KsZ5ybUmMKbQ3E6dyFLykOOlUgCLCuxLoV89MiCKsOeZ76VqAOVW9U1TWDxUQ0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499963; c=relaxed/simple;
	bh=BQVDIXIruov7ZpacDwWwfYMcZe6FPHwxvrfq9V8dY+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coFCR4JCO5EtxzxTUr7JoxBi7yGa904exH3h/uoGGeH6qYmpX/I8hrgCE6KW8ND+z/x2V8J/ZiLZMOMAnOM0e6P6ejPGvQzZmo09wpSDkCCAp2xtykllRG410GsmIpvbdfR53OIumQn4z2Apm9iFDRB9eyap2JOSxTjanMBqvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eg3+KWrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eg3+KWrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F1BC116D0;
	Thu, 15 Jan 2026 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499963;
	bh=BQVDIXIruov7ZpacDwWwfYMcZe6FPHwxvrfq9V8dY+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eg3+KWrNlLXJWvsMPk0d5oGpSOlRcmvFOiZT5YxdO91WXjNICGozGzlzRetjquFgO
	 IXhSRCCV6iPDhwN/p/7mXURY9XJuWx9w3nC0jCXJhEwTFm2rRyHM2TaJ2IuT4egpJv
	 lUWSzbeGGZ7+3/7oDB9XRyH+F/wodnIJRfSAuIxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/451] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Thu, 15 Jan 2026 17:49:39 +0100
Message-ID: <20260115164244.593524180@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit fc6bcf9ac4de76f5e7bcd020b3c0a86faff3f2d5 ]

Patch series "powerpc/pseries/cmm: two smaller fixes".

Two smaller fixes identified while doing a bigger rework.

This patch (of 2):

We always have to initialize the balloon_dev_info, even when compaction is
not configured in: otherwise the containing list and the lock are left
uninitialized.

Likely not many such configs exist in practice, but let's CC stable to
be sure.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-1-david@redhat.com
Link: https://lkml.kernel.org/r/20251021100606.148294-2-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ moved balloon_devinfo_init() call from inside cmm_balloon_compaction_init() to cmm_init() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -570,7 +570,6 @@ static int cmm_balloon_compaction_init(v
 {
 	int rc;
 
-	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.migratepage = cmm_migratepage;
 
 	balloon_mnt = kern_mount(&balloon_fs);
@@ -624,6 +623,7 @@ static int cmm_init(void)
 	if (!firmware_has_feature(FW_FEATURE_CMO) && !simulate)
 		return -EOPNOTSUPP;
 
+	balloon_devinfo_init(&b_dev_info);
 	rc = cmm_balloon_compaction_init();
 	if (rc)
 		return rc;


