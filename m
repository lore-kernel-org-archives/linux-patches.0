Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444BE26FA60;
	Wed, 25 Feb 2026 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984031; cv=none; b=RkoBlCAOY7l38Bjwx0tj1npsm9GI2wok0fiU4QtNEjM95qW+qcm9xm0LQfeS6rovWG3gHuEbRTrA526UCbNoJfR00hPQS99b0bln1rFXv1ATj+EgrM2I2UWlqN+FqtIqE9s3GcE/wAgen6Wafx7cn8rIoCCePFc53hKyxRBMNLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984031; c=relaxed/simple;
	bh=/iNnqT0d36pQrgUikYEMFu/chOba2jd/UwnQ9w6tMEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIXERJaegUV9Lf3dtQsQYbNfuJwf5U8cmE62vlhVfE4AfSDt3AAqLVY9oT9l3cZNxxIH3VzBucGRxhNuFPOygvhdVkEQ/uAFaUIu/xXA5b2zlcTD5QOoZdKEk/0ZhNFHnIRpIBVQmKr2Xw71AF7bgxGZzQ78sU6UakFNLO9GA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPpnSxHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPpnSxHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044CAC116D0;
	Wed, 25 Feb 2026 01:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984031;
	bh=/iNnqT0d36pQrgUikYEMFu/chOba2jd/UwnQ9w6tMEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPpnSxHDtwbNg7Ak40CjwnFnOBqHTW7VuvIUTo5DIuE5OfmK9yLOc/f2YO88rKtG2
	 tAWTj6P3nDUIPYve3GolCr19C5b59euZXPS7n+ouZHdB4y5NgWj+1cavBadYwO9PUR
	 lFm9XRVXhM7jT++0HBpRjDbAwJQtM8de8kOEeaTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/641] lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled
Date: Tue, 24 Feb 2026 17:20:01 -0800
Message-ID: <20260225012355.456355576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



