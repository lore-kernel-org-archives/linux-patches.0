Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C255194098;
	Sat, 14 Feb 2026 01:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031117; cv=none; b=mbHDhNeMX80AEIYybji3FGrebT57S+Us3X8GlbppBSv1wByCGns+wnwTQ6CI1s4CcvS0rwXWLPa0/cLbnU4UMxw2tQDJgMol/YZSPwzrfXm4+sKqX5lhDGgmuVAUN4FUL7GLYbb6DlEs7j9aslu7r1DC8yVFi2F4qTrKAVxOTJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031117; c=relaxed/simple;
	bh=XBELFG+UwzVL6/9w3rVTCouVdz7B66cYIoFuqTp8KNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNbWmr5YP879SXkfdqqhAcHgwNaTJrJzm3VlCqYD+pJ2ChND3XDHa3iCl8lyrHwk3jwlE5rZ+dgLbfqqFuOvtD8jj0tmmbXecQ4+bGmBAXq2cpo4iwk7zBFO6yV8vC2HC8xn0rlyvV0sMCj+soockG9QSJxcSicC6m9Cv1jsknQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cE6nOPBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cE6nOPBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CF5C116C6;
	Sat, 14 Feb 2026 01:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031116;
	bh=XBELFG+UwzVL6/9w3rVTCouVdz7B66cYIoFuqTp8KNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE6nOPBdvC1yYQtDKn7ljwNW+dWuRnTLWBoIeJFnO8u1AuXR7otJQZR9IolRS4ETx
	 dMYYbWgdIKsh7iiGeP3KRR6oNsl3zBj+BDGDzjKkf3IQgo0TnRmjcqVmE/b66aAPB8
	 aSxBLSt7flaJ0/DxVsOKudJSVMtKGq/N0trRxPsQFEE9OJf/pAYsxUkhciL7DZDSht
	 ROviK9XiJn7AJN1TnJ89HuNR+0jT1SLlDM5OytUjcIkxeAdLBUq8iqzC3yqyC6HDqb
	 T7ZmPQxabwdHJLkW1WTeMbXB1u/g5ZdzBetH9MdEMlirHB0GeYO3X0ZEfZCRByWY3d
	 zAdZmx7Ia1Z8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rfoss@kernel.org,
	todor.too@gmail.com,
	linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] media: qcom: camss: Do not enable cpas fast ahb clock for SM8550 VFE lite
Date: Fri, 13 Feb 2026 19:59:08 -0500
Message-ID: <20260214010245.3671907-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit a89e490ba3551823511588b7b3828d67f8b82954 ]

The clock is needed to stream images over a full VFE IP on SM8550 CAMSS,
and it should not be enabled, when an image stream is routed over any of
two lite VFE IPs on the SoC.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

SM8550 CAMSS support was added in v6.15. This means the fix would only
be applicable to 6.15.y and newer stable trees.

### Impact Assessment

- **Who is affected**: Users of SM8550-based devices (Qualcomm
  Snapdragon 8 Gen 2 platforms) using the camera lite VFE paths
- **Severity**: This is a correctness fix — enabling the wrong clock
  could cause streaming failures or incorrect behavior on VFE lite paths
- **Scope**: Very narrow — only SM8550 CAMSS lite VFEs

### Decision

This is a small, well-contained hardware configuration fix that corrects
incorrect clock settings for SM8550 VFE lite IPs. It:
- Fixes a real bug (wrong clock enabled for lite VFE IPs causing
  incorrect behavior)
- Is extremely small and low-risk (only static data changes)
- Is obviously correct (lite VFEs don't need the full VFE's fast AHB
  clock)
- Has proper review (Acked-by subsystem maintainer)
- Falls into the "hardware quirk/workaround" category

The fix is similar to a device tree correction — it fixes incorrect
hardware resource descriptions in static driver data. While the SM8550
CAMSS support is relatively new (6.15+), the fix is safe and beneficial
for users of that hardware.

**YES**

 drivers/media/platform/qcom/camss/camss.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index fcc2b2c3cba07..757c548af485a 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -2704,12 +2704,11 @@ static const struct camss_subdev_resources vfe_res_8550[] = {
 	/* VFE3 lite */
 	{
 		.regulators = {},
-		.clock = { "gcc_axi_hf", "cpas_ahb", "cpas_fast_ahb_clk", "vfe_lite_ahb",
+		.clock = { "gcc_axi_hf", "cpas_ahb", "vfe_lite_ahb",
 			   "vfe_lite", "cpas_ife_lite", "camnoc_axi" },
 		.clock_rate = {	{ 0 },
 				{ 80000000 },
 				{ 300000000, 400000000 },
-				{ 300000000, 400000000 },
 				{ 400000000, 480000000 },
 				{ 300000000, 400000000 },
 				{ 300000000, 400000000 } },
@@ -2726,12 +2725,11 @@ static const struct camss_subdev_resources vfe_res_8550[] = {
 	/* VFE4 lite */
 	{
 		.regulators = {},
-		.clock = { "gcc_axi_hf", "cpas_ahb", "cpas_fast_ahb_clk", "vfe_lite_ahb",
+		.clock = { "gcc_axi_hf", "cpas_ahb", "vfe_lite_ahb",
 			   "vfe_lite", "cpas_ife_lite", "camnoc_axi" },
 		.clock_rate = {	{ 0 },
 				{ 80000000 },
 				{ 300000000, 400000000 },
-				{ 300000000, 400000000 },
 				{ 400000000, 480000000 },
 				{ 300000000, 400000000 },
 				{ 300000000, 400000000 } },
-- 
2.51.0

