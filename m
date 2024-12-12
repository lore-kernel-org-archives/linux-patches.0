Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B6B229677;
	Thu, 12 Dec 2024 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022828; cv=none; b=F6Wx2k/ThBQHjn6dIbORsRaaVctwarvsshmngF0y3tRTS5Daa3I+r74DPuZfr4uH1wnAjENVu0W1LR9DBWX7LTTN2DVcAQxhEOs8KWRDJ700JQOXFwGlqbdPOh33bkAzwwzcAJ/QL+g1A9aJM8yG4RmYcqpUiHJntScoJrbN9mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022828; c=relaxed/simple;
	bh=WMmsgN1p9+TPhfYnfh8eNDNdxJmn9oRVtwKGN7s2fBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j57XEMaz8lEcz1ptew78zQDw4RNDyxQTuim3EHd5mg+EyANriyKd/OEoJW2+8ywiEGI7mtRw5Bv1k8ywFAMWa563MJC2q9qRTqMa8wBUXHiA+qLdLYIhqqOgNyZru78ohSO33nh+yCbMAcj2JMB7Xmt5AYmq5s7PURZFW+LSbwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyQ2S/fF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyQ2S/fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE3AC4CECE;
	Thu, 12 Dec 2024 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022827;
	bh=WMmsgN1p9+TPhfYnfh8eNDNdxJmn9oRVtwKGN7s2fBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyQ2S/fFzza65s9+p7nS/YV44Bsb+Kx/SpqBkwHGBvXGfdYCCb2TmyZ7yW0MBL91R
	 +A9uah5ZD7vQwMWWdmebZLtZSIund6JolmvvSzUAqiCnuF7zXTTXjFAsYly+zkuktC
	 Vn3pDU9Y7XtOiQdjEEpSPcXR7i0qFQx4D4/my7so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 345/565] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Thu, 12 Dec 2024 15:59:00 +0100
Message-ID: <20241212144325.236500526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -463,6 +463,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


