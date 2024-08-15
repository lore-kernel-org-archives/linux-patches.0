Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657F81A0712;
	Thu, 15 Aug 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731556; cv=none; b=AZKrPIz947ZdE6DKgFpHTKgga6JfvF8WIqvMTXxKVuejMgaGz1CNwtG6Mr0wzI1NYwYYdTzCugwIVC97QsTUx1TjyB40T5C978VhBkxusqUwCzBG9rvnPVOik5TKAnHtD8oYygUj6vcaX9S2WpGztJi1XTXOCuWixaucdHwEz38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731556; c=relaxed/simple;
	bh=H0/UNrnqcNnUpAK69rMuqsTnh5+I7z9WlYRtRxluGFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmdTE6eBufBYtv/XmhBWrUmnHrzWpPi48q5O/n/CWZyzQ5BoJ32geFEcAJZZpni48WQwiIKr91b4ZuQU+ANNQUxvChtvW5PWBL6TiUsjoiNVAUbCegdT+HBhBsA01Q/5eb6G4Es4z5aLr3Lm/wggiXwlBIQl+dcGDBm+K+N0sOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPs5h7K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPs5h7K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F43C4AF0A;
	Thu, 15 Aug 2024 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731556;
	bh=H0/UNrnqcNnUpAK69rMuqsTnh5+I7z9WlYRtRxluGFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPs5h7K8yZ550P6wlnu9nIlnUlsIo5aMUUmTg5kMFYww28vaKZ4FHREeh+YONIoQ4
	 GSXHEf0jxw3yyd4mr/PFzgHPwVSHeMEOoZSFcSVut0OKuhm1aN7e1w/GXWFpRwS7c0
	 +E3IxE4AKqpzLr/nwIb0JQC+i4ZGAFqVw8ATWa/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/259] kdb: Use the passed prompt in kdb_position_cursor()
Date: Thu, 15 Aug 2024 15:24:28 +0200
Message-ID: <20240815131908.007079606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9ce4e52532b77..bfce77a0daac8 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -192,7 +192,7 @@ static int kdb_read_get_key(char *buffer, size_t bufsize)
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



