Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B9F252915;
	Thu, 17 Apr 2025 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914390; cv=none; b=HO6LMiFkkhzH/2ydlmmBUFYpBRUxUW/Eg6NPx1Ax4WevbwmPt2JI+gFmMwUxBhr4UpU06JvOVKRTplDEFFUoLBziEYhwI+Q4Z5h721QlQ3WOXmiR6NftHWOUGdLbbiUcZErO44VfzggXrezQnsZ0yA0E5CwLuHSeJvML4uSS5Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914390; c=relaxed/simple;
	bh=x79pE/8h2SV5YXZkp/YfCe3fHdJqTHnnjAVj5th5xgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxBP/6PRYFnfLpsBgvKkexxv3lN219wHISWZr8289hSM+BJl4az65YfB48aqtQjVH2bjkl0s0FLrJOi84JL1ZRqZK9yeG6w+dsHVBNAc1RPajDcxnVLCuzKmQzFqGRryCZQgUZz9ifqfITkNU5oS00+/hdd4NTI8t3U++y+lLRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opthEdpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opthEdpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF78C4CEE4;
	Thu, 17 Apr 2025 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914390;
	bh=x79pE/8h2SV5YXZkp/YfCe3fHdJqTHnnjAVj5th5xgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opthEdpRxG5BmG1raTOlpOKJ+E0zoZHXkxsZ1OqWlMQGzXSxdcSHoWRCt1962C8+E
	 suzeZ6g9450b5HBte22hL67pcNQkPikKBiyCsbUWPGJ5StwX30eqySFnRDCk9/7M07
	 Lu65GAxrKmBAl51LtRsmi/iqm3eNFjLTGnegINEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 199/414] media: uapi: rkisp1-config: Fix typo in extensible params example
Date: Thu, 17 Apr 2025 19:49:17 +0200
Message-ID: <20250417175119.447370763@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


