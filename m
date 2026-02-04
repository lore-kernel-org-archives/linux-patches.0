Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC14641C2ED;
	Wed,  4 Feb 2026 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217795; cv=none; b=LZj1rMAxPC/2Q43kd7uoSS8MLXfw9g0IFpSqeTFjO1zsJ1XHfB8Vjpn1QkdOkmOkVpbjfTFh50PSBJpNTbqlMpsbw7ydludKLXszeRBrESl6OaBvdNXUBdxsHnepRmwNN+oFBqVLqrvkJFGbfOp+5fq3ynXnX/fMYAiJGDHifPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217795; c=relaxed/simple;
	bh=XzOYQ1fsHKybAJjfJcljay/VPzBbtRlLGeIr/SyOazk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDoLHvR+L2RLGj1gRG2kP75WNSmmPIGt/OtOJ+5+F128vayLckrzKDUmGK/rEEecRNOLVMzlLvy6X6PoKTlbztwDUKdy5uY/+tLdoRFA5veuuzwlFhOwPT07sQ6F/5AiJZSrOhniFcrQ1nf4NSBDa43izJxH5VgEsJGnQ92CLkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXk34mC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXk34mC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC45C4CEF7;
	Wed,  4 Feb 2026 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217795;
	bh=XzOYQ1fsHKybAJjfJcljay/VPzBbtRlLGeIr/SyOazk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXk34mC73rBXQEalhCv/Ba8KWky8Bmm971pcgONGU0P7HVP5IiUs7vubF7HaQR8y8
	 Go3srDpuVTFT7QUUQjf7rdenZDcPm5oj586A6rFuVCooZ3VXQmdg+cnKLeXxSE/zfC
	 rNQEh4GumbLOoxTx8zaZbpwuOfpDu71EGHoXjzuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 120/280] Input: i8042 - add quirks for MECHREVO Wujie 15X Pro
Date: Wed,  4 Feb 2026 15:38:14 +0100
Message-ID: <20260204143913.956268531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: gongqi <550230171hxy@gmail.com>

commit 19a5d9ba6208e9006a2a9d5962aea4d6e427d8ab upstream.

The MECHREVO Wujie 15X Pro requires several i8042 quirks to function
correctly. Specifically, NOMUX, RESET_ALWAYS, NOLOOP, and NOPNP are
needed to ensure the keyboard and touchpad work reliably.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-3-550230171hxy@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1176,6 +1176,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


