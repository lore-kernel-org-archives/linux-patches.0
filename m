Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F798171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AEDC433EF;
	Mon,  8 May 2023 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545528;
	bh=XmcK61++eq3I1ivCFoKSwIBTROMsf1phJzvHxWTo/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/cA7eSBBsjyIDN/MYS4uR9scJiHGS1WXb2SmHF9QlMnSy7ibsEhQ2NkQrtSJVDjE
	 z1/hWY9G71jG55fTPKxHwBCVvkT+U+/itfsK1DKa5Nu5gA9421Hmp2IobdcDbJobep
	 4jOJga0MmZFhKHuHjbK7/tH3UBpFZmUvoi2S1Bi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Corey Minyard <minyard@acm.org>
Subject: [PATCH 5.15 030/371] ipmi:ssif: Add send_retries increment
Date: Mon,  8 May 2023 11:43:51 +0200
Message-Id: <20230508094813.315341754@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corey Minyard <minyard@acm.org>

commit 6ce7995a43febe693d4894033c6e29314970646a upstream.

A recent change removed an increment of send_retries, re-add it.

Fixes: 95767ed78a18 ipmi:ssif: resend_msg() cannot fail
Reported-by: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -564,8 +564,10 @@ static void retry_timeout(struct timer_l
 
 	if (waiting)
 		start_get(ssif_info);
-	if (resend)
+	if (resend) {
 		start_resend(ssif_info);
+		ssif_inc_stat(ssif_info, send_retries);
+	}
 }
 
 static void watch_timeout(struct timer_list *t)


