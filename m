Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAC275B0E;
	Tue,  5 Aug 2025 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399501; cv=none; b=QxZkbW55WQH6mDlBU1RcW845nxH2TgnGpTLsKchBjtLDREEFR6VRcjtzV9j2mkbnGcwGY2zJ2XBTyT6IJv9MQ0KDFNp4+bARU4xIYjbZcaYMeyAznayZ24I4enpsOeiDv+8Hr80pd3ycjNkWbc3NcIhZhSdXj+tVecVGtSHeMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399501; c=relaxed/simple;
	bh=0xtrlarNGIWrm9wSK4aAU0pwBHqJXMqapeh/WXq+Ffw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7HUNKqLGJBd3x6Vro9AiUbwr+3STtYnbQ6ad7icIskWkEQqs+UpzhR+47Y5Ry0j4p22Cxd3aDUR0SYxY8VdCadISCInlVBGnUG75N9wBYXCrYGgQhESmoaph/ghKYDPegX9Ob9kiq0CqSUMIcQTm6fCb8ZyRiZq5q4enoISi/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1Wvxjma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1Wvxjma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E4EC4CEF7;
	Tue,  5 Aug 2025 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399501;
	bh=0xtrlarNGIWrm9wSK4aAU0pwBHqJXMqapeh/WXq+Ffw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1WvxjmaqBwowu9TNZSd/Ig6mIyb6ojToA9juX32U5lHmv1Xq+xPO/f1jYwUe1c1P
	 G2ilmb0FWLRT07rSeNKRYHn5D+sNkJ3OUcRBjomcqmUEEJGKrVQ93ldlO0hxJmg6JN
	 qBtt3xZR5aiRjokhUNUpxz50TyC5M0dl1TNjErTHAmURJgRn9kXEAaEsVPCjmGfC9n
	 nIGp0zBI3r54dElZUtyUgkWsbhnXGPtvXPAqLQ96GEu+pdI35+rqyZDC/n3ZYxtFPm
	 iUrAcwNwDaLBFO/2MruwQPC18lEgy1Jfh0N8yI3l15pjyYSvcOABLzwNIUPNNnLRd9
	 9NoPkjFWg/wTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	nicolas.dufresne@collabora.com,
	laurent.pinchart@ideasonboard.com,
	jonas@kwiboo.se,
	m.szyprowski@samsung.com,
	mehdi.djait@linux.intel.com
Subject: [PATCH AUTOSEL 6.16-5.15] media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control
Date: Tue,  5 Aug 2025 09:09:26 -0400
Message-Id: <20250805130945.471732-51-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 5a0abb8909b9dcf347fce1d201ac6686ac33fd64 ]

When operating a pipeline with a missing V4L2_CID_LINK_FREQ control this
two line warning is printed each time the pipeline is started. Reduce
this excessive logging by only warning once for the missing control.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the issue. Every time a V4L2 pipeline is started (which
happens when streaming begins), the `cio2_hw_init()` function is called,
which eventually calls `v4l2_get_link_freq()`. If the V4L2_CID_LINK_FREQ
control is not present, it prints two warning messages. This happens
EVERY time streaming starts, which can be frequent in normal camera
operation.

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a user-visible annoyance/bug**: The commit addresses
   excessive logging that occurs every time a V4L2 pipeline is started
   when the V4L2_CID_LINK_FREQ control is missing. These two-line
   warnings are printed on each pipeline start (during `start_streaming`
   operations), which can happen frequently during normal camera usage,
   leading to log spam.

2. **The fix is minimal and safe**: The change is extremely simple - it
   only replaces `pr_warn()` with `pr_warn_once()` for two warning
   messages. This change:
   - Has zero functional impact on the driver operation
   - Only affects logging behavior
   - Cannot introduce regressions in functionality
   - Is confined to two lines of code

3. **Clear bug fix, not a feature**: This is purely a bug fix that
   reduces excessive logging. It doesn't add new features or change
   architectural behavior. The warnings were introduced in commit
   67012d97df931 (Feb 2021) and have been causing log spam since then.

4. **Affects real users**: The warning occurs in common V4L2 camera
   drivers (ipu3-cio2, ipu6-isys-csi2, mei_csi, rcar-csi2, etc.)
   whenever they start streaming and the transmitter driver hasn't
   implemented V4L2_CID_LINK_FREQ control. Many camera sensors don't
   implement this control, making this a widespread issue.

5. **Follows stable kernel rules**: According to stable kernel rules,
   patches that fix "annoying" issues that affect users are candidates
   for backporting. Log spam that occurs on every camera stream start
   definitely qualifies as an annoying issue.

The commit is a perfect candidate for stable backporting - it's a
trivial, safe fix for a real user-facing issue that has been present in
the kernel for several years.

 drivers/media/v4l2-core/v4l2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index bd160a8c9efe..e1fc8fe43b74 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -505,10 +505,10 @@ s64 __v4l2_get_link_freq_ctrl(struct v4l2_ctrl_handler *handler,
 
 		freq = div_u64(v4l2_ctrl_g_ctrl_int64(ctrl) * mul, div);
 
-		pr_warn("%s: Link frequency estimated using pixel rate: result might be inaccurate\n",
-			__func__);
-		pr_warn("%s: Consider implementing support for V4L2_CID_LINK_FREQ in the transmitter driver\n",
-			__func__);
+		pr_warn_once("%s: Link frequency estimated using pixel rate: result might be inaccurate\n",
+			     __func__);
+		pr_warn_once("%s: Consider implementing support for V4L2_CID_LINK_FREQ in the transmitter driver\n",
+			     __func__);
 	}
 
 	return freq > 0 ? freq : -EINVAL;
-- 
2.39.5

