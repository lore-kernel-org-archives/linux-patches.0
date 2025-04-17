Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F79925525D;
	Thu, 17 Apr 2025 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915585; cv=none; b=OhPw0kCfadWXu+gosGJTMW37LrliH3sieW63dMgpoKKkaOSyLI3fE801a0nysS7AjJ8OiijmhGApt+9NoLFGSfBOKa99AUdxKYM348f5E5Ld5oMZAqOEOWwwnIJ0/FWoVULWORHtn/scIZT5A0VJnWvZLTWFXbCZ7Fp3dEdGBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915585; c=relaxed/simple;
	bh=SpWEkVbqFsSpsE5lCP52yn5rYWtI3niNJHGHKc9EM6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVCeUtKz+ILZcNwGazYLGyxLRRYwb9spMIiX3EeW6AQ5wTw5jjevLgzLTKNoDg7YHmbqxF1FL+WjZl9udROwFjsnMgXHZxEVXZLWjK2IzI4stEFA8kT5iW4mRTRzvOHZRCHUuvU2i3DhluVaOnQEZh/51/F8vHueU2mykegB4Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EO7n8eoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EO7n8eoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00042C4CEE4;
	Thu, 17 Apr 2025 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915585;
	bh=SpWEkVbqFsSpsE5lCP52yn5rYWtI3niNJHGHKc9EM6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EO7n8eocCcjgcP095csojQGw1jUydaxlWRg90dOzL0X4JhmpPRxxjXy0mPtmgOZa6
	 x71DnkYmVJdNFm+VwNwFTlOjEK7nDlIFL+p2nn9VnOzh6bcnAjyil2xavZ25JJgUzn
	 WLTYnBYZP18ZTA27B7NdcK32sUOkL99QXsmFJvhE=
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
Subject: [PATCH 6.12 174/393] HID: pidff: Simplify pidff_rescale_signed
Date: Thu, 17 Apr 2025 19:49:43 +0200
Message-ID: <20250417175114.598536976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



