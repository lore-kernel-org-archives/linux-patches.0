Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A03E3C62;
	Wed, 20 May 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297190; cv=none; b=l6/GomAFDWKKZEr/vwlE51AFUrFT9SEYBk8QQ+dg0c2BceSouAEpaaylI/2lbYo3AU8sPu1k3urV30h1bnVuh/VCcDV3Fmw3J2Qlj8hk+wH3K+bAYzY+K5xEcc8/Wqc05YFAh0OmF4OzO8sITq3NuGZLzH18pWYfxL+BcGZOZus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297190; c=relaxed/simple;
	bh=YBLfWKW1YQ97LyyygH0/3J4tC+tHfufS60GL8+tXdr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVa/gMAHFcSOeYqhF2HsscSyj0WMT41yAMrE4W6it/1Qr6H8imOAGTtXBjzTjq5faP66tyVXeuI80RnAaT7ekW9wnVdETBg7qNPtfEDbRp5wL7puw2XGvVECURBsmWaTojZcGND524CQbwvzWRGdKQoqmh6f0exF6BQ5IJynx1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUsLKNQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUsLKNQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821591F000E9;
	Wed, 20 May 2026 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297186;
	bh=ru615WVqyzD/sTS7xK/NOlT7vpVMh/vStO9GX8aCXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUsLKNQbJtUNZmBJM2smvoE+lWDNZboRmbHmOtqdJZqtZ+XE1V/SDh4cIYfenEh+2
	 Y70Vm0+IT80STNGJsezzVxm+S9qLqyopVlCGe+3g9/OqZXG/jTxyG5h8HD3sSdbIGG
	 4/DG1sNESxfYk+a/A1LZEZOnGhwA8sFDMEpOylf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rong Zhang <i@rong.moe>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>
Subject: [PATCH 7.0 1082/1146] platform/x86: lenovo-wmi-other: Balance component bind and unbind
Date: Wed, 20 May 2026 18:22:12 +0200
Message-ID: <20260520162212.722552653@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

commit 2fe2504abcfa4f82a4208e8d0c21ec0f22baca43 upstream.

When lwmi_om_master_bind() fails, the master device's components are
left bound, with the aggregate device destroyed due to the failure
(found by sashiko.dev [1]).

Balance calls to component_bind_all() and component_unbind_all() when an
error is propagated to the component framework.

No functional change intended.

Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Fixes: edc4b183b794 ("platform/x86: Add Lenovo Other Mode WMI Driver")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260331181208.421552-1-derekjohn.clark%40gmail.com [1]
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://patch.msgid.link/20260510042546.436874-4-derekjohn.clark@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/wmi-other.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/lenovo/wmi-other.c
+++ b/drivers/platform/x86/lenovo/wmi-other.c
@@ -1067,8 +1067,11 @@ static int lwmi_om_master_bind(struct de
 
 	priv->cd00_list = binder.cd00_list;
 	priv->cd01_list = binder.cd01_list;
-	if (!priv->cd00_list || !priv->cd01_list)
+	if (!priv->cd00_list || !priv->cd01_list) {
+		component_unbind_all(dev, NULL);
+
 		return -ENODEV;
+	}
 
 	lwmi_om_fan_info_collect_cd00(priv);
 


