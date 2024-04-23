Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B5214388F;
	Tue, 23 Apr 2024 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908515; cv=none; b=WN1jCNdh9uLilNe2RsXXBUNNQKHUg0IEvvWMZwyQstFLV7JAqA3PN0YHzck+A6hI/pfy/XJ/E8GEpCn9F8xa0+3d80kT8dUnp25irbByChzaBQ6Ibnjx2FXj80X3h3FcoxwqAfN3t+aRlCYtULD8YpOYL3YGdLozwzwZSlkrtnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908515; c=relaxed/simple;
	bh=hA/ZXB19vzkMkhbBcOlL0GrEIbQ1TPM81E0ZL+KTO8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOalfTp8ucgsUL2abgCBZsqvLpOke4NxCU+ds9jQsKs4Ez9Giya3xRV5hvcRhnd1MYyxeCSnaUMjg4FXHlo4RGufE26C3SFY48cj/RgNIH3YsbKiO6oGUWLOFeatNcl0aW8A+ldKcM003ayfaNDwzKod4/GEWQSP1muRIHgyF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nHNEVF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nHNEVF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D924C3277B;
	Tue, 23 Apr 2024 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908515;
	bh=hA/ZXB19vzkMkhbBcOlL0GrEIbQ1TPM81E0ZL+KTO8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nHNEVF1fk7/aQkYpKxeSAGEbUG8s5pPnAuBmNnjF8aT+WV90en2lWgX+bZQ72ryQ
	 B2QqK0ez8cYLIvGF89DmGq5Za7UqXvmVXgMHsa+ggm820PVMUJWGtZ8IOcjvgUiQI9
	 DhX/JAcIleyN2gRkWCx35LshbTPT6F7Zk+7g0aDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Geetika Moolchandani <geetika@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 084/158] selftests/powerpc/papr-vpd: Fix missing variable initialization
Date: Tue, 23 Apr 2024 14:38:26 -0700
Message-ID: <20240423213858.677659896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 210cfef579260ed6c3b700e7baeae51a5e183f43 ]

The "close handle without consuming VPD" testcase has inconsistent
results because it fails to initialize the location code object it
passes to ioctl() to create a VPD handle. Initialize the location code
to the empty string as intended.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 9118c5d32bdd ("powerpc/selftests: Add test for papr-vpd")
Reported-by: Geetika Moolchandani <geetika@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240404-papr-vpd-test-uninit-lc-v2-1-37bff46c65a5@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/papr_vpd/papr_vpd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/papr_vpd/papr_vpd.c b/tools/testing/selftests/powerpc/papr_vpd/papr_vpd.c
index 505294da1b9fb..d6f99eb9be659 100644
--- a/tools/testing/selftests/powerpc/papr_vpd/papr_vpd.c
+++ b/tools/testing/selftests/powerpc/papr_vpd/papr_vpd.c
@@ -154,7 +154,7 @@ static int dev_papr_vpd_null_handle(void)
 static int papr_vpd_close_handle_without_reading(void)
 {
 	const int devfd = open(DEVPATH, O_RDONLY);
-	struct papr_location_code lc;
+	struct papr_location_code lc = { .str = "", };
 	int fd;
 
 	SKIP_IF_MSG(devfd < 0 && errno == ENOENT,
-- 
2.43.0



