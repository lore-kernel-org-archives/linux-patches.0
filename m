Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70551A3178;
	Thu, 17 Apr 2025 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913028; cv=none; b=M2Ha3Gn+9RFcsrLHudixzla8bWBsJiXqPopx2YxqwGUNJeJuErq4NDHoPV6Ag0c1WYfE4OzOs1KXZqN2rGzDz9h5mFNiK7ZIQBIOvVrb+0Q4nVZL4SEcFE07UuDM1kiMCNFreh2snfqWbukQ72y3glLCYSyrF4z+tjWwGhN0Vtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913028; c=relaxed/simple;
	bh=Z/DISrN8zjToAaeJIACxwjaji9fs2WtlHh7pNzyvmjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2nM1k7CeFNWtJ4Xzqhv9B3gwjpQAqEDboZBhYDDvIHq+rOY/ezIpw16o5BSkn0bgPZ958jPKo7J4Fbpn+J1kCAp/3Zf9prIQoMYSYtQvxhjfsx6SRRDnS4zq85usm3tOnW/LgmZDk6ai73Xd3pZmfKoQud7nlFjn4n1jqKn8gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC4Tu9IL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC4Tu9IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B088C4CEE4;
	Thu, 17 Apr 2025 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913028;
	bh=Z/DISrN8zjToAaeJIACxwjaji9fs2WtlHh7pNzyvmjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC4Tu9ILLhGZ0c6SgQpavt7EwgPZj5euPz75xOSiXPZ10SyDZQxRabmVLZwwQlLEt
	 +f8EY5VGHu7Fgu+7jSEnL34HEUdCYXs7qOpLSncXkNwhLmTVHV7Kpa9Y8cBxjHbSzB
	 FZnjyaU8NRkczJOtr6MLKxMCFI8R2yOgz7IpnIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 204/449] HID: pidff: Simplify pidff_rescale_signed
Date: Thu, 17 Apr 2025 19:48:12 +0200
Message-ID: <20250417175126.177254708@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 4eb9c2ee538b62dc5dcae192297c3a4044b7ade5 ]

This function overrelies on ternary operators and makes it hard to parse
it mentally. New version makes it very easy to understand.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index a8eaa77e80be3..8083eb7684e5e 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -230,9 +230,9 @@ static int pidff_rescale(int i, int max, struct hid_field *field)
  */
 static int pidff_rescale_signed(int i, struct hid_field *field)
 {
-	return i == 0 ? 0 : i >
-	    0 ? i * field->logical_maximum / 0x7fff : i *
-	    field->logical_minimum / -0x8000;
+	if (i > 0) return i * field->logical_maximum / 0x7fff;
+	if (i < 0) return i * field->logical_minimum / -0x8000;
+	return 0;
 }
 
 /*
-- 
2.39.5



