Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942961448ED;
	Tue, 16 Jul 2024 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144056; cv=none; b=qMm0ZlY8uNt5+LeiCvqEsLlUdA6DVbf/Rdi/ostr/tSQSfATjFzS2epksPcj9A5SStJHeBhQlu57GNt3wh6Xj+oNDMavhlhuA5Diu4m0lU3RbUvd48yBWYHyruUXkA1Vguqn5j9Rq5hAfNRpAN0ptQeJFZ+AuhihbBzywdVkoFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144056; c=relaxed/simple;
	bh=omEYgwGydIeQxTS4FGz/Ne7aLOelFc7mb44q6ObFbtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyzxTSUuyEhmHR40RLS4ipH3UyZx+pcE3cjxJz6yxUKcszUiUMH1E8g8GgdWof3+IKkNnKo7O9/+z/6Rlf+ogz7/VauOVceQv+Q+RvZU1nw38UMM8azF9TUK+RaT2XPukPnUOnCZrRAscEVF4LrQ5pV3gnm36jSHuNRiVZSzBhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL4lTPzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL4lTPzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3268C116B1;
	Tue, 16 Jul 2024 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144056;
	bh=omEYgwGydIeQxTS4FGz/Ne7aLOelFc7mb44q6ObFbtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL4lTPzuT+ZbB7/iFnoTIZa3P17cL+8VpTILIvlqScRqbdUjBvjmcONwcbngMf5LE
	 0vmC3VvYW3zNBlXJ9EwEIWBbqoBA2QGbCHJdhni12IAI+AdWu/33NTCeSupOAwUlu1
	 08SErWwvCGc461Zv1sLGX+ZVsESddumfsCQwArZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/66] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue, 16 Jul 2024 17:30:48 +0200
Message-ID: <20240716152738.669651202@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index c18b899e510ec..c1e2539b79502 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1039,7 +1039,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



