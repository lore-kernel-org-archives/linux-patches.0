Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B08481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62F2C4339C;
	Fri, 10 Mar 2023 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456880;
	bh=FUCWLS/7vbF+P+R1E0PQ2GUZNu+Szjwa/c5dSR33D+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVujG9ggr498gUhOmWCU5YURGfxIM3riz3qS1AKze/o0QhRha2IEERkcHsQVJuarQ
	 ix5BEZjFupePRfGogqXqthwkQFV37BuKippCNIGJJp5U3TZi8j1ZJSaCYf/Hhzz4nS
	 HqrGOMTrY1W9bjJu+fEVb1L5Un0AcK28bldhQpkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 157/211] USB: chipidea: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:38:57 +0100
Message-Id: <20230310133723.527573029@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ff35f3ea3baba5b81416ac02d005cfbf6dd182fa ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230202153235.2412790-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index faf6b078b6c44..bbc610e5bd69c 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -364,5 +364,5 @@ void dbg_create_files(struct ci_hdrc *ci)
  */
 void dbg_remove_files(struct ci_hdrc *ci)
 {
-	debugfs_remove(debugfs_lookup(dev_name(ci->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(ci->dev), usb_debug_root);
 }
-- 
2.39.2



