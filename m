Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C262387361;
	Tue, 10 Mar 2026 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142007; cv=none; b=tEwTeAZtCnMb+6WTlZ1Yjagq//fo1Iv1/rrssiWrZuRqcJ7bU59hmuTfGrhjtbcd5LQJ0WvLm24yHoG56vOtH8qNsRZLkblXctQAXDZNrF1bvEglbgyG98mPzwXFLPL1m4wHLeWsTrySYCg2reWmDUiiCQ3f8rxzsI69RdDy55M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142007; c=relaxed/simple;
	bh=Hh591+xD1Nclp492E0PdaKSIxwUvAMs8sCX2/GhP1C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOW0bZafZCuRjQ1VFA88uiQ2/j0lW+40wPofK0SnW8uLLJYK+cmknosNARF7D9ywl6nY/tlUYOONtNY4bZky+nv0ugfYfhPhynt1aDQ06zciqehMgYIv0fZ4rJkD1qWo58W0vAOsKp+g0xf0szqR8vl+otD9or5RskqccF6aYnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUf+r+f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUf+r+f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA00C19423;
	Tue, 10 Mar 2026 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142007;
	bh=Hh591+xD1Nclp492E0PdaKSIxwUvAMs8sCX2/GhP1C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUf+r+f97COnZLWj+riMFQxwlIt3eNlolbK8LMyAoTqar5eQX4FxfkESMPeXTMD4h
	 BMCpeTzNY4kAx4LCMZ1nDSfZnfpdjRA5HO1KSh+T+xeKEpFhyZZgbsvwOwczKLHTpn
	 k72+G37Eddo/A6FK+gxemp9M+eWckRbgrbxFynHUWaSnGbmmxWRaTQBBHZFQ0b7bET
	 svmPm146HaIWC0T1E3xCf+JYx0PCinFcES8EkBu7UY1Sbn+e3/pBHPrgg2+yXLwdIz
	 Npxp7SaZa4PJHvg5PBChK2PclkpHjLgnNORyHQeIF7d33l1TDtunfm9bPBC+NxmU9y
	 Md1rF4wQWvh4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 133/314] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Tue, 10 Mar 2026 07:16:32 -0400
Message-ID: <df6bf8feb48100c3fc936a1472eecb154746f2d9.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 12133a483dfa832241fbbf09321109a0ea8a520e upstream.

When the device is disconnected from the driver, there is a "dangling"
reference count on the usb interface that was grabbed in the probe
callback.  Fix this up by properly dropping the reference after we are
done with it.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Link: https://patch.msgid.link/2026022329-flashing-ought-7573@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 018a80674f06e..0f12f86ebb023 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -628,6 +628,7 @@ static void pn533_usb_disconnect(struct usb_interface *interface)
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	kfree(phy->ack_buffer);
+	usb_put_dev(phy->udev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
 }
-- 
2.51.0

