Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A03D75C7;
	Wed, 20 May 2026 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297195; cv=none; b=jg58z90uJKFkVLNoNq2i98624eRs3KSkZ18QfNNtG+HdEpS7KgEb1aBFrL/TsIRcCLudw6ijoxx2nPEZg2Mls5RbIvWIYu+SMCbC1HS3UcdGYgcmPCWiFyHGjPPZT+Eg6olaX8vyGr+tP53wPPEtkDT1dHpz3B8mdIAiryOmMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297195; c=relaxed/simple;
	bh=jfakj+nt8NtWFb3ONC4HEQOCuTBJSV0MxfQAeroDE6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBN/bHLNU7NXPvbpIcDJEvndMiY+JhXcepV2abAYJ3Tqa/8keLYhhXpExdCut1vozDuKvtvVqlZ/tH8+aXUuF3zkydqxJdr5OilieZzyLKBp9ClHytXEnNyxEPXlRqUPtHo80IdesZbtvhFOweJBHwEg5PRlEOKUwOITA3BvSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7N2Gq7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7N2Gq7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BAA1F000E9;
	Wed, 20 May 2026 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297193;
	bh=XjMK+//KIBuTRSGooMpYIslTRLECDIj8AdU2cv7E/yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7N2Gq7YR/pxPSttu6quuqQiadEC6awQniCmqLtkMlXimJSSjXth4B9WxFh6vLJ6d
	 hhYztPwdJeyVkiIwyTprWiplC7HKVDCxlEWrIgpVO47oUZ5/M55zoE4r8vxWY6T4PZ
	 8WCYbfiUf/MBVYbJB20ot+d1UJgqASpkfqxgFiXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Rong Zhang <i@rong.moe>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 1084/1146] platform/x86: lenovo-wmi-other: Fix tunable_attr_01 struct members
Date: Wed, 20 May 2026 18:22:14 +0200
Message-ID: <20260520162212.767999557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 71f3843e0f81e3c097a088c1121154bb9a44da0a upstream.

In struct tunable_attr_01 the capdata pointer is unused and the size of
the id members is u32 when it should be u8. Fix these prior to adding
additional members.

No functional change intended.

Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Cc: stable@vger.kernel.org
Reviewed-by: Rong Zhang <i@rong.moe>
Tested-by: Rong Zhang <i@rong.moe>
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://patch.msgid.link/20260510042546.436874-6-derekjohn.clark@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/wmi-other.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/lenovo/wmi-other.c
+++ b/drivers/platform/x86/lenovo/wmi-other.c
@@ -545,11 +545,10 @@ out:
 /* ======== fw_attributes (component: lenovo-wmi-capdata 01) ======== */
 
 struct tunable_attr_01 {
-	struct capdata01 *capdata;
 	struct device *dev;
-	u32 feature_id;
-	u32 device_id;
-	u32 type_id;
+	u8 feature_id;
+	u8 device_id;
+	u8 type_id;
 };
 
 static struct tunable_attr_01 ppt_pl1_spl = {


