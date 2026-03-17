Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B4615E5BB;
	Tue, 17 Mar 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768435; cv=none; b=a+y/6ZXwpU93VygDOobjaZk/3YE0xq1QZT9322L374X39shSSvFJ7LP2zrVSZBQNnd69qXboqNQDcZZqYF3en5NncQ6vbqfVwkWcFUbF7NFipjdlvlQuqlNf6ZBQirVNDRUCuFFw5s8MOpBPI/iAAavvCs8emusaaHmP0rJdsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768435; c=relaxed/simple;
	bh=Mdqa3E2UAMmNIy6x5nc+tPNXaFNWmwGDoXbX0wd/d48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9X+7J/mXOHqauFd0ZW5wyESGE1gjkkftPfTI/iORQEXIHApI/hudtPddYCsQUZiCBAs2Xm4Of+NHA8L/iQ7UZlpdDVZleH66BKxlOcrgwl5QuHT0o1ep1aNDlwNXqJvBLX49dPOyg+fySMsLWWMqfFfnO+Exy4Jk2qmbNdSVJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TQ0Rs+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TQ0Rs+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF977C19424;
	Tue, 17 Mar 2026 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768435;
	bh=Mdqa3E2UAMmNIy6x5nc+tPNXaFNWmwGDoXbX0wd/d48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TQ0Rs+mgd7M81RWY+szSagc3YlqV7x9s9tVY0uJgmLbLduAsEC1ZMapsQRfxoqEW
	 fvhPtHiOdoqdWa2zEfeU3dbGzmb6DFOF9BzCBO+1ai/j/EBL4ezq0zHBxaovXIzwBQ
	 LrtF2yYdRzyNQdkIhCt1UQuWnZG/KrUzOQTAhqeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 308/333] i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors
Date: Tue, 17 Mar 2026 17:35:37 +0100
Message-ID: <20260317163010.809529057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 4167b8914463132654e01e16259847d097f8a7f7 upstream.

The MIPI I3C HCI driver currently returns -ETIME for various timeout
conditions, while other I3C master drivers consistently use -ETIMEDOUT
for the same class of errors.  Align the HCI driver with the rest of the
subsystem by replacing all uses of -ETIME with -ETIMEDOUT.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c |    2 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c |    2 +-
 drivers/i3c/master/mipi-i3c-hci/core.c   |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
@@ -336,7 +336,7 @@ static int hci_cmd_v1_daa(struct i3c_hci
 		hci->io->queue_xfer(hci, xfer, 1);
 		if (!wait_for_completion_timeout(&done, HZ) &&
 		    hci->io->dequeue_xfer(hci, xfer, 1)) {
-			ret = -ETIME;
+			ret = -ETIMEDOUT;
 			break;
 		}
 		if ((RESP_STATUS(xfer->response) == RESP_ERR_ADDR_HEADER ||
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
@@ -277,7 +277,7 @@ static int hci_cmd_v2_daa(struct i3c_hci
 		hci->io->queue_xfer(hci, xfer, 2);
 		if (!wait_for_completion_timeout(&done, HZ) &&
 		    hci->io->dequeue_xfer(hci, xfer, 2)) {
-			ret = -ETIME;
+			ret = -ETIMEDOUT;
 			break;
 		}
 		if (RESP_STATUS(xfer[0].response) != RESP_SUCCESS) {
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -230,7 +230,7 @@ static int i3c_hci_send_ccc_cmd(struct i
 		goto out;
 	if (!wait_for_completion_timeout(&done, HZ) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = prefixed; i < nxfers; i++) {
@@ -309,7 +309,7 @@ static int i3c_hci_priv_xfers(struct i3c
 		goto out;
 	if (!wait_for_completion_timeout(&done, HZ) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = 0; i < nxfers; i++) {
@@ -357,7 +357,7 @@ static int i3c_hci_i2c_xfers(struct i2c_
 		goto out;
 	if (!wait_for_completion_timeout(&done, m->i2c.timeout) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = 0; i < nxfers; i++) {


