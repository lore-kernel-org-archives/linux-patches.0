Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D11330C62D;
	Mon, 27 Oct 2025 19:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593376; cv=none; b=YgKfs0htAdv443P1oEwOrnxnNrfitRqR4yDXG9Zs2BB3XdtBjdxoX0OfuFM4X+BcgE/+UbLSK62x/KoDRGIesSrq44MyZNdHMltP3s+3QBeHy9h3vHS8an/qcnssEEphiIn2S9FzgfOx5kIo4BLMfrbZgeC099enJaWp4o7M4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593376; c=relaxed/simple;
	bh=m4a0Oabl5TsXAZJT54G9r2Gfl3nIPVu44+g+30v8rhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRBu2+PTU2XohS/kwz3EBVSlPbPG62puhzEEeLSgD5bzQw6xNJREBiGgLY79DEAbyeQbP+4IYy19d9mOo5CmtHZb8A/P+d8nCRNoub21YJBeVIr4QG4zFH1JP9OLTfN0NN5xY0VPt7YTM4i8XGPAAGUvdqILP3/38zN0UNBAXqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGiG/BAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGiG/BAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C920C4CEF1;
	Mon, 27 Oct 2025 19:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593376;
	bh=m4a0Oabl5TsXAZJT54G9r2Gfl3nIPVu44+g+30v8rhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGiG/BAXba/ixn4umn/NOKcHO3DxY5cFwxFAERx2PI0xL2kHokFA32nlg1ft1mFjy
	 2f+4Yr4OvTnhGLU6mYIGFY2+hh0nflEShgqhKavvpjglrtK16G22tC+ENO0MJVHN4D
	 YkWTBaDCO0LhCxufaRYbDeNItl2tG4Ccm6ptAW58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Hammer <galhammer@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 078/184] platform/x86: alienware-wmi-wmax: Fix NULL pointer dereference in sleep handlers
Date: Mon, 27 Oct 2025 19:36:00 +0100
Message-ID: <20251027183517.003000400@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit a49c4d48c3b60926e6a8cec217bf95aa65388ecc upstream.

Devices without the AWCC interface don't initialize `awcc`. Add a check
before dereferencing it in sleep handlers.

Cc: stable@vger.kernel.org
Reported-by: Gal Hammer <galhammer@gmail.com>
Tested-by: Gal Hammer <galhammer@gmail.com>
Fixes: 07ac275981b1 ("platform/x86: alienware-wmi-wmax: Add support for manual fan control")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251014-sleep-fix-v3-1-b5cb58da4638@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -1647,7 +1647,7 @@ static int wmax_wmi_probe(struct wmi_dev
 
 static int wmax_wmi_suspend(struct device *dev)
 {
-	if (awcc->hwmon)
+	if (awcc && awcc->hwmon)
 		awcc_hwmon_suspend(dev);
 
 	return 0;
@@ -1655,7 +1655,7 @@ static int wmax_wmi_suspend(struct devic
 
 static int wmax_wmi_resume(struct device *dev)
 {
-	if (awcc->hwmon)
+	if (awcc && awcc->hwmon)
 		awcc_hwmon_resume(dev);
 
 	return 0;


