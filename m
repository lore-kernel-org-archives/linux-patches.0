Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC3E18DB2A;
	Wed, 25 Feb 2026 01:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983216; cv=none; b=b30Te9GYUoyxXXO3t5eB5MR3FNdNc/zWGYDoUTYKXo17W30HNUhMLxADyo9gxqs+6g1JLPOtyyXwfhE12XCtRK0sUrUpJTNiqSL7/WRe3vv7PUiNqYp2iTuk9oSSA1K4/B5mHpMLCI1oiZQrNZWlw4eBRearXUT4d2KgCqV0w0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983216; c=relaxed/simple;
	bh=+QKAbecmsV4zh0TsfslMk+y6iYeeCptPlEdPNJOzfS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tISA1hdYaQWOUmc1A9pp3HuUx+gY3/aGNi1rj8RrWJWS7sJCouvwZgHh3Xa3Zen3XGVNH8+B8gXkc5oOW8514b7sZ/2hhx9X04TzbLTVV302hlQUJa7gYinHAoml1Z7a36AZYtlesdi24eNHsE25Rr4o9Ix/X2Am1q1AqlOzBVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8WUddLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8WUddLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC50DC116D0;
	Wed, 25 Feb 2026 01:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983215;
	bh=+QKAbecmsV4zh0TsfslMk+y6iYeeCptPlEdPNJOzfS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8WUddLcxyDhzIA2UAT+UBMkboFmkzPPxKLg2zRFpkeEyAs37uILjNomn2y3wuneo
	 U6LvhY0nKj+/XEKlqywNPjK+HK8eDLkb1VhMEt1jsD02mBW7FwUU6EOkOoHILkVFrk
	 KEsEGtEPlYogaGNato/R6PP6AObeM+xWwYZpJ/AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 364/781] lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled
Date: Tue, 24 Feb 2026 17:17:53 -0800
Message-ID: <20260225012408.609195459@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>

[ Upstream commit 1921044eebf1d6861a6de1a76e3f63729a45e712 ]

Commit ae5b3500856f ("kstrtox: add support for enabled and disabled in
kstrtobool()") added support for 'e'/'E' (enabled) and 'd'/'D' (disabled)
inputs, but did not update the docstring accordingly.

Update the docstring to include 'Ee' (for true) and 'Dd' (for false) in
the list of accepted first characters.

Link: https://lkml.kernel.org/r/20251227092229.57330-1-chaitanyamishra.ai@gmail.com
Fixes: ae5b3500856f ("kstrtox: add support for enabled and disabled in kstrtobool()")
Signed-off-by: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kstrtox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index bdde40cd69d78..97be2a39f5371 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -340,8 +340,8 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'YyTt1NnFf0', or
- * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * This routine returns 0 iff the first character is one of 'EeYyTt1DdNnFf0',
+ * or [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
 noinline
-- 
2.51.0



