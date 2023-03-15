Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE30C433EF;
	Wed, 15 Mar 2023 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882654;
	bh=YUxyZHl5bRB0BwmAop66aFY1XoWuGvc+sje5RqZZRng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXVA8D1eQ1NKJ1OXJde+2EvUuSy85CS/UlMDrCzHhfdDHI2LDmkFcK26BQRI/sDiO
	 xPz394LKZ7Qz05xbr+u0ICD04hZgXSA8OtH4Jz9KRu1GMrYdT439pgS49B4VpZyjhX
	 oGQrr9cIkU5o2TOg+Fw0puYB7VoB2/9J/oAguJsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/68] ipmi:ssif: Increase the message retry time
Date: Wed, 15 Mar 2023 13:12:14 +0100
Message-Id: <20230315115726.892015865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 39721d62bbc16ebc9bb2bdc2c163658f33da3b0b ]

The spec states that the minimum message retry time is 60ms, but it was
set to 20ms.  Correct it.

Reported by: Tony Camuso <tcamuso@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Stable-dep-of: 00bb7e763ec9 ("ipmi:ssif: Add a timer between request retries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 9f1fb8a30a823..02ca0d9a0d8cb 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -79,7 +79,7 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		20000	/* 20ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries. */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
-- 
2.39.2



