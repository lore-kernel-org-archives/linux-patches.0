Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F32223E9D;
	Thu, 12 Dec 2024 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020369; cv=none; b=bnQhQkthiPAZawvPjCbuB3Uad0+U4lAhlv+GUKP/4glczxowQi2hla3nxNcKhW4irHWSmYfFy1BuWltLwaJWVBfU4tEcC1WupqPS+raihgJpoX8OeTOTk8rBPUXjm57itHDXNGTgsONXAFuwHt3sbqbJ7WxkWTUSzf1rqZzqkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020369; c=relaxed/simple;
	bh=zRx4iQUZROuHTEF16Yv6NLu8LDk8ueMdTOhMrlWY28E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj0CWzwb+fuUkGlfWb6IAG10cuiauu2xFkqrE5HwMdrSN3HM79E2Rau5rd0TyhXM18UbLnSHs1cdHi8eHNrCRq7DY3zYX2LTWz2nWjb6cYqVca19vNpXumGJmYKlZfFS6cuu3PD1JoSvwzo/Bch8QLvmKNqd6z9/9OdjmoUptR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNLv4Ez6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNLv4Ez6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEE5C4CED3;
	Thu, 12 Dec 2024 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020369;
	bh=zRx4iQUZROuHTEF16Yv6NLu8LDk8ueMdTOhMrlWY28E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNLv4Ez6yj0O4uhDmypYTcvnoGJ3O48mIN1sn3e3RK3Qhfhtn5bawbI3+z9b3Shbf
	 WQjtpg9zg8xWSg0sF1GUyDfOQadB44RXaP3YQMxHnmsNdVWQMyrD/OTgUQhHdUGc6y
	 sSEQ7tScFaU5rC+93+LNEeolkgFFMFUFoeNdyZ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 422/772] lib: string_helpers: silence snprintf() output truncation warning
Date: Thu, 12 Dec 2024 15:56:07 +0100
Message-ID: <20241212144407.350896810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit a508ef4b1dcc82227edc594ffae583874dd425d7 upstream.

The output of ".%03u" with the unsigned int in range [0, 4294966295] may
get truncated if the target buffer is not 12 bytes. This can't really
happen here as the 'remainder' variable cannot exceed 999 but the
compiler doesn't know it. To make it happy just increase the buffer to
where the warning goes away.

Fixes: 3c9f3681d0b4 ("[SCSI] lib: add generic helper to print sizes rounded to the correct SI range")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20241101205453.9353-1-brgl@bgdev.pl
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -52,7 +52,7 @@ void string_get_size(u64 size, u64 blk_s
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';


