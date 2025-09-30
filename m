Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC71C862F;
	Tue, 30 Sep 2025 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245670; cv=none; b=BFnBFAjk6BGBUtXlbJquOKYeUEw/crrq7sXUGbqkrIvgaiNh1MQn3DVbLRCyGVZouVOvcUY/EWGI90BT2MDSdDiO0WJlBfGS9naWJgGlT5LRjnrEv1sEU7aqswjhvBy6ttBPBOFVWmpu2I51lO+FYeeXAB3Fg/wA90jEzlPsI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245670; c=relaxed/simple;
	bh=pxK/BksZTISZiEKfeUo/y8D+1AxPpvsglu1njZ24+YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK/Q8jWtGcQXcKMksOt12fs9jePhWtMeH7z36Oxcswu3hhLXtfexazzjDrpdru9+sClGVs+tsgJooqmRjAg5pBV5sO1oOAbRmBJAupKOuAg0LLrmfF0U5gTXRPw5Lsei3kE7WJN6DFnY0OMIEKa7ybw8PKVqZIMUVL5LH8PP8cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnkMngBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnkMngBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4863FC4CEF0;
	Tue, 30 Sep 2025 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245669;
	bh=pxK/BksZTISZiEKfeUo/y8D+1AxPpvsglu1njZ24+YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnkMngBDtVnvxaIS9wknIq3GMn5Az9slukNGHZ+N4Hj7375pkVYOwvlze/iFM/iBA
	 OmtxgBQUqrmI7uCcZWCqKn3p4be24nYelyW/j5o+rpjPsYFtwb73S6R9MUz3IGPK70
	 8tx1jTesGKI1CKxjTHkQjkQev/oU7biGIQF7BqO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayi Li <lijiayi@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/91] usb: core: Add 0x prefix to quirks debug output
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143821.764160180@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayi Li <lijiayi@kylinos.cn>

[ Upstream commit 47c428fce0b41b15ab321d8ede871f780ccd038f ]

Use "0x%x" format for quirks debug print to clarify it's a hexadecimal
value. Improves readability and consistency with other hex outputs.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Link: https://lore.kernel.org/r/20250603071045.3243699-1-lijiayi@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index bfd97cad8aa4d..c0fd8ab3fe8fc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -734,7 +734,7 @@ void usb_detect_quirks(struct usb_device *udev)
 	udev->quirks ^= usb_detect_dynamic_quirks(udev);
 
 	if (udev->quirks)
-		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
+		dev_dbg(&udev->dev, "USB quirks for this device: 0x%x\n",
 			udev->quirks);
 
 #ifdef CONFIG_USB_DEFAULT_PERSIST
-- 
2.51.0



