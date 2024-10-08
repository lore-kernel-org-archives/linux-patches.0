Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C6F192594;
	Tue,  8 Oct 2024 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393400; cv=none; b=dDBzYjuB+5nEa1qEnl2VDlJuIzG2Kan1ZN1O6Bh8s5uodTbUfVRYDg3FPOmGtToV5rwMAxf3/9EHtUyRI2t5hI/456WSjfHt3D0h95McNM2FoQJmqHMjhcO8loSvG7kYKyt04UcLgxXiNrlEqCyEynwhk7PiJ6xzSq5nyXotqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393400; c=relaxed/simple;
	bh=fgF/Fl5BVB8g7mDaASXd1Lp3pYhmOoWr9ofgiV7ndeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enUrEoiuQo0dxTqL0X3Ew4zYV0d32es3fjHebVagA5yhDPgmKdG+B9OG5UyDtAm6g1Mn9Y7MEAGJYqWr4gggDtQmx8V4eMz9QbYPLRj/WIiGncqBjH8w6NLVyARmuwUWYtYrKPR9HosY1K4/+F2f8/7jWVtQQo4evj1LD2BVmmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huWmVxpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huWmVxpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E46AC4CECC;
	Tue,  8 Oct 2024 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393399;
	bh=fgF/Fl5BVB8g7mDaASXd1Lp3pYhmOoWr9ofgiV7ndeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huWmVxpEV57O/46dYiI2MkCvgIf3OlW5lDzHU/ovmL8n74nxZsUgN+XF6cjdSNJTA
	 /QcnWvOMBC7FC5Co/eXWVomFdTAn6xrW8E8VmnwcqjAA4ZEwWZWj0THPN9/lUXr6y/
	 t+6+cFuzMOau8wsaw8z4q5t57zwDy6nSz798NHPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	Attila <attila@fulop.one>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/386] hwmon: (nct6775) add G15CF to ASUS WMI monitoring list
Date: Tue,  8 Oct 2024 14:06:08 +0200
Message-ID: <20241008115634.277376146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 1f432e4cf1dd3ecfec5ed80051b4611632a0fd51 ]

Boards G15CF has got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

Add the board to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Attila <attila@fulop.one>
Message-ID: <20240812152652.1303-1-pauk.denis@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 81bf03dad6bbc..706a662dd077d 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1269,6 +1269,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
 	"PRIME B560-PLUS AC-HES",
-- 
2.43.0



