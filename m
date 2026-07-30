Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866E3914ED;
	Thu, 30 Jul 2026 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422693; cv=none; b=Jat2ARlxbnp99eivxtejQgCyXXX95/Qxbgr8QzoyVq8ETWnmES4SSFrmE0BctT2YGyj+ft8jwb1WAGv2EMiiOtx0Yf5VKLYJccReCejst0a//il2QjLAdmjQ5CDWKneW1yPM6kL0kT7XvvVva3S7QcuKbHP9rvtummIVN2bPn1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422693; c=relaxed/simple;
	bh=o7Cjin77BxVQZQYsrtNFVQ107eR4uNALEC7WoT9Kil8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D0iSfQdQ9Zjiiq7mKk0I+iKJqn8Epbz+waGGK03YXTwP9JuZGiacuyqBUa2u0jDv0T9pKDUZHkjsm9d08+At/3bnAGINd+BqD5ElDccERfaZAP+kyuNJ9wkS5h6oHVT0qPxY4mh8QUUb98BjCGszjoQaZpNnzLdH9Z6xmbA2DpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6AG5dLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6AG5dLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9205A1F000E9;
	Thu, 30 Jul 2026 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422692;
	bh=rtzRf88PdC0JrXRMZ5VhJf2/OQlBxgU7Rlcm2uUQiq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6AG5dLB6eB9MQfu2+Cjgv4RDNA34Vr7jr9jR5iDRrdoO7cbecfOxeCeRw4ErOPYL
	 e/F0BydT/sPazO+f/O9pmFvL4+J/5R03MyBmXDxfv4vwqniJA3h+7xLmHOyvGQRch0
	 y7r03Sx0DbNQBhzwAsgESmaYvSiOaHiIOtU3Hvlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 525/744] media: uapi: rkisp: Correct name version enum
Date: Thu, 30 Jul 2026 16:13:18 +0200
Message-ID: <20260730141455.433678402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit c4c01c4fd4a3916ffdfb35ad9f511c48e289f51c upstream.

The name of the enum to hold the mapping of parameter buffer versions
have a typo in the name, correct it. While this is a uAPI header the
impact should be minimal as the enum is only used as a collection for
the one version number supported.

Fixes: e9d05e9d5db1 ("media: uapi: rkisp1-config: Add extensible params format")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260501190339.3449193-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rkisp1-config.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/rkisp1-config.h
+++ b/include/uapi/linux/rkisp1-config.h
@@ -1535,11 +1535,11 @@ struct rkisp1_ext_params_wdr_config {
 	sizeof(struct rkisp1_ext_params_wdr_config))
 
 /**
- * enum rksip1_ext_param_buffer_version - RkISP1 extensible parameters version
+ * enum rkisp1_ext_param_buffer_version - RkISP1 extensible parameters version
  *
  * @RKISP1_EXT_PARAM_BUFFER_V1: First version of RkISP1 extensible parameters
  */
-enum rksip1_ext_param_buffer_version {
+enum rkisp1_ext_param_buffer_version {
 	RKISP1_EXT_PARAM_BUFFER_V1 = V4L2_ISP_PARAMS_VERSION_V1,
 };
 
@@ -1601,7 +1601,7 @@ enum rksip1_ext_param_buffer_version {
  *	+---------------------------------------------------------------------+
  *
  * @version: The RkISP1 extensible parameters buffer version, see
- *	     :c:type:`rksip1_ext_param_buffer_version`
+ *	     :c:type:`rkisp1_ext_param_buffer_version`
  * @data_size: The RkISP1 configuration data effective size, excluding this
  *	       header
  * @data: The RkISP1 extensible configuration data blocks


