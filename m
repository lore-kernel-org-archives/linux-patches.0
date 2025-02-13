Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3728A15A856;
	Thu, 13 Feb 2025 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461023; cv=none; b=ae1A4QAKLF2gJrTNN20ckg63pfCx44lcn4VnQ5LSxR67BvnOWujCoEUt9sb7vOXrpvNr7R78jZOkkeoeuxE0FSCMloDHz1Spx9W4C0ErYs9lYOdeaSwJ15VirTI+hdu7VigTEvb9va5vPN+hNdZvRHp922Df74XSb3AjOzEt4f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461023; c=relaxed/simple;
	bh=/CXSdpSQOl7Gdc92N2cFxG/o/G19Yb3w15vxUDIfOWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpNlnex2xQC6X/R9opYPYetzFS646CP5b+G+GLajp3KKG06VrL16RBuylgoH+HEhql5dtDjawxih9E82lFWrxgkdnRonbhauN0V2yleKOVriSKYddoqWJFxHhEHe2aOSUrh8dvzsP2XTX2t4pw3lDRsm9P9iziEzSj1I+WeXxbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxD1LyMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxD1LyMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432D2C4CED1;
	Thu, 13 Feb 2025 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461022;
	bh=/CXSdpSQOl7Gdc92N2cFxG/o/G19Yb3w15vxUDIfOWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxD1LyMBHUQzs/4lrVskwe9oEsRypi7W/emc247a0Io5iWNqv7RYPxGdLMeszPqGb
	 V4GUUZaFUGWtsk47DbDSHLnsIMV1+toGULSn6N9jpUQBg53yCIUXwxdwUP+U9zm8K0
	 KfY79suRpW3OIVZ4sWm0QV1rhAuhvZNLiy3sHCq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 238/273] i3c: master: Fix missing ret assignment in set_speed()
Date: Thu, 13 Feb 2025 15:30:10 +0100
Message-ID: <20250213142416.840799638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit b266e0d4dac00eecdfaf50ec3f708fd0c3b39637 upstream.

Fix a probe failure in the i3c master driver that occurs when no i3c
devices are connected to the bus.

The issue arises in `i3c_master_bus_init()` where the `ret` value is not
updated after calling `master->ops->set_speed()`. If no devices are
present, `ret` remains set to `I3C_ERROR_M2`, causing the code to
incorrectly proceed to `err_bus_cleanup`.

Cc: stable@vger.kernel.org
Fixes: aef79e189ba2 ("i3c: master: support to adjust first broadcast address speed")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20250108225533.915334-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1878,7 +1878,7 @@ static int i3c_master_bus_init(struct i3
 		goto err_bus_cleanup;
 
 	if (master->ops->set_speed) {
-		master->ops->set_speed(master, I3C_OPEN_DRAIN_NORMAL_SPEED);
+		ret = master->ops->set_speed(master, I3C_OPEN_DRAIN_NORMAL_SPEED);
 		if (ret)
 			goto err_bus_cleanup;
 	}


