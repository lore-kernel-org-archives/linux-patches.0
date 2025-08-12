Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A86E2FF16C;
	Tue, 12 Aug 2025 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023853; cv=none; b=s1/9k7XMrwfSBk0DFBiSCP358M/VY4rlGjXeKAncdppuJAQQXElgZxlQ7hqVA35elKo9ghbo2bS4zjmKbD9jqc56zFGljom/GoJw5ZmZ2v/447Z2E9aSE54u+p+BmYMyhaLGPCLQ358KgVT8A0I3sBgE6tNWyDgqfOtbYhLMqVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023853; c=relaxed/simple;
	bh=V8XLY6vxMArv/KPHgP8fyaipaycd7r0qmac0ZWMPN9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LndgzQLvs0Do51370QcJdmZF3ifM3dxiQ07g5vff0r+GOiO6t0Qne5B66BKwoghFu2FIEnBTFc4B60gMuNnJxNFAR9xwrs3NRsKr1Xnz9IyF32uianWy7Es4pzmJl8BHEHHXDtalIJH7kPsIqO+fQjmYjIWISi1Z5RTIUoPKF+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILYAVaeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILYAVaeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4624C4CEF7;
	Tue, 12 Aug 2025 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023853;
	bh=V8XLY6vxMArv/KPHgP8fyaipaycd7r0qmac0ZWMPN9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILYAVaeo/TvSOlbfrMoqJZ9lue86JStge10yiycQ4E5nF4y1ZjoBPPFqq9/Vn5co2
	 708TLFP3TuvtV3b0UnUv1W1/Pj2P6HsO8O4zXmEkmJZF2XMPhaDFM8BDKA7oQ57R7v
	 ocyIkHC1z4O4rjqq11X2OKV9xW+U6BzTMU1MC1iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 200/627] fbcon: Fix outdated registered_fb reference in comment
Date: Tue, 12 Aug 2025 19:28:15 +0200
Message-ID: <20250812173426.890183604@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 0f168e7be696a17487e83d1d47e5a408a181080f ]

The variable was renamed to fbcon_registered_fb, but this comment was
not updated along with the change. Correct it to avoid confusion.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Fixes: efc3acbc105a ("fbcon: Maintain a private array of fb_info")
[sima: Add Fixes: line.]
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250709103438.572309-1-oushixiong1025@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 2df48037688d..2b2d36c021ba 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -952,13 +952,13 @@ static const char *fbcon_startup(void)
 	int rows, cols;
 
 	/*
-	 *  If num_registered_fb is zero, this is a call for the dummy part.
+	 *  If fbcon_num_registered_fb is zero, this is a call for the dummy part.
 	 *  The frame buffer devices weren't initialized yet.
 	 */
 	if (!fbcon_num_registered_fb || info_idx == -1)
 		return display_desc;
 	/*
-	 * Instead of blindly using registered_fb[0], we use info_idx, set by
+	 * Instead of blindly using fbcon_registered_fb[0], we use info_idx, set by
 	 * fbcon_fb_registered();
 	 */
 	info = fbcon_registered_fb[info_idx];
-- 
2.39.5



