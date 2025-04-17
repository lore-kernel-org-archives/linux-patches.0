Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F901DE3A8;
	Thu, 17 Apr 2025 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913083; cv=none; b=IjN1lncgaL6y8giQDXD3oGM1hPPvxhgeNYBB4BRdZVTjiYzFVzhuJ3uBMxH5CuMCsz/2pkwSA7hyZb9re+UtbfpG3XWXdxLub0F5mJTdAvbpZviH4xO3CFQIyK3vvwTw8WnI4W0LRjOw2ReMOFBamgxjb1TL1J/bXeZe55Kv6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913083; c=relaxed/simple;
	bh=XprOxeYV2bDuscKUHTWmV2wADXd2cfEE2Ey1mNlLv2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2d+gwXhgJ3cWBV6o+XNSu1P+fv80oIhE0I/lk4D/S5a5Zqnz2Wi8yPg8GLrDjG92+Gb5KvKJW3pgUOAUY2l2XpZtt9vp289/7HPD/CijE3HHTKLXtU8lVXKiMfLJlgRqB4zgKScHHOzVaKXjgQiJnR8o1f9NlTT3c2rRRKuSns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OEhhoEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OEhhoEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FA1C4CEE4;
	Thu, 17 Apr 2025 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913083;
	bh=XprOxeYV2bDuscKUHTWmV2wADXd2cfEE2Ey1mNlLv2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OEhhoEOKwkKfPf5m6voGx12E8eX3VZZVQEyvh+b3XEdFPqhomtlCGNwlJf4JorPs
	 TeO0cnnIMlz7xRv/yYPPLNeoXjgU5eIcxxmITTid3DUmvww//4Z1BrMNfdUR9aO3sp
	 K5bq9PFNOTf5NJe5hx0+nI0ri61VmoGdtavNGgfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 221/449] media: uapi: rkisp1-config: Fix typo in extensible params example
Date: Thu, 17 Apr 2025 19:48:29 +0200
Message-ID: <20250417175126.863567377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit 7b0ee2de7c76e5518e2235a927fd211bc785d320 upstream.

The define used for the version in the example diagram does not match what
is defined in enum rksip1_ext_param_buffer_version, nor the description
above it. Correct the typo to make it clear which define to use.

Fixes: e9d05e9d5db1 ("media: uapi: rkisp1-config: Add extensible params format")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rkisp1-config.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/rkisp1-config.h
+++ b/include/uapi/linux/rkisp1-config.h
@@ -1528,7 +1528,7 @@ enum rksip1_ext_param_buffer_version {
  * The expected memory layout of the parameters buffer is::
  *
  *	+-------------------- struct rkisp1_ext_params_cfg -------------------+
- *	| version = RKISP_EXT_PARAMS_BUFFER_V1;                               |
+ *	| version = RKISP1_EXT_PARAM_BUFFER_V1;                               |
  *	| data_size = sizeof(struct rkisp1_ext_params_bls_config)             |
  *	|           + sizeof(struct rkisp1_ext_params_dpcc_config);           |
  *	| +------------------------- data  ---------------------------------+ |


