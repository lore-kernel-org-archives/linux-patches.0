Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D51DF720;
	Tue,  8 Oct 2024 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393801; cv=none; b=VHZ8mS5atgYQdcF8isbegWQB99Rx8Xl97wYHGuibLUA9ncQnj9Xhck+1ZRlID0tna3p+501vknJz0dAfhisC1NszaIT0K3+Ve4UYF392rp2s5bjsk0yzE5RHpvpjt9N9YxBhP70pByKXALMPIguj5Zw63pVrYQ11gMmdqM48dCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393801; c=relaxed/simple;
	bh=2g0yzwctZHf8RDsigJHqnYCfCHkSMC/A7Logdd3rv9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9zcVN3o2fH4h3XX+HJMwsefWlmp4svJNk0FH93svZb0lUAzjcDGCKgGblXFVEwzAlUjemIE/PkSjn6mwR5O555AdOWnW1lpFDu8Ia8BgAfJfo/qJ2n2+Vkli3/mgYZd4n/xI1drvisJs7wKj0Ue8Xfsc92OSVfTQJzpTZynfhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPalidrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPalidrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52416C4CECC;
	Tue,  8 Oct 2024 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393801;
	bh=2g0yzwctZHf8RDsigJHqnYCfCHkSMC/A7Logdd3rv9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPalidrJR4kjsqnhlz8caIhxeUxvAy81pbpd5GF9MB8uRHlvtBA7rzt7CyklhkCsV
	 PGv5qgEOWbxnwHCA6Xx+lpEmTPBS0iNWRSd+Xm1WoRNRLQFiHQwpIvRPuPRGT5r0iK
	 mAooz/gEq/1ol5e6EjyKQ4IfpLyJUlHflYbi9uZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hans P. Moller" <hmoller@uc.cl>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 228/386] ALSA: line6: add hw monitor volume control to POD HD500X
Date: Tue,  8 Oct 2024 14:07:53 +0200
Message-ID: <20241008115638.376732714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans P. Moller <hmoller@uc.cl>

commit 703235a244e533652346844cfa42623afb36eed1 upstream.

Add hw monitor volume control for POD HD500X. This is done adding
LINE6_CAP_HWMON_CTL to the capabilities

Signed-off-by: Hans P. Moller <hmoller@uc.cl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241003232828.5819-1-hmoller@uc.cl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/podhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -507,7 +507,7 @@ static const struct line6_properties pod
 	[LINE6_PODHD500X] = {
 		.id = "PODHD500X",
 		.name = "POD HD500X",
-		.capabilities	= LINE6_CAP_CONTROL
+		.capabilities	= LINE6_CAP_CONTROL | LINE6_CAP_HWMON_CTL
 				| LINE6_CAP_PCM | LINE6_CAP_HWMON,
 		.altsetting = 1,
 		.ep_ctrl_r = 0x81,


