Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EFC2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8065C433D2;
	Sun, 22 Jan 2023 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401060;
	bh=rwBkHwuZlvnW+HjdscmqQ1DVruv9cfRmSD9EqjFf8wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vX7rgSHH/I6Wm5C7yXk+7nFOcQSPOGh/485IMhDXs8SFRWsYVnqaO5wLoF20wuX7Q
	 9a+8M/7HOwcn81sxY+5hg8yuXym3NbLPn62vVuzw7Eoy2/MxRDthr8H8eTOeqnPXql
	 O26LGo6kvtZjj/WDef1y9w88P5NehFUrByIHNH/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Utkarsh Patel <utkarsh.h.patel@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 093/193] thunderbolt: Do not report errors if on-board retimers are found
Date: Sun, 22 Jan 2023 16:03:42 +0100
Message-Id: <20230122150250.610561840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

commit c28f3d80383571d3630df1a0e89500d23e855924 upstream.

Currently we return an error even if on-board retimers are found and
that's not expected. Fix this to return an error only if there was one
and 0 otherwise.

Fixes: 1e56c88adecc ("thunderbolt: Runtime resume USB4 port when retimers are scanned")
Cc: stable@vger.kernel.org
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -471,10 +471,9 @@ int tb_retimer_scan(struct tb_port *port
 			break;
 	}
 
-	if (!last_idx) {
-		ret = 0;
+	ret = 0;
+	if (!last_idx)
 		goto out;
-	}
 
 	/* Add on-board retimers if they do not exist already */
 	for (i = 1; i <= last_idx; i++) {


