Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C0C22D4D7;
	Mon,  2 Jun 2025 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876446; cv=none; b=nZmefcnYTwu1vrt+PWzguZCtfYtadNKYEc+yBGS3jm/ht6z1ZDia9rTugbInAl6MempiTRyZePgOWRnpDt99RRxyjTJesJBEZoiiP6hFGB0oL4oe6WeAHVpWTG5NGFD+5gy10MvpAsB/Wg8MjMTNWkRSUnDvrIOrLFkyCuCSOzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876446; c=relaxed/simple;
	bh=Oo8CJ9g7ANV9fBtHfVCL3pqUM10N1u7QdD61ihowpFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhVPFwX6Cpc0AkgRft5dh36P6AQevUsxxIz3VP/uVuAJRs6uszmlcRmgxc1v+OEibhBXB+oq1TBw6KUiWFJ/kzfMU0wvWB8uAgeniJ6Hkk6Os+4El1xRsbY5fPPLvtzU2CtoyiuAmDFGXolyRFd99AMNbG9UplhPPaLwhMEn7bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1I8gx4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1I8gx4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5491EC4CEEB;
	Mon,  2 Jun 2025 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876445;
	bh=Oo8CJ9g7ANV9fBtHfVCL3pqUM10N1u7QdD61ihowpFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1I8gx4Caepm6S3xijZHsEK7RvIbHySaxFuZo7C1XMhVT4dGltmJvXCln3SjVsKKW
	 59wa0CvvcRP7xubkR8ci4B7i7hUAdCwC7lVAtHKCM+WSiUWu3vR5Cz5wNo+O8Ar9H9
	 k5EPLPEu0nRK7YtvEL03d4lwLBWeZGiJlAQlMtiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 176/207] platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()
Date: Mon,  2 Jun 2025 15:49:08 +0200
Message-ID: <20250602134305.643883131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


