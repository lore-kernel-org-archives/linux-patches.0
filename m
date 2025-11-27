Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A1B21770B;
	Thu, 27 Nov 2025 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254877; cv=none; b=cWHdfVU9nIy+7P2t6kQlJtR9PDkKmVIbqpPBaOhKi3vGPgokBoE0lCH/xOaeKSw3iyuJ8OWv+3bs4C65mCbJcHXYOECmn+KVs2pHi7SmQ0vugD65I9S+NcFi6Fk0/dTFLjk2bE8BKxVIQrBpwMILMr+1KG/9DsMpXYYLZevvWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254877; c=relaxed/simple;
	bh=L20LJ+TQoMJrHv/sQPWtcsESKgAOl7MiVwiG6YluCFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/pzUt7o2Y4aK30q913MnVZI9+naca/1Bp2vKZ6qNT8C49X+XU53ABT5xFrvdboBv++s/VI/bsdnrgMRDq4FFZJRfVz3OnWAFu0B3hMA4ljgfCZyFXEXRAVrqvPbqtRMLq8Xn6qVdHXlvurncOM/JGDs6GddN71gg9VXIqrHiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCK56HYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCK56HYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB48C4CEF8;
	Thu, 27 Nov 2025 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254876;
	bh=L20LJ+TQoMJrHv/sQPWtcsESKgAOl7MiVwiG6YluCFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCK56HYEXgap5mK9h1UwaSseeZZs9LxdGrBP4xP1mMyD731/O/PIUHrLrby1XGKRk
	 s4gihbVyYFjepf6TQRAXXdVz644GmcyJwOacOLiksqzkHp29lgr22aH/GEuMAEyxXt
	 EtxikweJ985aSG3ywgJtVa3ONIFRyXlrmhoJi7sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weikang Guo <guoweikang.kernel@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 17/86] Input: goodix - add support for ACPI ID GDIX1003
Date: Thu, 27 Nov 2025 15:45:33 +0100
Message-ID: <20251127144028.445205015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit c6d99e488117201c63efd747ce17b80687c3f5a9 upstream.

Some newer devices use an ACPI hardware ID of GDIX1003 for their Goodix
touchscreen controller, instead of GDIX1001 / GDIX1002. Add GDIX1003
to the goodix_acpi_match[] table.

Reported-by: Weikang Guo <guoweikang.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-input/20250225024409.1467040-1-guoweikang.kernel@gmail.com/
Tested-by: Weikang Guo <guoweikang.kernel@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20251013121022.44333-1-hansg@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1519,6 +1519,7 @@ MODULE_DEVICE_TABLE(i2c, goodix_ts_id);
 static const struct acpi_device_id goodix_acpi_match[] = {
 	{ "GDIX1001", 0 },
 	{ "GDIX1002", 0 },
+	{ "GDIX1003", 0 },
 	{ "GDX9110", 0 },
 	{ }
 };


