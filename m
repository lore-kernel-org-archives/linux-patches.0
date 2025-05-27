Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9AD367;
	Tue, 27 May 2025 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366090; cv=none; b=QAgZhoZFrDxA7D3IjOfIXFLHexzpU7Ms0RtC5Myd2XTUE7+1oyc75vA3Cz34kRxoYN3iCdaGmco+JZ3BDgC9CZJBYFKlUp6gQTJDLAlKNYd9mbHw2gZFm6VdncKyI3L+huGtGR4GLjaWhF5BQnfKvhAjFr4SUudbhgEdR3Wn25E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366090; c=relaxed/simple;
	bh=xuBEO4P/LMwbiQiTYCOikI7X9yilvMGL8BLLKkHVwDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJuz+8io4by1cTKVGSbU+jLUT/HIdvsHfy5XMrGxHfoVfUjE+tp5NNTLw3KBTX0hpzywAuJsjN71LwKXBV9qq0gD02SvCRmntpn/YQm/KEZ1nJnKEp4pFe0E/ZBwwKYa0V5DRgdcOtC0GiNLCL4tb/YgnCRwma1SNVuJKkdkFdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiR3zzI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiR3zzI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBCFC4CEE9;
	Tue, 27 May 2025 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366090;
	bh=xuBEO4P/LMwbiQiTYCOikI7X9yilvMGL8BLLKkHVwDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiR3zzI7ts4N3A01wnNmLEf/MZSlmCmWFnPZZBOVmziXXDrHWPBrFda0yFfb3v9Gn
	 3oWbyZduzE+oxzLpangqyP3xBeRzQs25rcpWtP/cqBiebGkep91SuxBfRdtz4Iwra4
	 0Lh9rRVDzM3ZY5hc0FPDlzB3kYllJMKaob8dCGSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 588/626] platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()
Date: Tue, 27 May 2025 18:28:01 +0200
Message-ID: <20250527162508.873478877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


