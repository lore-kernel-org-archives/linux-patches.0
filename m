Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4123427A133;
	Tue, 27 May 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367154; cv=none; b=pwLDnslZjUMAm6pJDNvHYBJlgo2SQCjmhfvAjYpG1+BO4L5giTdu6MaPIASNvvRfoYPwhP2lE8eKJWKqLfpXTxPYMVtOCY073h93izi9WNkkchZP4gv39DF21CT6eXANuGj51Xn9lbyTOh7VFn9KvS3cMqpienmzq66mU9KC37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367154; c=relaxed/simple;
	bh=2l1WhAC0EJYJmwWAhB4smhRYRuCyQd1c9QAmoJJ6UHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJeHVQZndzrOMH2stwbanrOFtAY1QEt0pfPDN/7d/nO4B0CJRdEg/cmimeR33AoWjSPTml3K4LJM59LsWoxHkbMgzI0c94Q2B2xZMfbA9QcaqcAVwLVsR98V/FRz4zhyT5pkGjBf/Le2nb2+DNOqaZxejvq8rr7u+irJm4UZxRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSLZgNM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSLZgNM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A454BC4CEE9;
	Tue, 27 May 2025 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367154;
	bh=2l1WhAC0EJYJmwWAhB4smhRYRuCyQd1c9QAmoJJ6UHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSLZgNM3KMcpPJJblTv1hE7zcfBatDVxvPeemTZqfySqvMNX3Znj+I96/fAsLGxCO
	 007n+vsVcPE7NkDTPJpWwMTeuQEYKOZlXg2vzFBiYmBpAsZK1dzXtHGJrc+xutag7x
	 87JBVETn7E4pf/J5ehmkbJU1GLJVTHOe1NYLGlYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 296/783] dpll: Add an assertion to check freq_supported_num
Date: Tue, 27 May 2025 18:21:33 +0200
Message-ID: <20250527162525.133549069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 39e912a959c19338855b768eaaee2917d7841f71 ]

Since the driver is broken in the case that src->freq_supported is not
NULL but src->freq_supported_num is 0, add an assertion for it.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20250228150210.34404-1-jiashengjiangcool@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 1877201d1aa9f..20bdc52f63a50 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -443,8 +443,11 @@ static void dpll_pin_prop_free(struct dpll_pin_properties *prop)
 static int dpll_pin_prop_dup(const struct dpll_pin_properties *src,
 			     struct dpll_pin_properties *dst)
 {
+	if (WARN_ON(src->freq_supported && !src->freq_supported_num))
+		return -EINVAL;
+
 	memcpy(dst, src, sizeof(*dst));
-	if (src->freq_supported && src->freq_supported_num) {
+	if (src->freq_supported) {
 		size_t freq_size = src->freq_supported_num *
 				   sizeof(*src->freq_supported);
 		dst->freq_supported = kmemdup(src->freq_supported,
-- 
2.39.5



