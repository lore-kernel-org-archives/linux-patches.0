Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D95247280;
	Tue, 29 Apr 2025 17:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947453; cv=none; b=gLYXuP65HBQGHQKNqxor7LtpXvogLvH7fTd+BL+8pCLntnoIdEr+xhuURcGNYCPmiQQPBgz05Ow61r0zCOrrjPSMkoEyFiq487pTPXmBUAshz25072Rdcn07rELjmjwJGHj3c0rCLSu9nyrBMDEJTJufKE9BZhXfqhF+IWFZxwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947453; c=relaxed/simple;
	bh=PGzjBPu36/8xmyl1zwlxPhwzqtEW5JCG6DrWgZwavEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW4DNN6s3SuGhv2aBK5jpSraGwc8VQ20iXMw9H5v6bF3QOIc6+2ro9kDovDh+QpOG0LuyBUE2N7P9lOfDbU664DinNzlRaY/lJRFBqmdagNZz5JU3owTxyiu6Hsy3AJBSGWaZl8EMiqPgED3t0a4vAv6nfuODmMkcut8ejAOLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9i+d/aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9i+d/aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB14FC4CEE3;
	Tue, 29 Apr 2025 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947453;
	bh=PGzjBPu36/8xmyl1zwlxPhwzqtEW5JCG6DrWgZwavEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9i+d/aN1ci8PLLoOjDV5iIsLWPhbpIYxMv5pLW7pUs9grpkjuOSOLTwIQXRnX9Vo
	 Cgy8bQGijQO5imi+5JJ6YXxw/OD6JnCWdIIdpYSmfJX4j/FVBtCFnX2TdRvILSfIjc
	 v+UkwbvoYt/kxHfR4SMvyAwGhbj2Vi8Flzh85U8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 285/286] media: venus: Fix uninitialized variable count being checked for zero
Date: Tue, 29 Apr 2025 18:43:09 +0200
Message-ID: <20250429161119.635131259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit c5b14df7a80acadbbd184808dc3f519fbb2ab96c upstream.

In the case where plat->codecs is NULL the variable count is uninitialized
but is being checked to see if it is 0. Fix this by initializing
count to 0.

Addresses-Coverity: ("Uninitialized scalar variable")

Fixes: e29929266be1 ("media: venus: Get codecs and capabilities from hfi platform")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -266,7 +266,7 @@ static int hfi_platform_parser(struct ve
 {
 	const struct hfi_platform *plat;
 	const struct hfi_plat_caps *caps = NULL;
-	u32 enc_codecs, dec_codecs, count;
+	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
 
 	if (inst)


