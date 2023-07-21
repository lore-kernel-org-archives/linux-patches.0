Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9431F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92886C433CB;
	Fri, 21 Jul 2023 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956606;
	bh=VaieRwtRXIYoNazqjVncV19+8oMOof3P0dZlhmGGZmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxCRc0qnKxRTGMyHhE1y6OyNWhUsXEBTKkMw5+8gYjdveIIPuU+fez4dMnMcYb7C4
	 AwTMk9HOkl+xrmwayFNKWqs4EBruMsqUKbGd7Ugzsp+tTtdI7G7nC9COJRiOkfO5wg
	 mmKIxNxAIUkuaa0M/Df5OfRaeZMS3ZgasNxk4zkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.4 236/292] dm: verity-loadpin: Add NULL pointer check for bdev parameter
Date: Fri, 21 Jul 2023 18:05:45 +0200
Message-ID: <20230721160538.997307125@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Kaehlcke <mka@chromium.org>

commit 47f04616f2c9b2f4f0c9127e30ca515a078db591 upstream.

Add a NULL check for the 'bdev' parameter of
dm_verity_loadpin_is_bdev_trusted(). The function is called
by loadpin_check(), which passes the block device that
corresponds to the super block of the file system from which
a file is being loaded. Generally a super_block structure has
an associated block device, however that is not always the
case (e.g. tmpfs).

Cc: stable@vger.kernel.org # v6.0+
Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20230627202800.1.Id63f7f59536d20f1ab83e1abdc1fda1471c7d031@changeid
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-loadpin.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -58,6 +58,9 @@ bool dm_verity_loadpin_is_bdev_trusted(s
 	int srcu_idx;
 	bool trusted = false;
 
+	if (bdev == NULL)
+		return false;
+
 	if (list_empty(&dm_verity_loadpin_trusted_root_digests))
 		return false;
 


