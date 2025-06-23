Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7200D16419;
	Mon, 23 Jun 2025 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685976; cv=none; b=asrAWvT1oNYeIESqnpTphdJc37p0ZLTjEpng/8V0xpEd+bEArKNsqdMFUj3xbYG95sacIvmWlQRBORSkXwUc+/naSNWa7T5JKmX4NSIUYv4rZ3M/9WKXexuTZNuyOrZ4XpERzRK2wYJOcWhbwiZG1zAKWEIbFsfOABSY9oK8o5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685976; c=relaxed/simple;
	bh=CdexktZbFwoDXiMcXYQDtNxD/z+zO85y40LY9sQS7VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGrKGhO7hxpxGrsUf0prk2sIoJP78Cwjt5x7O3VaARLDCNsSjCeogdt05axlr6QGZqYOpfkz/gHLk4f2ujIxIR8tDvc8LxZIt0MY6E8T5W49FafGM73Dyj06OLpSaYijs6g04n5V9xSfvtT2lzQmVifZQMo331Ivh8VSyBx9BIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GArBciU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GArBciU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08899C4CEEA;
	Mon, 23 Jun 2025 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685976;
	bh=CdexktZbFwoDXiMcXYQDtNxD/z+zO85y40LY9sQS7VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GArBciU6BaQyhU6NX3uDEacxaBBqZ4f0xep1SBTPBNEOgE+YuyjWxpjt4WemLW8a/
	 et+G2P5Yl0aQhrIn3zp27HrOPPZO8L/dozHgIpek+szLra6aM6M+fIElSKgRkpQ0KY
	 2RcLlKWDmGpXok9Zw425jDegVFZdCXAS1yLFUoF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 274/592] drm/ttm/tests: fix incorrect assert in ttm_bo_unreserve_bulk()
Date: Mon, 23 Jun 2025 15:03:52 +0200
Message-ID: <20250623130706.851589080@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 878516a9e62cd220379e511d43dcf58df3a6ca9f ]

In the ttm_bo_unreserve_bulk() test function, resv is allocated using
kunit_kzalloc(), but the subsequent assertion mistakenly verifies the
ttm_dev pointer instead of the resv pointer.

Fix the assertion to properly verify the resv pointer.

Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250313161424.10688-1-qasdev00@gmail.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index f8f20d2f61740..e08e5a138420e 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -340,7 +340,7 @@ static void ttm_bo_unreserve_bulk(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, ttm_dev);
 
 	resv = kunit_kzalloc(test, sizeof(*resv), GFP_KERNEL);
-	KUNIT_ASSERT_NOT_NULL(test, ttm_dev);
+	KUNIT_ASSERT_NOT_NULL(test, resv);
 
 	err = ttm_device_kunit_init(priv, ttm_dev, false, false);
 	KUNIT_ASSERT_EQ(test, err, 0);
-- 
2.39.5



