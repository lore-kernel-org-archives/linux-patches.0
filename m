Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6F346AFB;
	Fri,  7 Aug 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114537; cv=none; b=X3xctBmJ6zTH7Io054GnaXq9KYZunRRdZUnpKjtauaIyL2OzxHKpsWV3JP76v72yVzA2w9Leyms9ebGukfGJdDMs8lh+TET+dVQhjhng3k5e+u52DHpKi1GnwKFZCPYxMFm1IfUJA8OMp1eNOsbHn3banSmhDtJQ7KqeVsfUCzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114537; c=relaxed/simple;
	bh=zTVwVtVaRhmmZK6kwBMgjSu59REU6IvtKXnFYGnvt2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JL8lP3YdAlsCJCJWn5B3l5Z93Srq10KykrBrkM1UL/KVn3egPPi/DcyldKmDJnFF+xtn1qGTIqDfeqOi/RA8hWr5XE+tZdy9pcpoOXWoXyf1CB+rvuEDWFh9RRF76hT0lTLZKNUu95U03/D8OlOA8CiQlyV89djGejzTbRfcHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQ4W5RHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQ4W5RHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DB1F000E9;
	Fri,  7 Aug 2026 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114536;
	bh=ZhNtPM4QARyJJXjMxf2swM6RXbeHuRqwQC4TJVREq7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQ4W5RHmBbDrpnZWnlHwCjoP35FDoaNWeI9ICRNg8XuKUHjKRhFeHbcYExSNRVY0i
	 CGPi7ZTgbs31eiIJ6qNs0U4Xam2DoE12rXxXc78/JDv1FOXpzP6aP/KBnQTVrgoPXU
	 WwG2c/R2eKxGbEUPHu0WVq5N396N6pbVH98KnzAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/337] media: uapi: rkisp: Correct name version enum
Date: Fri,  7 Aug 2026 16:38:20 +0200
Message-ID: <20260807143424.965283786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit c4c01c4fd4a3916ffdfb35ad9f511c48e289f51c ]

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
[ Adjusted context to keep the tree's `RKISP1_EXT_PARAM_BUFFER_V1 = 1` initializer instead of upstream's `V4L2_ISP_PARAMS_VERSION_V1`, which does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rkisp1-config.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/rkisp1-config.h
+++ b/include/uapi/linux/rkisp1-config.h
@@ -1487,11 +1487,11 @@ struct rkisp1_ext_params_compand_curve_c
 	sizeof(struct rkisp1_ext_params_compand_curve_config))
 
 /**
- * enum rksip1_ext_param_buffer_version - RkISP1 extensible parameters version
+ * enum rkisp1_ext_param_buffer_version - RkISP1 extensible parameters version
  *
  * @RKISP1_EXT_PARAM_BUFFER_V1: First version of RkISP1 extensible parameters
  */
-enum rksip1_ext_param_buffer_version {
+enum rkisp1_ext_param_buffer_version {
 	RKISP1_EXT_PARAM_BUFFER_V1 = 1,
 };
 
@@ -1563,7 +1563,7 @@ enum rksip1_ext_param_buffer_version {
  *	+---------------------------------------------------------------------+
  *
  * @version: The RkISP1 extensible parameters buffer version, see
- *	     :c:type:`rksip1_ext_param_buffer_version`
+ *	     :c:type:`rkisp1_ext_param_buffer_version`
  * @data_size: The RkISP1 configuration data effective size, excluding this
  *	       header
  * @data: The RkISP1 extensible configuration data blocks


