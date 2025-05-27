Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2533280023;
	Tue, 27 May 2025 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368633; cv=none; b=mPB2kju23K+yPfA0xdJp3Q2jpeP1UPii5b5aEW+PFHGmSvMZt7yrQCO3QQLyoIj0aPRayxlVvhIViRP2NuDi5AqQxJjK2uim9v2dC6p5PBzKfIz9kXuyWZfF8qXA9BbzqjloKg4afMdTHvHUBLZTTp256Lu5hIeU9F7ELfFULBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368633; c=relaxed/simple;
	bh=0zuChdbSw2dlLcUvS45iXkaS3DsjI1/9X8XKpAxZKcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBE9eFLG00O1jMSd5RXU5b5Br55Ny3Ha8YCNeqOz1dyNliOG7BD+Bth8IrdT3UKuM3zOb9YZavxYKISQG4eROO89BBi6Xyuh9kaLoFfQlu96TVDtc6U2XWUu0tH/nLZiGYGkGbEV03ISXWZRqePZWyem23/rWj1YIbeC5qTqlAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+teM8rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+teM8rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412CEC4CEE9;
	Tue, 27 May 2025 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368633;
	bh=0zuChdbSw2dlLcUvS45iXkaS3DsjI1/9X8XKpAxZKcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+teM8rfGlUOgTYDh0nhXSNRcAbPy5eL4aztu4uTTxmnbEvJRTYzrn264re2neodR
	 FGVsKLMydtE++4Y3ykfZ30S4q7ZWPv9qywppMb1KaKjVkfjjaVOupAE7Eg1WeFWW5t
	 IMUoWvtVe/7nAmzU0D4exF5yyY8Z+YYPYPNQcWTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.14 742/783] platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()
Date: Tue, 27 May 2025 18:28:59 +0200
Message-ID: <20250527162543.342644008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>

commit 4e89a4077490f52cde652d17e32519b666abf3a6 upstream.

If the 'buf' array received from the user contains an empty string, the
'length' variable will be zero. Accessing the 'buf' array element with
index 'length - 1' will result in a buffer overflow.

Add a check for an empty string.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: stable@vger.kernel.org
Signed-off-by: Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>
Link: https://lore.kernel.org/r/39973642a4f24295b4a8fad9109c5b08@kaspersky.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c
@@ -45,7 +45,7 @@ static ssize_t current_password_store(st
 	int length;
 
 	length = strlen(buf);
-	if (buf[length-1] == '\n')
+	if (length && buf[length - 1] == '\n')
 		length--;
 
 	/* firmware does verifiation of min/max password length,


