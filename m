Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07EC26B0BC;
	Thu, 13 Feb 2025 15:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459760; cv=none; b=sQOJE/Bl37LnUn1FQq+b+8WvK4vo49ExwOwROOKFIX0iZ8cHsK1LTAEHB6s3MXiFLNzRHntsOW16l7WDvrQ0k0KOMo2kkVPiUXKNoeh20uRo9y+y5YEDXKoARlSvhonve43lC0QbTyqL4abaNQX5MW/qwBCsCzaHa83HAFaWpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459760; c=relaxed/simple;
	bh=qbm7hXKbdtExBBVk+ps77kdh2DhW3I58IpAoS0CHbM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk2O/ZUFQtLIBkdS5MdAsquI5/gXS+poefZ8c8AtGC6J210qRFeBRpH8fHNgTTXnkqMPYcU+GzBxau3Lj+51Jx57kv0liFcY4UKNAwTayTTIa8kOFM7P/zv3XK5ihhXfg7bNIcHDsQm01UPh0sg4c503qNdtHc8fxao1VIuyJ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn2lhjqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn2lhjqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A46C4CED1;
	Thu, 13 Feb 2025 15:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459759;
	bh=qbm7hXKbdtExBBVk+ps77kdh2DhW3I58IpAoS0CHbM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn2lhjqyCm1qPPN8jTM4girp/e7hrCnYF0CBRt/lZfvQsFgmWs3kmYqASqYJCqCgu
	 LTEh5zMDQ3nrX7hAY/KuSk2y+NofvKEty+hAZpy74d3GfcAIILPXY/wj6eBldDINBM
	 g0m+XD+hDO7phLpTL6cdifU6Bdmb/QRuHRhakNSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 357/443] media: Documentation: tx-rx: Fix formatting
Date: Thu, 13 Feb 2025 15:28:42 +0100
Message-ID: <20250213142454.392259620@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit b76fb1f2c5a39e8e1b785e94a08448847fe4c626 upstream.

Fix formatting under "``.enable_streams()`` and ``.disable_streams()``
callbacks" in tx-rx.rst.

Fixes: 30fe661eb9d3 ("media: Documentation: Deprecate s_stream video op, update docs")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/media/tx-rx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/media/tx-rx.rst b/Documentation/driver-api/media/tx-rx.rst
index dd09484df1d3..b936065dd640 100644
--- a/Documentation/driver-api/media/tx-rx.rst
+++ b/Documentation/driver-api/media/tx-rx.rst
@@ -50,7 +50,7 @@ The :ref:`V4L2_CID_LINK_FREQ <v4l2-cid-link-freq>` control is used to tell the
 receiver the frequency of the bus (i.e. it is not the same as the symbol rate).
 
 ``.enable_streams()`` and ``.disable_streams()`` callbacks
-^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The struct v4l2_subdev_pad_ops->enable_streams() and struct
 v4l2_subdev_pad_ops->disable_streams() callbacks are used by the receiver driver
-- 
2.48.1



