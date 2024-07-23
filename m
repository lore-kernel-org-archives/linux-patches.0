Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8590158A27;
	Tue, 23 Jul 2024 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759695; cv=none; b=Xlsy74XMonwOsE/qmqvHt7YVz6d5z69I/xxQ4L1pbmMf8D4hSP3IGRWXtJ8cnS1dUjlXxMlsSOFhZWatILQe1tKLwLGx+3gpXRvbXjt8lgdS1wcRZ3rk/QdDC3BYke0bI4rHOx8tdptDA3ijt19/dR4tCwa1zTS7iaH3fITDjOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759695; c=relaxed/simple;
	bh=xRYbgyojz5eRyWw0igpX267weI1Jjfj/8CEw+XfUU44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIccXnk3G7SNhlRDmGRzkFEVBe0+OaFgngm7dstIvx11nlRl6ImyYprmj8vj9JbjKqSqbSXnoJJGiRIemVW3xg4DVTNpqGFhWDvvnCFhA8UcgX/b4B1DVUQW6wpBw1KNUYxqelLvmBEAdtw0L5bMOTs7hxyoDQe28nF0L3wGGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuWGg0Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuWGg0Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D14AC4AF09;
	Tue, 23 Jul 2024 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759694;
	bh=xRYbgyojz5eRyWw0igpX267weI1Jjfj/8CEw+XfUU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuWGg0YlOXwYntLaxUeH5GOFMZGY6KAPqdVy3e+JfXxBKL+hYelSRY2NpCPgdNJAk
	 VxIRekRKprzRVnT5Pdfs4EpDpdXgeplltV/kqt89ASNr5RbrBKXkpHhlCqW3WjFCta
	 JoRtuPgRI/geTWngnuOFv5NDvudUrkLSv5wI/Rzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/129] Input: xpad - add support for ASUS ROG RAIKIRI PRO
Date: Tue, 23 Jul 2024 20:23:34 +0200
Message-ID: <20240723180407.335661276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit cee77149ebe9cd971ba238d87aa10e09bd98f1c9 ]

Add the VID/PID for ASUS ROG RAIKIRI PRO to the list of known devices.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20240607223722.1170776-1-luke@ljones.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index cd97a7a9f812d..daf2a46521f01 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -208,6 +208,7 @@ static const struct xpad_device {
 	{ 0x0738, 0xf738, "Super SFIV FightStick TE S", 0, XTYPE_XBOX360 },
 	{ 0x07ff, 0xffff, "Mad Catz GamePad", 0, XTYPE_XBOX360 },
 	{ 0x0b05, 0x1a38, "ASUS ROG RAIKIRI", 0, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1abb, "ASUS ROG RAIKIRI PRO", 0, XTYPE_XBOXONE },
 	{ 0x0c12, 0x0005, "Intec wireless", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8801, "Nyko Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
-- 
2.43.0



