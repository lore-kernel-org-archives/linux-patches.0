Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3149D5A6;
	Thu, 17 Sep 2026 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665721; cv=none; b=nhVEv8/WtPm1Lbqa7j4nZOqS7Vgp1dEgGra+ZBoZ8zVfqBeZQa533F8l9+9FNimOvDBWHkxRBr8juw7nn3LTCgSeKQxVTSHBLggKl9dFFyCoODx3IFq/UzllWv4c26EAfDl3/qp1daXEAs3wR3UfsNdEs1mp5F0ofs2DhoJOSD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665721; c=relaxed/simple;
	bh=6ECjFeYm2J19a6bSRhKEd+ee+h61mXsb5X8fipDjWno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtcQHxmb1xU0Jh8EkUwd0/8yAvWytyQTZaFsV0VthBd32uMaj265Ma25Xiluzpr2VHkJUrcCyEZcHIlMGFVIHFBhwRbBKBawJqhJ/ko+M2xngTy9vQgmHpTGGDD/cUKKRR1adcfBG1ij5k42cJDM50N37o6KK8hZmzrmTarlAsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evUDoSoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evUDoSoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1111F000FF;
	Thu, 17 Sep 2026 17:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665720;
	bh=JmWR2rd3Q6Lrtuv3wZ04dd7i/slhxtT1xg4I9yoJE/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evUDoSohtX3ZLK4UPUbWmHzlPfH2LhdWoVH0IR1l1OsAghQGr3oorbrUTALwqJ1qY
	 lNLsjV3ETpb1uIQ78BzWJWzcGY0j1C7jgGUnhv5OOhPFSuLjDpdwljGeYhed9zZrBk
	 V8mDkckPmL5G9/lFWgPcLLBryyvRZAkJGbCkAOAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0798/1250] dibs: Remove reset of static vars in dibs_init()
Date: Thu, 17 Sep 2026 16:09:53 +0100
Message-ID: <20260917151613.531844705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 182663bbff784e88cf7acbae7c53c6c5e0cb9ca4 ]

'clients' and 'max_client' are static variables and therefore don't need to
be initialized.

Reported-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20251023150636.3995476-1-wintera@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 1668a31e3b1a ("dibs: Unregister dibs_class after error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dibs/dibs_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
index cf96f0a4a5af6..d6ea178e70c44 100644
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -248,9 +248,6 @@ static int __init dibs_init(void)
 {
 	int rc;
 
-	memset(clients, 0, sizeof(clients));
-	max_client = 0;
-
 	dibs_class = class_create("dibs");
 	if (IS_ERR(dibs_class))
 		return PTR_ERR(dibs_class);
-- 
2.53.0



