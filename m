Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980529D26C;
	Tue, 17 Mar 2026 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766973; cv=none; b=rpYuVOcfaKjtEQxianIhJFt/PsgB/Lg8ayLUELA1jT6ADEHKew7axwU9MWZhkqB8FT2HxpN+kdYtb7DOFSCiF7fkLylfkWA7ipfYGY4kLEMR7I4B9VRVv8U/R2soVdUsRJhWY0sd43kNMDmyCS0Wr0CSYHvCWcwmcVdDTDRQnQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766973; c=relaxed/simple;
	bh=5FEf0JZzIqKtLkIsgVLEy3JZQDPvnPXO4hZgwzyy8vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3RLXIy+vK0OcbRsEYDn6W1w3S8WoLFE/DYH2rjKhDhIzolJvcq38cJoqli7dI1r6h1ZNHP0qL/vLFoA3yc8xmGRdHjHH83Ngo2WKNrLjVOqMrpVELteobh69VlNbSpbUic9ZWn9NwxZ162vzLzJzmuY/EO+GHpdbcEVeS5thYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOc09HKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOc09HKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79F4C4CEF7;
	Tue, 17 Mar 2026 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766973;
	bh=5FEf0JZzIqKtLkIsgVLEy3JZQDPvnPXO4hZgwzyy8vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOc09HKohm+7fbl8PT+MqjA3SI2odBn51X4C6dth9IrGsbj7HFy5AJYAIU5CgbnK4
	 C29ANZpP3UBY2p7uDV/vkVpfClG4h8j/mlot5DbNqawBpmSSwFVkBA77yHP1X1sifT
	 fSmeZ1wC182I2e6Z+aedQm6Zf7EnNLYdvKazJdnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.19 364/378] i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors
Date: Tue, 17 Mar 2026 17:35:21 +0100
Message-ID: <20260317163020.371802319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,7 +309,7 @@ static int i3c_hci_i3c_xfers(struct i3c_
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


