Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01A7262FE5;
	Tue, 22 Apr 2025 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745356843; cv=none; b=i2mMZQvFrzzM3i69PuQYcMI+KfIgBtheKe0rdSg03H5usdBnLlWGeoZTKsvS2+yQ6H0xxw81Wz6VTtVLf3yeT/jnJj214eZGU+3qZmmyUyy/KceP6Kxe2eLUVrJUrx79G7D/6v1RAn6G8KJg0prYQ04KNc/HlGZKuidlYLvQRNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745356843; c=relaxed/simple;
	bh=z6h70dUt9zR+4VQYnH+S3AFzwnir8dvU/vYmRnBDUOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kslNQ8MjcwTojlXin0VLPXzDs1I4MaXeBddU4WKXUJ/odq3SGoBR1FvuPZrzN61iC7kQJavojuZpMNNExk9msa4mjLvumcSEBS6FmEb8T5EtQ1jMXuK7ONgjzdEUNpLVwPhYuCDLCNUE5DGzQGQMJIUQbKK7kZQPM2aWNPsc29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1psrgum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1psrgum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C737C4CEE9;
	Tue, 22 Apr 2025 21:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745356843;
	bh=z6h70dUt9zR+4VQYnH+S3AFzwnir8dvU/vYmRnBDUOw=;
	h=From:Date:Subject:To:Cc:From;
	b=f1psrgum1tL7uv2t+fxNrT7x9wS1ZmSR0RS+GXR1LEbSGNZR57Wgu+SXNWlzAoLSH
	 QDIT5VcAt00ucCz4+byGCNCGHvavqtWLcI43/qbC7iuaXILNakXrv9V7KR/FqMaC3J
	 c4nptvuDK3VU/U8UDv9Da0mzjVjwdKxtAfL8zUn0o8lyKpxb8KHvSq+mTVaupM4mSh
	 kx2WPT4oVhr3Ip17itOyxRCBNYJgpPTNWfFcgS1S4UdFZklog3H/wu0fKE1diaq/Wa
	 0zzcdhb8vaWDKkrSb9Q/QUHiHREnohKklQnK129orgayDsx3yLxjCHQNgHN3CZUG6V
	 fYokdomlEVbVA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 22 Apr 2025 14:20:30 -0700
Subject: [PATCH] drm/panel: himax-hx8279: Initialize goa_{even,odd}_valid
 in hx8279_check_goa_config()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAB0ICGgC/x2NwQqDMBAFf0X23IV0Vaz9leIh1bV5YKIktoSK/
 97Q48Awc1DSCE10rw6K+kHCGgpcLxWNzoaXMqbCJEZa04jwZoMu7OBtZpdv0vU8I3Nave7wmvg
 dELDDLvjqxGK6um3mZ1+bkUp0i1r0//AxnOcPvqyJ6oAAAAA=
X-Change-ID: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2603; i=nathan@kernel.org;
 h=from:subject:message-id; bh=z6h70dUt9zR+4VQYnH+S3AFzwnir8dvU/vYmRnBDUOw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBkcHBp/Tq75q16scWjdh/exrhuFZwXNUA23n5/e+FDvQ
 tZmQYbSjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARp6MMfyUyHgZzhpx+ztb4
 0+6STPa9/dsifH8+C9HSKl4sV7pFvYeRYcGa84vUFL27UvLvvonlCz+/raJSjDc+Ped3JWfmS7Y
 jvAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 'goa_even_valid' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
    838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use occurs here
    842 |         if (goa_odd_valid != goa_even_valid)
        |                              ^~~~~~~~~~~~~~
  drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if its condition is always true
    838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    839 |                 goa_even_valid = false;
  drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the variable 'goa_even_valid' to silence this warning
    818 |         bool goa_odd_valid, goa_even_valid;
        |                                           ^
        |                                            = 0

Even though only the even valid variable gets flagged, both valid
variables appear to have the same issue of possibly being used
uninitialized if the if statement initializing them to false is not
taken.

Initialize both values to true to clear up the warning and remove any
possibility of encountering undefined behavior.

Fixes: 38d42c261389 ("drm: panel: Add driver for Himax HX8279 DDIC panels")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/panel/panel-himax-hx8279.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx8279.c b/drivers/gpu/drm/panel/panel-himax-hx8279.c
index b48b350b62da..92f351e66c25 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx8279.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx8279.c
@@ -815,7 +815,7 @@ static int hx8279_check_gmux_config(struct hx8279 *hx, struct device *dev)
 static int hx8279_check_goa_config(struct hx8279 *hx, struct device *dev)
 {
 	const struct hx8279_panel_desc *desc = hx->desc;
-	bool goa_odd_valid, goa_even_valid;
+	bool goa_odd_valid = true, goa_even_valid = true;
 	int i, num_zero, num_clr = 0;
 
 	/* Up to 4 zero values is a valid configuration. Check them all. */

---
base-commit: dcbd5dcc956e2331414fd7020b4655df08deeb87
change-id: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

