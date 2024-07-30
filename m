Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE091A6195;
	Tue, 30 Jul 2024 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358478; cv=none; b=Rp0gD0RsZ+Xdh8xykU/cFOcWK0+mHkgHMyispdZNFABwzgbGdXXvae1nx3ZicugivJvancItqqWU1ajZ5Q+ngS54uogcOoPrByOC6xPNACfJLmZKrf1ixyVVCL+atDnupJ2tRMdfSy+MulpbwtTY7mch7kIupeNP9POYku/H6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358478; c=relaxed/simple;
	bh=6arCJgFr3DhUtOVG2e/si+fouwI5P9oV40+DkifwVLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbsus+3KXgvyq/5aqm7xpgPb+XK5Rz/smO/ecskUW1j919N4jWtdQzc0lsZR7FLZw+w2sF6EUHaYAvBaTSa6FNcqjRyIUF/mCvdIa3CiQNjYAohgj/L7v2U8t+yCQv0F3UucwWbDykOCMAOC4N1bPDEXYzKW8len/UoKg3+ftFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVKz3rUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVKz3rUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549ADC32782;
	Tue, 30 Jul 2024 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358477;
	bh=6arCJgFr3DhUtOVG2e/si+fouwI5P9oV40+DkifwVLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVKz3rUvUYo6wv6QFUg4QgHsQ9l+c5p4OTG7E4trBChdJORVtvBWWqsMNtVb+53rh
	 +w5ib36V7xaWk2mOoGNVzlE7vfegieVy3z6VTDH/g6tS3CCq7y7l9B34afA5F9JqmK
	 DtBv7Jlz150MZqD+lXeMMM7GY8a42WEWsTJxVRjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 394/440] kdb: Use the passed prompt in kdb_position_cursor()
Date: Tue, 30 Jul 2024 17:50:27 +0200
Message-ID: <20240730151631.193422870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e2e821095949cde46256034975a90f88626a2a73 ]

The function kdb_position_cursor() takes in a "prompt" parameter but
never uses it. This doesn't _really_ matter since all current callers
of the function pass the same value and it's a global variable, but
it's a bit ugly. Let's clean it up.

Found by code inspection. This patch is expected to functionally be a
no-op.

Fixes: 09b35989421d ("kdb: Use format-strings rather than '\0' injection in kdb_read()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528071144.1.I0feb49839c6b6f4f2c4bf34764f5e95de3f55a66@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index fbbe198b056d4..d545abe080876 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -193,7 +193,7 @@ char kdb_getchar(void)
  */
 static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
 {
-	kdb_printf("\r%s", kdb_prompt_str);
+	kdb_printf("\r%s", prompt);
 	if (cp > buffer)
 		kdb_printf("%.*s", (int)(cp - buffer), buffer);
 }
-- 
2.43.0



