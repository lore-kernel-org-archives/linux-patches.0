Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89282566C67;
	Wed,  9 Sep 2026 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962132; cv=none; b=L+4dPCOKXgVkWY+pIf/rz2OihhdYIxND2PW1mBKlzwXaOaG9Ah5R3sRozrzRTJIjA1agMMURYekwzj7Ulcffj97bdUtgQT3Mawb7g+5xw3w6Wz28DWiqWPn3fI+Pyn2hbMeul4SQnaJwuykd+WemTMfVocu0MkFBp4/MozAJme8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962132; c=relaxed/simple;
	bh=CWuBtoiTFU45lHcYs8gL/gPbwcTLHdB1S2MK/XzVA1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0f+X/OhMmpBL/bn9hpwoagr87qm6rBh71SWi/QkVFEp1jfIui/ADQimvBBwFp9cWF3niBSyH/FSPHh/CkmQ8BidvVpNlJW5fgghgjH9kCRm7pe+Z9S153Hh79xqdobwr6Ol3Nt4rKNHsII234z3ADNX0WfTUplfPN2Hmfx6yq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN9y8khl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN9y8khl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FFB1F00A3D;
	Wed,  9 Sep 2026 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962130;
	bh=XQqH6VxSARptlMTTiMlbnW8G0yH1ADe22qN51T43Kpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QN9y8khl9ERde9vhZJoQF7ikwu4glq2iCcxgSph7+tSEIni2be6HfP7DChemMiXV7
	 /wcRpWybCmRCJ9YC1rFzhPSl5bt7QZFH/c2oGgyjMwYNSwqTX14SYVWjmyl1HGTQHC
	 A1jACnVvUkxIn1ZIUVYXG3WekW/h8SLO2uMwtE9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 167/556] Revert "pmdomain: qcom: rpmhpd: Add missing MXC and MMCX power domains for Eliza"
Date: Wed,  9 Sep 2026 15:37:27 +0200
Message-ID: <20260909134236.296384664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

commit 9fca7779ad18538188d640b1fdcfea924459542c upstream.

This reverts commit b48a0a0a76ccecec60f0568e2af4d89994b08bec, which
wrongfully added the MXC and MMCX power domains on Eliza.

Even though they are indeed available in cmd-db, which has been the source
of information for adding these two, at hardware level they are not
actually wired up. Therefore they need to be dropped.

Fixes: b48a0a0a76cc ("pmdomain: qcom: rpmhpd: Add missing MXC and MMCX power domains for Eliza")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/qcom/rpmhpd.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -245,13 +245,9 @@ static struct rpmhpd *eliza_rpmhpds[] =
 	[RPMHPD_GFX] = &gfx,
 	[RPMHPD_LCX] = &lcx,
 	[RPMHPD_LMX] = &lmx,
-	[RPMHPD_MMCX] = &mmcx,
-	[RPMHPD_MMCX_AO] = &mmcx_ao,
 	[RPMHPD_MSS] = &mss,
 	[RPMHPD_MX] = &mx,
 	[RPMHPD_MX_AO] = &mx_ao,
-	[RPMHPD_MXC] = &mxc,
-	[RPMHPD_MXC_AO] = &mxc_ao,
 	[RPMHPD_NSP] = &nsp,
 };
 


