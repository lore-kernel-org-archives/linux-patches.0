Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3A1F471B;
	Tue,  3 Dec 2024 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236810; cv=none; b=qP9EWi3A+7Ih4IZpwipH9WCLmU+/0hp7yPHkfVqpyHurX2TJt9OPdNmp68vT1BZaUIi4oKJ3XKv+8CLOu8eNn53vi/0HnY0vhmS2KM6ygdHUK2qNB2p+/ohmfHxvY4+LGN70XC9SlbvzGR32owxN6LxGU488Ol3cNlRO3Ze+0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236810; c=relaxed/simple;
	bh=EJiUNOd1hHL4BL33u2Xr33hc06Fby4HIRxEyHIu2fSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJmfNkVO5lXBF2ZtiHEOuZHw0jHXVB5UyM0RMZ7g/f36PYT68HmLHC0xxmyClnm3CKIOe+9Xvt8WybeldIRC3N2qfWnVtsZCTmWFIuf0oXgm81Ok7nefGgdR6EwVf4SbaDtjtfJy9YTXWO9Rtd8JQuGMS/iVRQ/sS+v7/Y1mvo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cA9qTgNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cA9qTgNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3C9C4CECF;
	Tue,  3 Dec 2024 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236810;
	bh=EJiUNOd1hHL4BL33u2Xr33hc06Fby4HIRxEyHIu2fSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA9qTgNE7SOvOS3wCyGIdTagrPKQLL6H10V8y2T5IjKnZ5tivVV7sjwchNq1wfjec
	 /AJbjstYTC2fqazPibhPE5IiCKawIBTgLpUIkM98FnBe/RdGpO/Re/vbRlKa/v2kw5
	 9Kisvtas7G21l0VgM67FkCeZH8Ou89xssTn70SR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 124/138] lib: string_helpers: silence snprintf() output truncation warning
Date: Tue,  3 Dec 2024 15:32:33 +0100
Message-ID: <20241203141928.311562580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,7 +50,7 @@ void string_get_size(u64 size, u64 blk_s
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';


