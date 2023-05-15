Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12431101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69534C433EF;
	Mon, 15 May 2023 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173196;
	bh=GqcxkQEDLYKP4iGEAZs/PyZxjK2Epw3F+spPcWsxw+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvvoZUdTMtz8sbdylO95PKNJu32nCkEYufG7qBq+2PFzaKk1aMZ5MW1CI6aVVusbz
	 CNJfI1yUksLuVkeAq00TIHrCLwmcEbsa1sqkR2OdT4HbHk6zhuoZMigK2ED7f1TSh4
	 vV+6QXhSVDX/7sAyVZpVEI7yCyP4Lu7ANZcK0QL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Corey Minyard <minyard@acm.org>
Subject: [PATCH 5.4 017/282] ipmi:ssif: Add send_retries increment
Date: Mon, 15 May 2023 18:26:35 +0200
Message-Id: <20230515161722.784378833@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
@@ -562,8 +562,10 @@ static void retry_timeout(struct timer_l
 
 	if (waiting)
 		start_get(ssif_info);
-	if (resend)
+	if (resend) {
 		start_resend(ssif_info);
+		ssif_inc_stat(ssif_info, send_retries);
+	}
 }
 
 static void watch_timeout(struct timer_list *t)


