Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBB30BF4E;
	Mon, 13 Apr 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097579; cv=none; b=QEpdbherIAGXjZ85aLJbT7Cj9brPCzGF8/Fh7MMkgsHxPrNJ9rWv9JcZPQjOT93TmS1d6Y+YTSy6Oh2Ufv0xwWiayRoONW6TP+fy4zrYpx6y3n4OU8Avy9+chBBGELeZhx7EzmC2B1f1lCl1eeJ4dQj1XCUk02BaD+GsvxwtQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097579; c=relaxed/simple;
	bh=67B6ja7e+tpixUXCXcjzAXVTF6YEwnjRA2nde6sNntk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQxrKi1fGOtQ+IUz9Uzrp5AoDWp40iskgKFus7GIIMQCwCcdetGOdR77jPURxjfnOZnN33qVXMm4PXS5ekdLgXtggGz1vSu/PtSV2Rc1BYrqI/aX5XK0vhn1FqALx61IfIO2BUVk99j7i7k/D3ZXs9Pnq6vqKgdMZBFe8GX7Tpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAlFuFWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAlFuFWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C646CC2BCAF;
	Mon, 13 Apr 2026 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097579;
	bh=67B6ja7e+tpixUXCXcjzAXVTF6YEwnjRA2nde6sNntk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAlFuFWeHJ7VSUG3nQdbVTYNirYLF0eqlWC0UiSL6zsLb80H2nww4tJuOd3fG5r8I
	 45vg8uu6S+lQmsmFvi7VGl9Ov+s6xKL91eb+p+TOHa6hRGWPfSjIS6s03f8URRidNV
	 a5s0RDJHaDCkQPvoX0NE8f4Cvhg0TJ4o0NsMYzuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 190/570] i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors
Date: Mon, 13 Apr 2026 17:55:21 +0200
Message-ID: <20260413155837.576103902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,7 +335,7 @@ static int hci_cmd_v1_daa(struct i3c_hci
 		hci->io->queue_xfer(hci, xfer, 1);
 		if (!wait_for_completion_timeout(&done, HZ) &&
 		    hci->io->dequeue_xfer(hci, xfer, 1)) {
-			ret = -ETIME;
+			ret = -ETIMEDOUT;
 			break;
 		}
 		if (RESP_STATUS(xfer[0].response) == RESP_ERR_NACK &&
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
@@ -237,7 +237,7 @@ static int i3c_hci_send_ccc_cmd(struct i
 		goto out;
 	if (!wait_for_completion_timeout(&done, HZ) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = prefixed; i < nxfers; i++) {
@@ -311,7 +311,7 @@ static int i3c_hci_priv_xfers(struct i3c
 		goto out;
 	if (!wait_for_completion_timeout(&done, HZ) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = 0; i < nxfers; i++) {
@@ -359,7 +359,7 @@ static int i3c_hci_i2c_xfers(struct i2c_
 		goto out;
 	if (!wait_for_completion_timeout(&done, HZ) &&
 	    hci->io->dequeue_xfer(hci, xfer, nxfers)) {
-		ret = -ETIME;
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 	for (i = 0; i < nxfers; i++) {


