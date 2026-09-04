Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6507B41A922;
	Fri,  4 Sep 2026 06:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502740; cv=none; b=PDW3Ab9+O2XY/M4yxnUSOehyToIGC+VKsPvlNbuHMv+fHJ8btW+aBhGptj5ZlhYi6L9mB4FIKdIHDsihuJD3lD/RP1JuiY91UL7KB83x5eMJxQLaOlcBNYsETn4h5aTqfvSy/7syxv6r+21k2y3javp13WvvChU6lshBwIeMqFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502740; c=relaxed/simple;
	bh=KreYRCFzEAxKMZcwGadfZ0jpg21grxeks/7A2KPOxGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdAN+K8GddAH0XI3qIRzAVwidvwBiUJ0FSfxKd2OKLgm0Sh6YGxjUuqMntFNVNPVuECqMk0OI0IeHjLMBhL7JnmQsg+42rfHTXZ47uxEJgCNfibDpOazw3lA4jRtUJvvvFOQQ5htvj9mfXCpOjUQVzn7b90SXcshYHJROyWSONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj7ZiR46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj7ZiR46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B041F00A3D;
	Fri,  4 Sep 2026 06:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502739;
	bh=dDa01BcG4re0rWgdr7E/qejBK9507T1yU9/uxSeO8X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fj7ZiR46IeEqsRHejdkqTn3Am4x0JVRYt8Tyc3+sFXT7zUypHt1Sxq9nzVLDymMZB
	 OfWs9mjHa1pJsHWuiYwgVjFXK0riF6trOwunQbSlZYJhtrvCUTvgy0R5FlHgh51BiF
	 kiFdNp7LL1GWC8Q7YLimXGFulUUTiYKE6RJ7aO8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 311/403] platform/x86: ISST: Add a NULL check for sst_inst[]
Date: Fri,  4 Sep 2026 07:01:54 +0200
Message-ID: <20260904045741.913730291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 3de2776e9d7073765c10c2326c2bda5926811ea6 upstream.

To be consistent with other places, add a NULL check for failed socket
loading by checking isst_common.sst_inst[].

Fixes: d805456c712f ("platform/x86: ISST: Enumerate TPMI SST and create framework")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811222134.3912626-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1312,6 +1312,8 @@ static int isst_if_get_tpmi_instance_cou
 		return -EINVAL;
 
 	sst_inst = isst_common.sst_inst[tpmi_inst.socket_id];
+	if (!sst_inst)
+		return -EINVAL;
 
 	tpmi_inst.count = isst_instance_count(sst_inst);
 


