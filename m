Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020127;
	b=qNOqE4A26w23xkwSKo2Dq38Kbf0XPwjbTV2bP78b8g16cQtb6DJvszTDe9DYkJbpXv+0
	 m/wb3+o0wlhCD7Bn9yyDALljkCEmJPjpHlVEHcA3EOKNe/6B7R38O1qv/BGhc5MG7imNI
	 yZOSNvl6/e1OD6hj/c8EC8c9RFwKM6WwLPhL/ikBbkn5J1cpqS8Kp0o/kTAr9/t9QbpoL
	 qt50x8gyRLrzAyIVPZtdmQBnu1oNGOTcYOvaPwiWj5XdeEufepqvrEMkSaQ5wH1ZOdRVb
	 Bri+zKSiRLClYv3tfAwVpF0W1YUdB8kJBqzFUKT9HKZTtFmRIEzIye49h5n4/Ers5ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MDZuV11p0p5pAwrIMECMzOUoMQ6drAnINhqLSt+bqtE=;
	b=gG4ghYsqBaZm6oEK0SPfPGaPnJgo+QkxmYlaGcicBsPbrPPuy6HorhplP6IW/F9C/5Mc
	 d7msDmScGcU7oDNDL11CEOeOGRmS2UCc3MCoDdtzUycnc7C67Ycyn5wx/XsFq/gIJfDoi
	 4LpWNeARBt2opBqyzJLP4Z53dC6Ulsffs569JIphsl9W7wJNYmK8wIBWfeDucO4LUrqYa
	 pSAhX516+E3/Xcgv1wdDe22GiuOza3InG+kfqG/knT5LV3qWwcSX8jfsGANtuKuBAQrZl
	 hQ/HxbPihhStc37tUqVazBAfGP4BQADSLlfASkA0HAdnkWpIK8+eOtk/bbEhVmjIlPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD0NAZE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE0B606A32A;
	Wed, 18 Nov 2026 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD0NAZE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328571F000C4;
	Wed, 18 Nov 2026 16:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020126;
	bh=MDZuV11p0p5pAwrIMECMzOUoMQ6drAnINhqLSt+bqtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD0NAZE7RfVTee/cEj4t2/D/GUmaqzXdi4t2XDlelmQFgshYnv+3bm6Lux38/WZah
	 F9Ca4npjDNDzqxorP+nLKYF4uiypCecmpcjPZ+150BTrRmzJSuBCeX1vNvtnE8o/KR
	 liqSAHB86ek1CJonRNRJm4U842P/qQZBV1lFTNIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1842/2651] platform/x86: hp-bioscfg: fix off-by-one in password length check
Date: Wed, 18 Nov 2026 15:51:22 +0100
Message-ID: <20261118150353.386307560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 0c22178524864af85ea380be4b2d36078c0edc9c ]

current_password and new_password hold MAX_PASSWD_SIZE bytes including
the NUL, but validate_password_input() accepts a password of exactly
MAX_PASSWD_SIZE characters when the firmware limits allow it.
strscpy() then truncates it and fails with -E2BIG, which
store_password_instance() ignores, so the write reports success with a
truncated password stored.

For example, with a max_password_length of 64 or more, writing 64
characters succeeds but only 63 are stored.

Reject lengths of MAX_PASSWD_SIZE or more.

Compile tested only.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-6-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index f0551b4553794..a2f50ecbecab8 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -74,7 +74,7 @@ static int validate_password_input(int instance_id, const char *buf,
 	if (is_current && !length)
 		return 0;
 
-	if (length > MAX_PASSWD_SIZE)
+	if (length >= MAX_PASSWD_SIZE)
 		return -E2BIG;
 
 	if (password_data->min_password_length > length ||
-- 
2.53.0



