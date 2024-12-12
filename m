Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2595F2248B8;
	Thu, 12 Dec 2024 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025444; cv=none; b=ITr97DHx94DZqJBaFxSWKCD2RcRjkr8xxzCobo/oyIR/yEhTf294LZr0BsvE3iXQksNZFRQ17lCkyU4ceuvdgKrde4bjK2W9BIL5cbg9+Gm2FbMkyWDR+LazdXaMAf08MKjXGHWV4QfmlCyotBEVvtcKhTJa5cppYH45XmkLgY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025444; c=relaxed/simple;
	bh=X+g2hoyfSZDIegEDNiOQ5031kXM980l18gMxIRrjky8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNcRcVJwbaWbYW081v8pE67cGDP88bNzsNbnoX8UtadPcyvtTl+s8BrgheHLNisvPqdwMKj+HXIeno9VA3qYa9mW4SisxXcqa7eP9KRT2pWibxlyrVdlqICAgiQyNEw4kPjZefC/fZrP9cJTh8OYqI6gL1OxNOwdXhtmQENjWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tw92FjBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tw92FjBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48132C4CECE;
	Thu, 12 Dec 2024 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025443;
	bh=X+g2hoyfSZDIegEDNiOQ5031kXM980l18gMxIRrjky8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tw92FjBsW/2fPpjhxHsqO6Njqf21Rvv2S/iKbOHipNK8tkHIIpbG2W7xCfbmYW/qw
	 CJTgGcYtYN1RPbRk77587LuHDmn/fjRvgofW+F38wz6ieia9Q5hdSCteyb2MISKWTc
	 geVu3J3mtfJpNphC3FbcDhaCtbv/Vmhbt8dGdozM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 170/321] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Thu, 12 Dec 2024 16:01:28 +0100
Message-ID: <20241212144236.702735852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -406,6 +406,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


