Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679932FA3D;
	Fri,  9 Jan 2026 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959862; cv=none; b=Xsx1cRIjSOONxLBggYgs1u/XCtLB/P6XGyWJrgpcmgwFPt0NEAWwXjQ/upF3kAGp5cC0oSsMEpS0/kw2PHB42IByMYPyr0oilAe4nX1XMfhcpcaLp5GQ5o2JRHVQcCmZrkr/5wBS+tbJ3az35yMozrZLGWeMcN/XXVWDeUjxGYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959862; c=relaxed/simple;
	bh=5lHFbIYwX3repMEBFJrwENdkH7Aa7Ar/aedSuPMV7lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8fpEHFQMbWBfdhrt5E4Xo6V+U8puZoqkhHkxKAd3FDHUYmI8/iXh+XU8PAgvU1K6LgqUy/CH+3ymVnZUBjdFUaoVcGLqNGda6ULaNt7n6wm26YQGhJP+xLamkMfnzFnlvq9WLkt0QdoTtzFYm1j1izNw4XBv7RKEtESG9w5MyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s5OCXUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s5OCXUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F59C19421;
	Fri,  9 Jan 2026 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959862;
	bh=5lHFbIYwX3repMEBFJrwENdkH7Aa7Ar/aedSuPMV7lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s5OCXUFvKNyzK3R9x+dmEWPj6s62lXNcRPA2ops1nrOVR6+8LcTY3Y6JTbictSnI
	 MHejTulJPatey2eHCcXWApURetzE+ThETGElbayvsMPDwADUOfYIkJ02P+C6fkVKsL
	 BHI0TkmRvCylcZAo3By8cn7QOHtmn5CN7QWCzfCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/737] firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
Date: Fri,  9 Jan 2026 12:35:40 +0100
Message-ID: <20260109112141.563994113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 766ced12345c3..a133ac5fb0373 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -52,6 +52,7 @@ struct stratix10_svc_chan;
 /**
  * struct stratix10_svc - svc private data
  * @stratix10_svc_rsu: pointer to stratix10 RSU device
+ * @intel_svc_fcs: pointer to the FCS device
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
-- 
2.51.0



