Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B0D4F392C;
	Thu, 17 Sep 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667178; cv=none; b=BVbF0tu1VfN9Qp+o+LdtxP/qAZQf9cCrqt9+5L5xeZfXhivjDHKJ8JxhcKnvtT7PCFP+vSFmIbnDEtcDPEHpR12/HkuLWMyyLiSJcdlqIUPvxOz/weWEhTQ/eEsPf/QENm+KRPCh6+xNKvmICsmFkN8eCjuM7UiQl1YUqd2oFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667178; c=relaxed/simple;
	bh=VoImfxUDgaexcC6mU811aNJ/3osfy6gN94yIWmuvwcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFRLj8YgdSiQtujpyS/I2aGWOZGpmPMrhncGLyv5orXT7UfDDmc5A8SYjDGbhM7sH4UsLCseq1PxghBU498Ftv+2gYZ99p6fDGmWVdteDAl0Ho+tvcJGr7l8x1XEBp2GOvdDGj0d2/etWfLIaXtQ81ev256QSaTR6KZQokLp3y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CI7s8P3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CI7s8P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824691F00893;
	Thu, 17 Sep 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667177;
	bh=TLDRMDz0bv2i0qUX7oj6YMJPqGaiFGT1Y86iYGSxX8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CI7s8P3FGQPCVnKKdmQxYd8uJE83O73AYa+CjKiqNBH5OGWGj4X/6lzF5DGf6kjL
	 +MYiMPVeKtxp0jKSbw+0aD+bcjbFRQ/wLQIKqtmerhc8nHfR9clE81EIAWQ0yhEJ18
	 Qe0nmlOm8V/M1nJ/qXJlPdXjb7cMwnbL954bSH54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1231/1250] landlock: Use mem_is_zero() in is_layer_masks_allowed()
Date: Thu, 17 Sep 2026 16:17:06 +0100
Message-ID: <20260917151625.657740758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

[ Upstream commit 1c4fe87364782d1b058cc9d15fc8acef44bce033 ]

This is equivalent, but expresses the intent a bit clearer.

Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260327164838.38231-3-gnoack3000@gmail.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Stable-dep-of: 2c6dc7925382 ("landlock: Fix use-after-free of the source's parent directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -559,7 +559,7 @@ static void test_no_more_access(struct k
 
 static bool is_layer_masks_allowed(const struct layer_access_masks *masks)
 {
-	return !memchr_inv(&masks->access, 0, sizeof(masks->access));
+	return mem_is_zero(&masks->access, sizeof(masks->access));
 }
 
 /*


