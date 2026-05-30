Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDF7348C5E;
	Sat, 30 May 2026 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158292; cv=none; b=G+RJYbRdQ126c3/3Gm6+2K6f1QLYjYAVbJeHsGRn+58X44NzpeYYhevRJ3x41k52QwMbsM9pFX0Vqzm2WecOfEZwQ9WlPSMAr0kklvajZbamoL4Ogp4fd8NhqKhFFNae5U88hEi0NUv4UDPt0OWWodm8tNwW4lvuKwO38BM268c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158292; c=relaxed/simple;
	bh=xbNyofANtFxYiYdTybOjm78usgdplaapy094gJ6StCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkVRlH4Xr0WIqeBoX4ljMjOMPy/gAnY/SYWEbUOwEYI+4k5Zsj/3WvvGYf8P7K3xJYgjkaxAykMbdJnsin7n3K4rVqzSVErZqUgegomqLkA0+Nc8Polv0K82WUEoWRGTu9mVsuPV96EDnn5dg4lcMgW46pomZ+jCICVBEZmAHfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA1PoAG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA1PoAG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9D31F00893;
	Sat, 30 May 2026 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158290;
	bh=0Br7jvNCjvriXcHbNJAhbmptN8RfHOSZc95YCEW8Jqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA1PoAG/2Y08xdQnEK+oF8R64huLi9kFBtid7BoelsMXZIsmVVmr4nWH7mvJU+so7
	 FVbOKjbWxK99uVRVk3Zmvs5BiE5eUZGw6hzh2V1uAbdCts8WrCDg9pl2jlqHsSvO+X
	 roCx07xxBc4c3MjKCS8Dm4wfPGBxoD74YoKDDLHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/969] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Sat, 30 May 2026 17:52:21 +0200
Message-ID: <20260530160300.939381208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4337a24d13e9e3b98a113e71d6b80dc5ed5f8c4 ]

The 1kOhm pull down and hardware debouncer are features of the revision 0.92
of the Chassis specification. Fix that in the code accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 8542053d4d6d0..2c357a69e0345 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1547,7 +1547,7 @@ static int intel_pinctrl_probe(struct platform_device *pdev,
 		value = readl(regs + REVID);
 		if (value == ~0u)
 			return -ENODEV;
-		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x94) {
+		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x92) {
 			community->features |= PINCTRL_FEATURE_DEBOUNCE;
 			community->features |= PINCTRL_FEATURE_1K_PD;
 		}
-- 
2.53.0



