Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72EC1F7591;
	Tue,  3 Dec 2024 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242579; cv=none; b=RJFuWodwu2uXQF6frVl/E5eyS3/UvTPjY5ai8hHlpCMTmFQCPhLnZBN3DPJA93wvzsJBRcupd/1Qt0ldc5m8hmwOeHKOdftoi1QDzWbfb+W1qL2ePOfZDa6Oy1QdjPZ/6s4YTenGZYzR+/OCfjEhVwrL7n/KgcU6Rv2dTc90JKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242579; c=relaxed/simple;
	bh=3V7EMUvXTRQLmkhsMOIzP5GRSejVYor1E88Hpg8Dtmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1hU1K31i186lmsZXeRaCM7+2kb0OS1wLtqgwEPLaiS73jIoiPZq7yxv9KG0mbLGS0A807Ey9aJfj3jEaOhM67615QCcAkqX4Zx+6/QDH6UJ6Str/zquhMu0cnPS3jUa5S0ayCNiqdmZXVZwXj5vQb1LTadJ6fmJ8u+oaKl8T9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Myamcn0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Myamcn0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2127FC4CECF;
	Tue,  3 Dec 2024 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242579;
	bh=3V7EMUvXTRQLmkhsMOIzP5GRSejVYor1E88Hpg8Dtmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Myamcn0o4SSojk1Ugm48sO7XPu068w8ChCvHns+KLEomr/z338M7dRNZheUcVWsHm
	 Ir5DIaJVNDW+/+bBRjrwGr2sqDmf21dVHiS6nAxUNJZQkG2qvHuxPEhGNiCoxeqdSh
	 smd733VYZFGefdUfFvV4G958qeTk3/D39I2sy1Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 745/826] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Tue,  3 Dec 2024 15:47:52 +0100
Message-ID: <20241203144812.824910813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 155699ccab7c78cbba69798242b68bc8ac66d5d2 upstream.

BIOS Enable PC beep path cause pop noise via speaker during boot time.
Set to default value from driver will solve the issue.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/2721bb57e20a44c3826c473e933f9105@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -473,6 +473,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


