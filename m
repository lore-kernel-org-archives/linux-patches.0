Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68C51EA91;
	Tue, 27 May 2025 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365049; cv=none; b=JEOnwwwH8zNqISzmPV8PlBn/WJ4id/NxgTkY7oEVq3uFde7CnKCrFznnB4JGn3gZNAsmDo2I9IXkgANUA5Vzn6xVhPQWaGLRfoIABnSJNEcfX+CsvhAIofimak+35d7j2EtR+iuyhMKeFNf0p+FCRdN3fXgscSdZcuMDiMkwuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365049; c=relaxed/simple;
	bh=LTtUkadTrC4v3QHNS24DQ18V4kZ2kAo7eQmjTPhLHgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZmZhzasgtv6sV+5oB59IzR/ParXDE39o+7S9PlkJO3XY6yEgmQl2Vry6ciYaIR0qVFj3zXQ88vUVrHE6IJmy8iVDoFmU6TR5lvnb4uHs7WhOzBqv731ZMTYvBWxco39KEJK+V3BiRAZNTAKoobHdWf0110yoZZSNmqLYnIJPYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1YCSCO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1YCSCO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35014C4CEE9;
	Tue, 27 May 2025 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365049;
	bh=LTtUkadTrC4v3QHNS24DQ18V4kZ2kAo7eQmjTPhLHgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1YCSCO3gHwJ30GNE3J+9jiECfBrz+XoMQuoou5Fw34J6QItiTi6EoNaTbmSz7dyd
	 r3Upawchn/nj7F4Xf+2KOZWN6im0RxRdjQZaFKoi93TwXAArWp8E+aIbzl7tNCqY64
	 bcbvkBjcK7YHfl4KsKsbDKW4NaYD/pnKNiKSxdOg=
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
Subject: [PATCH 6.12 244/626] dpll: Add an assertion to check freq_supported_num
Date: Tue, 27 May 2025 18:22:17 +0200
Message-ID: <20250527162454.924535773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



