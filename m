Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C771509AC;
	Tue, 23 Jul 2024 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735556; cv=none; b=A/SbUjlWz7+MGEw23hFMLPbj0USF5yHU29CTxN+p+Eh1BLieCTPocOE0kX+04vTNSAMrQ6ab3F6VT06EhhILbb+8wZZeUh+Yi56UDKyyqJQGfe9JpvDc3ow0pcW+BELgoFiWUNxWkldf1qPQmUKf84xSTW0Th2JUjFrEj5MIZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735556; c=relaxed/simple;
	bh=f74qUKOoH2QHS9m0GVs6fxK5uA8ARiisayBNi2y/aq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3WPtSjFNBZiBbvUKIv39wTyyEiFkI0DtlPYkO+ziaD4DRkdjGZFxDe2rL2Z7qfKaXIG2iPiVWBXV7TquD3m4+uf+vxKPYtV2PfmkWkJwbu/Dt2vk04rCIDwhlVz5Pw0/wjhx2rpxHzSIM9ZLyEp3psVYHzwZDxtZh5wg40/+Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clg+wnO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clg+wnO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12591C4AF09;
	Tue, 23 Jul 2024 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735556;
	bh=f74qUKOoH2QHS9m0GVs6fxK5uA8ARiisayBNi2y/aq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clg+wnO6iSOpXcQueSm6A8zHe9qh998SmeDJHFGOxV5N9fr1l65cKnPqxm5kSsucK
	 m+a59XJRKTaXjC7p+/791VtydLTX0UpLV3gGHhG+MalfTOX1i2OTYEbujD6M15bpYd
	 qcLVSjxxP12Tzp6mQZ6lb/IS//7DHLsGt1iyOgGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 9/9] ASoC: cs35l56: Limit Speaker Volume to +12dB maximum
Date: Tue, 23 Jul 2024 13:52:03 +0200
Message-ID: <20240723114047.605318290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723114047.281580960@linuxfoundation.org>
References: <20240723114047.281580960@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 244389bd42870640c4b5ef672a360da329b579ed upstream.

Change CS35L56_MAIN_RENDER_USER_VOLUME_MAX to 48, to limit the maximum
value of the Speaker Volume control to +12dB. The minimum value is
unchanged so that the default 0dB has the same integer control value.

The original maximum of 400 (+100dB) was the largest value that can be
mathematically handled by the DSP. The actual maximum amplification is
+12dB.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20240703095517.208077-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/cs35l56.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -209,7 +209,7 @@
 
 /* CS35L56_MAIN_RENDER_USER_VOLUME */
 #define CS35L56_MAIN_RENDER_USER_VOLUME_MIN		-400
-#define CS35L56_MAIN_RENDER_USER_VOLUME_MAX		400
+#define CS35L56_MAIN_RENDER_USER_VOLUME_MAX		48
 #define CS35L56_MAIN_RENDER_USER_VOLUME_MASK		0x0000FFC0
 #define CS35L56_MAIN_RENDER_USER_VOLUME_SHIFT		6
 #define CS35L56_MAIN_RENDER_USER_VOLUME_SIGNBIT		9


