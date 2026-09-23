Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0F376A1B;
	Wed, 23 Sep 2026 14:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173846; cv=none; b=IOyX8R5U708acwk/MaTjlZ+8/j36EX9GIMwC0wnWcpOwyaMt0oU3YoWBkiC7aCaJZ+K5YQTwWzIKfmHdKwam8SICbHjP2LP94Km5aWNuI4CgHPcCtWXgoBasq0FnAofCbgzPALinPdBevwD6zonyGE5crC2i/eOE8VGS8Bgr88c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173846; c=relaxed/simple;
	bh=IUey6Ta7m87oipPP/iHtdohHuZmOutaa4uclgbn9vkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9/gL5qLGXSKWHY7gSq0i6ojDVBY0PSohEisH2HPD04Jok08M5djDtnIBzZdwH88M1XQfWBBOIuJoyy2M5eQPvPey5xCZld0/x0Kz6SatAlcHr7N46NaJDhBAqxuWvfRH9o+nets1jS4qYRjVebBSPWJnJx7FpGEfN2F/ctvivY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh2Ng3Jz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh2Ng3Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF92C1F000FF;
	Wed, 23 Sep 2026 14:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173845;
	bh=62nBWrs40vPZhvTOnd559D7FU2jHIVH+lYQj0wbb3S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh2Ng3Jz7alXJO6ICdbJYz6f4fS1FOjh+FCP/yEj/81gxR/mmkbUHy4IteK7gXgRe
	 K7ZsIsBfpHFSCoDuex5uEb/5GwH2+mZpNCvaEFuqD0rliPS1jB/8wItfxusoknf2Cx
	 gOMb8/KkzeFhZJTQu1Ju99ukWtYHYTcVOpUa4q7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 361/438] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 23 Sep 2026 16:06:22 +0200
Message-ID: <20260923140654.208907069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit fb5022278b6ea7f1838e3ef78028d5d5e3375f65 upstream.

Check that btns_desc->package.count is not 0 before accessing
btns_desc->package.elements[0].

Fixes: 4c3362f44980 ("Input: soc_button_array - add support for ACPI 6.0 Generic Button Device")
Cc: stable@vger.kernel.org
Reported-by: Shashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-input/20260909091440.3384C1F00A3A@smtp.kernel.org/
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909093934.29411-2-johannes.goede@oss.qualcomm.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -377,7 +377,7 @@ static struct soc_button_info *soc_butto
 		}
 	}
 
-	if (!btns_desc) {
+	if (!btns_desc || !btns_desc->package.count) {
 		dev_err(dev, "ACPI Button Descriptors not found\n");
 		button_info = ERR_PTR(-ENODEV);
 		goto out;


