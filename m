Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E284D1786;
	Thu, 17 Sep 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668019; cv=none; b=L4Jxe8SkEuByaiWMvE7JBzagb4L/CNRtAlcUweaDM56XIjoZLovG3qB4pEKq7+LF51B1day3l/fTv0eGS6KiSv+4nz9nKORdTpJvA1ohF7RdrKqGqUd7hA2wcq0ToHnDH+UBM3TVvquHv4OADGBnidERAmLQ6gxi1AKzsaFQ/pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668019; c=relaxed/simple;
	bh=yFqPAySdDoq31rVBTv0D7RUXvjRRKTUUh7Lhfen2hKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWIYOCm6eMEvy7dCUsp0t8CFSbtYW4J5WjUWfTUGT3cXHKaOH2qGuiKRzfeGbCr+T55dYldZcpdvLmEIFbpZWNzMBTP4S49JaAmZhFi6qynl4JjCSDaZVZayInLS2hsHtjwmZCB3gZ+iw6ClXzgWTW/ELir7vCNqM/93orTIpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+6ZjJaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+6ZjJaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6D11F000FF;
	Thu, 17 Sep 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668018;
	bh=KHYlIhlyGxDOLgF/zdJqbHsw7IeaEzjsIrnSb+0nMcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+6ZjJaDAE8xaBFhxqZYsOYfxHX8ZAUBt+lqZ7Js1TxweKVNg1XF8WQ495rK21JU9
	 SDIFQGNH46w8GWlwPoVZCSeS+Ke/1lSBGjr6BETE/BtnrmzUtBk0Y66XxotPy3Kd5Q
	 klpTmNGIAn9RMDaCFJRG6J5QTjE/Wrc96zxF8o6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Sonichev <sonichev555@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0254/1102] platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table
Date: Thu, 17 Sep 2026 16:03:17 +0100
Message-ID: <20260917151545.971987418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gleb Sonichev <sonichev555@gmail.com>

[ Upstream commit bfe91a80b13f8068f6fa07aa8c468d284150d4ad ]

The Inspiron N5110 needs the touchpad LED quirk (Vostro V130 quirk)
to properly control the touchpad LED. Add its DMI identifier
to the existing quirk table, next to the similar Inspiron M5110 entry.

Tested on Dell Inspiron N5110.
The touchpad LED works correctly with this quirk enabled.

Signed-off-by: Gleb Sonichev <sonichev555@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260525100047.20046-1-sonichev555@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index 5a65e8b3ca1d4..6bf6caaa62b64 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -222,6 +222,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron N5110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N5110"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Dell Vostro 3360",
-- 
2.53.0



