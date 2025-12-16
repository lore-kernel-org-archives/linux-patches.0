Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94876382BF4;
	Tue, 16 Dec 2025 12:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888275; cv=none; b=imDhmXeWEc2rVhI9o+/vn++sk2SruQsxjsiQl66TRSbmNlzWwReVbfcNJZjmIBcZev+vsQIs1jw3yOpv0917Kv2hWgb/JkjI8KKNu4ix5cbZYVCmbCJPhqAlJSW65Y2Fvc2Z1bHLj6GfJUmr6p+dty+Sk9AuUHBm4sS2alnGp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888275; c=relaxed/simple;
	bh=l8WeWWJoIm2QnKHWRsDhXi6U+pJNyP0o4K+EL0ZM9+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqFNXY2WeOIk3aEwhpRohRgO7Mdz0pPcHkImIAzxbYQdd3u69cy0s6EAnSedVXSvRvIRzuXAek4lu2wdc2m8XqcBPP/BnkzbgzOLsaB0FOEOdkK/NFmEIBlWh0STv9/Mq5DlzugcimEba2g3SKwl2q3SEtLYp609U9vaeqJFH0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zllwCEFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zllwCEFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19421C4CEF1;
	Tue, 16 Dec 2025 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888275;
	bh=l8WeWWJoIm2QnKHWRsDhXi6U+pJNyP0o4K+EL0ZM9+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zllwCEFECkGJSiUUI+3t+vnmrqmKvx04wccOSWfuVDE1JR6eKecWWVttsxjoE0dvG
	 dxp5a0CR4FRrfA8043Eaus482Y6MHmi3YhlzQQaLvMKKcpuDm0tjuTIFwcVfu5o0vl
	 glM7iMhkpRMNtdI7QDw9c1CDttCbkBDp2khtmleE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tim Hostetler <thostet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 484/614] iavf: Implement settime64 with -EOPNOTSUPP
Date: Tue, 16 Dec 2025 12:14:11 +0100
Message-ID: <20251216111418.907847165@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 1e43ebcd5152b3e681a334cc6542fb21770c3a2e ]

ptp_clock_settime() assumes every ptp_clock has implemented settime64().
Stub it with -EOPNOTSUPP to prevent a NULL dereference.

The fix is similar to commit 329d050bbe63 ("gve: Implement settime64
with -EOPNOTSUPP").

Fixes: d734223b2f0d ("iavf: add initial framework for registering PTP clock")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Tim Hostetler <thostet@google.com>
Link: https://patch.msgid.link/20251126094850.2842557-1-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ptp.c b/drivers/net/ethernet/intel/iavf/iavf_ptp.c
index b4d5eda2e84fc..9cbd8c1540318 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ptp.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ptp.c
@@ -252,6 +252,12 @@ static int iavf_ptp_gettimex64(struct ptp_clock_info *info,
 	return iavf_read_phc_indirect(adapter, ts, sts);
 }
 
+static int iavf_ptp_settime64(struct ptp_clock_info *info,
+			      const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 /**
  * iavf_ptp_cache_phc_time - Cache PHC time for performing timestamp extension
  * @adapter: private adapter structure
@@ -320,6 +326,7 @@ static int iavf_ptp_register_clock(struct iavf_adapter *adapter)
 		 KBUILD_MODNAME, dev_name(dev));
 	ptp_info->owner = THIS_MODULE;
 	ptp_info->gettimex64 = iavf_ptp_gettimex64;
+	ptp_info->settime64 = iavf_ptp_settime64;
 	ptp_info->do_aux_work = iavf_ptp_do_aux_work;
 
 	clock = ptp_clock_register(ptp_info, dev);
-- 
2.51.0



