Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060619;
	b=yZaC8fdmlef3/XrGiqThp4QzjU73THd2vD/KVnHZVJ5/BEpZOn4GRS4CLGeJzOc5S2H4
	 D5PMI3mMsZRwy88AdKPchEwTquuS5XAw14PXvzrLxg9Nygn3yl74+YjsZybXXBOkCT9Yy
	 J6LU0hWwvDZjRwWhkGBKFv0cNgKbfw7j1uriH+rP9IANQdObYhuYLWV7LBogVuW71xrlw
	 2r0VYYZy0VXnS/0VGUhUSmBAg6RRhf/qo0SFqK0rQzlOS6utGSio+CEVCNmLXbV9C/xQo
	 1U1wsXmob441zjbdyPgO10mAJIV8ljwwWPxH3jCf0QOATHj8yRCdotgoAcHlVRawoaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9EOqs1SLoikJo7oX5RA4RuFpepzu4JiembWU3t/Kuqo=;
	b=EiDtaaOITeqqQtp3DeevN6q4c2w0IqFksvjCF0aC2MtbWUChlOIakPGj7z+HlaRQOqJO
	 VvZt9AFLlaY7SMLFJZu5tw/Rn4yY9QhKEYtdWfTtNE5wcIO61m2PwNks+m1ZfEK7YDquw
	 MGWpA+FxrhTi9zTjsG4UhLfat52TO/eYvNESIjofb0+Kv9Axar/vN/BnRU67h73mxVp/8
	 6iR48RCA/4TNsB0CLvC9vXyYbNdeDg2Cr3CHxi95JFVr6pJclkpCyv8A6B0RhkF7XGoL7
	 M1PkUMnvsxk27QSxnS49z67ChCZ+VvSUqCQW5UUa6T1eulv30ImmjlSQoS2klDcIf2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hhe0CrH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE15606A326;
	Sat,  7 Nov 2026 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hhe0CrH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610701F0089F;
	Sat,  7 Nov 2026 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060618;
	bh=9EOqs1SLoikJo7oX5RA4RuFpepzu4JiembWU3t/Kuqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hhe0CrH1UmriLPz1u0QesuDeLnOTQ6/ZPuSjor1df8NQwwwQXF+DQNFmM3yMACay0
	 UZDfCmk9C4ZdujqDJxJ5fVpHXSPFQCHqSRdDMbM7IlaxCU2JF4vYpGgy0vnBBnpgv9
	 cziuq+P1IG2dpIoPktR5lRwGWtFOxYO+aoQqp28w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0067/1536] drm/panel-edp: Support MB116AS013 edp panel
Date: Sat,  7 Nov 2026 08:34:43 -0500
Message-ID: <20261107134959.548762308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>

[ Upstream commit 844e71ba7d7a50c5ffa29d147afaeaafb19b39e4 ]

MB116AS01'3 raw edid:
00 ff ff ff ff ff ff 00 21 63 03 12 00 00 00 00
00 23 01 04 95 1a 0e 78 23 e7 05 9c 5b 56 93 27
21 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 36 1c 56 92 50 00 1c 30 60 18
a8 00 00 90 10 00 00 18 00 00 00 fd 00 28 3c 30
30 07 01 0a 20 20 20 20 20 20 00 00 00 fe 00 48
4b 43 20 4d 59 20 20 20 20 0a 20 20 00 00 00 fe
00 4d 42 31 31 36 41 53 30 31 27 33 20 20 01 cb

70 20 79 02 00 22 00 14 1c 1a 01 84 55 05 91 00
5f 00 17 00 ff 02 1b 00 09 00 07 00 2b 00 06 27
00 28 3b 00 00 81 00 13 72 1a 00 00 03 01 28 3c
00 00 00 00 00 00 3c 00 00 00 00 25 01 09 1c 1a
01 1c 1a 01 28 3c 80 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 e7 90

Signed-off-by: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260701013018.2621972-1-zhouhaikun5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index a67386a1ac89c..6f5d83dc08c32 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1957,6 +1957,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1100, &delay_200_500_e80_d50, "MNB601LS1-1"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1104, &delay_200_500_e50, "MNB601LS1-4"),
 
+	EDP_PANEL_ENTRY('H', 'K', 'C', 0x1203, &delay_200_500_e80, "MB116AS01'3"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d51, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5b, &delay_200_500_e200, "MB116AN01"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5c, &delay_200_500_e200, "MB116AN01-2"),
-- 
2.53.0



