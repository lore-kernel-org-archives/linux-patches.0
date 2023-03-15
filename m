Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE34431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC86C433EF;
	Wed, 15 Mar 2023 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883609;
	bh=6toz8iGJB4QhTtd8exzFSyV0SltQCIthXgryPfoVZIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsMzF2gG76Sl0r8mzoVGJTACpc/FT3aFJ9JQEbks2F/P8uvMRGWipz7/YLrlOeFcu
	 udq3tEoxlajFdzLEWzK3WP9rB606zM0EA/FBEGvpjOZHN8v5VpO/3jM7FJ/b7PLnid
	 KkLE8x20L1v9+7hz1gKYyl9mdKIIgBomg8uCG/kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/143] ipmi:ssif: Increase the message retry time
Date: Wed, 15 Mar 2023 13:12:12 +0100
Message-Id: <20230315115741.925755728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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
index cbd56886f1d2a..c25c4b1a03ae0 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -74,7 +74,7 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		20000	/* 20ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries. */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
-- 
2.39.2



