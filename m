Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1823EC433D2;
	Mon, 12 Dec 2022 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852442;
	bh=sO1ed7ZnBP7kTwzCaWyFndvh/VR+YDPGV8JfbbOd36I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2n1Plu0nYHFTXMdk8nZlUUq1pQGiKi0r5CjpGDWyYEXNsFZVe/z7jn6ZJn+I1MfIz
	 84tz+k4rWQl8IQEGgF4pGlADslL6r6lVTkOZeJS2JumWTgDM0mhgwMNR9mq3NGHb4c
	 E61J6BMi1C00AOS8mtG1UNRv5vrri11+zWUZcKi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 081/157] HID: hid-lg4ff: Add check for empty lbuf
Date: Mon, 12 Dec 2022 14:17:09 +0100
Message-Id: <20221212130938.037650446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anastasia Belova <abelova@astralinux.ru>

commit d180b6496143cd360c5d5f58ae4b9a8229c1f344 upstream.

If an empty buf is received, lbuf is also empty. So lbuf is
accessed by index -1.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: f31a2de3fe36 ("HID: hid-lg4ff: Allow switching of Logitech gaming wheels between compatibility modes")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lg4ff.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -872,6 +872,12 @@ static ssize_t lg4ff_alternate_modes_sto
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);


