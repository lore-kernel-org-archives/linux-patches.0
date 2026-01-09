Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8107835A952;
	Fri,  9 Jan 2026 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961811; cv=none; b=GCMPU5OKf2pHwNICSKr79/eupRGIxGM5YD7cYCImeaazxmpf5ZjTmVtu/Df2v+rud+57qEMl27gYZ4eRlN7sHrAT7PzjO506rnQdDWJOKDBTrEvMvbHQZgPegpSBrbXSt+JTinxeZu0zG72bVq6zF4Q6+mDcDFE33Y7etgdIXxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961811; c=relaxed/simple;
	bh=llT/DVpjg9px5CxhQu5RUxadEEvGtq3Jp6Gapf4xGjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmzYOa7RabLjoytDvGWc8Uzlw5/gvHg02gudZeOp4qGcvSYkrqSRE5mj6J0624VzIBuRqGIEzBCpPZZrq/aV6UP4oN6Ml9Bw2+1PH2tbl4qsd4ea6Sjt3O6j1/2jb1X5CDrMr7Rjl4A+U5W1UIbkEYUsxlq0rfzctIG42v1gACs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSf7PU7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSf7PU7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E7CC4CEF1;
	Fri,  9 Jan 2026 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961811;
	bh=llT/DVpjg9px5CxhQu5RUxadEEvGtq3Jp6Gapf4xGjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSf7PU7DM981YGbSieTE4IWh3eeCqZnYR8j33jkhs+1fody0KjtMIzMtrgmz9gvH3
	 /s1PZPH1j9sh2tDNDksas5stJ2dPpYiYIenyQHxBjrHpxLed9r0v2mqdippJdtzokO
	 RkmORYMOFkS6zE72NphztvJsY5Cx35o8cUbvLF0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/634] firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
Date: Fri,  9 Jan 2026 12:37:03 +0100
Message-ID: <20260109112122.911210514@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 377441d53a2df61b105e823b335010cd4f1a6e56 ]

Fix this warning that was generated from "make htmldocs":

WARNING: drivers/firmware/stratix10-svc.c:58 struct member 'intel_svc_fcs'
not described in 'stratix10_svc'

Fixes: e6281c26674e ("firmware: stratix10-svc: Add support for FCS")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251106145941.37920e97@canb.auug.org.au/
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://patch.msgid.link/20251114185815.358423-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index bb4adfc30218d..80898fc68bc31 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -51,6 +51,7 @@ struct stratix10_svc_chan;
 /**
  * struct stratix10_svc - svc private data
  * @stratix10_svc_rsu: pointer to stratix10 RSU device
+ * @intel_svc_fcs: pointer to the FCS device
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
-- 
2.51.0



