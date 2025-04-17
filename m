Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110D185920;
	Thu, 17 Apr 2025 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915730; cv=none; b=nSBSkW9qKs3Zry/v8WR5rQ9cEf8p80ga6ES2U0MV5FPnxm9ikQ6Av3dNMkol5rUDzOghIW9rvq6qCVgvln6IOIvNpKMmf7gtQAlmoJtQcd/CEqdW1yrNLR1CL0PiaTEKDuXimVS4cY57DrF7xTF64PyVZ5GdscJY9irav1hv7MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915730; c=relaxed/simple;
	bh=WFE1kXPsJ4RPeLgytRt6DMo5KWTXoxboWdM0PD3EiRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuieMLrWSGIqv51MVUckQQJh6QmvM+mT1e3QKsT0BLSy12XOD2rv84KRodHVouwFBNGCv+DxKEEK7VtylO3BdwWEi8ZGT1NdP39YR2NbXzyaUrtv7FLbzd4pFD6SScX3t8nlGXWf3UHQICSYZzH7dkJ0ugy11hufaO9YHzlX7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rO9vok3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rO9vok3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C62C4CEE7;
	Thu, 17 Apr 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915730;
	bh=WFE1kXPsJ4RPeLgytRt6DMo5KWTXoxboWdM0PD3EiRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rO9vok3tl0WjECehO7u+KigCz2luUPw96dCb9bpS9l68q43uAQnYGNcJU2c0COYk6
	 C5s0nXXRMtIk/UCwXvXYcJB9JIXfRJO+VATS2VeKfL76aH95c7uzJ1G6L9MGeMuCA5
	 qjrbGbsVXswgzzaHGWQq+WwdgTxIZRymJavBqqeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 191/393] media: uapi: rkisp1-config: Fix typo in extensible params example
Date: Thu, 17 Apr 2025 19:50:00 +0200
Message-ID: <20250417175115.268900189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 include/uapi/linux/rkisp1-config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/rkisp1-config.h b/include/uapi/linux/rkisp1-config.h
index 430daceafac7..2d995f3c1ca3 100644
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
-- 
2.49.0



