Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C9F219A7E;
	Mon, 18 Aug 2025 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524136; cv=none; b=ATR6fGP2uNXnwsGHYqNhk2fG8gV3dosUqu+2/DvAcSvxYdSEirYAUC5g1HRMWL3wLZrNhcGiSliDPf0CR6MYvo5GIfUjiSe3Nxe6DyO3a6b8QglZHuSCDI/2s4Xtvz7yC2ubGQmcew9oCU3K1eP0HW14aZf5m/dtmnYwybO2KOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524136; c=relaxed/simple;
	bh=860MXo3kAl6KkA3RDZDG9KLv9jI9XrpAXKUe4XTs93o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2wBYHRc3fqE/WU8a8+4dA2oahWzlDDSdvaChdP6WJ66ic+Tgd1ksVPUi+E7UUIIfZojIaCXT8M0fHAKCinF1PUOT7v47VxwB9I58fMvUxo5dWGY5lJ2xft+XGj11WXcCk93V9joFtH73HUwuAdgUOKT/nIF3USQMPROZhYahGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWF4iBzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWF4iBzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51540C4CEEB;
	Mon, 18 Aug 2025 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524135;
	bh=860MXo3kAl6KkA3RDZDG9KLv9jI9XrpAXKUe4XTs93o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWF4iBzimOdp5EoZWVoH3oD1Z9l+7sURwI1TKJZLXXQiK/J3ojj4qwH5bXL1REKao
	 Zt8Jraqw6fSAcxw6beKH63UPC8cSo+JIeKsAsXnwgeyOVWlSPkFFdk4sdy5d7nxdfH
	 uPdzGZrpnmIYgrxs+0rfyIrhCeUr5SexLA5ilbNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 361/515] media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control
Date: Mon, 18 Aug 2025 14:45:47 +0200
Message-ID: <20250818124512.304530205@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
 drivers/media/v4l2-core/v4l2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index e4b2de3833ee..841cd9e196c3 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -494,10 +494,10 @@ s64 __v4l2_get_link_freq_ctrl(struct v4l2_ctrl_handler *handler,
 
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



