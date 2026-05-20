Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393353EF0C1;
	Wed, 20 May 2026 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299848; cv=none; b=oSjEuMHKn2xupNvbRchAskFQt4ESTjLWVBl5KtVBBsw+hTmYpIKn8gEzh4P9xMan4QqhriIJ7Y/5ZxnX7A+KUrgIPV4783X0rsMaAFBdIGdIVSkMJFaNulgCFA/vYTrqIPXyFwQ5+i/3xx15MLNZz8u+7ETuWb3+UNcQDbJ4cW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299848; c=relaxed/simple;
	bh=r75JDSRshUqcDCKyjsQ/ndPGG1S+LcBItbD6mhpIqZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PO5Rv0A+yvdIWbI0PuErA92oRvDHZ9j2xBxMpAEBRzk9sOb4X+HYkcLuCcnL67P+lXL2c9+5OnWpgtfsDAOKtb81uMJAfvQTQOmQFy7qeXbZg9BZRMTrwD3PI8QgHaJRH2ikP2CF8LR79+XIvMrAvO9//PJ2oiY/506c5L+EZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF2wCST5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF2wCST5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE221F000E9;
	Wed, 20 May 2026 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299847;
	bh=QbUwQgQWHQCNR5zuT/ITQD1eOaO9M/LXTvDokeK9KuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SF2wCST5IHWL+i+d3k9CSl9wwHR94f7eOnaUx3ZjGZ9FryOVadv93BfSbz860fLuA
	 eLg1h6rI1OnzKaSYjTcUbvvQCO52RkxfrwdBYQscLQNhKRsRPGJGcoKWsBq7zNvaJr
	 MzSlEgFXmEGLrSeV8rubwVyTwOS2PpcNf/8NWOn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Rong Zhang <i@rong.moe>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 909/957] platform/x86: lenovo-wmi-other: Fix tunable_attr_01 struct members
Date: Wed, 20 May 2026 18:23:12 +0200
Message-ID: <20260520162154.288513967@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -82,11 +82,10 @@ struct lwmi_om_priv {
 };
 
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


