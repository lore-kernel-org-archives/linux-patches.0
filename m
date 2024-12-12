Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80602215764;
	Thu, 12 Dec 2024 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024508; cv=none; b=eMM9/0bX8wqUynm0EHV1tAyPWRD49/d38OSoVv0FFrFeWB/YnEs9DTvSiYbt3jeV/6lYTMAXAM0N/nOROz5k7aaf7MUdDyc3nDhKEh0+wpR5C1LOQ6q99grFYTunbuYlCUlke9KNT0cv8+iwHoCWLdIAhIiCv7PGZdRnOHEBD/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024508; c=relaxed/simple;
	bh=BesJ8ZbA2EZlLxV+vAhzuzoaGtp8QrRaiTcxbPWDwLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFTngVLbtavwJDQT5uxgsrxQDekfC3Vk+//valY9j5XATnoUx/ftGq5IsQ7WdL/eOafaWrH02x/Piuddz2StMRag4L1yNoYVvvcYuZCgw/5BPzfe2HWqFHDNfvYFVDXjSwB8nypKTeRbVuBxrZcEyCmvXEuRPpnSRXIZS/pzupM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8mCYd+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8mCYd+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071AEC4CED0;
	Thu, 12 Dec 2024 17:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024508;
	bh=BesJ8ZbA2EZlLxV+vAhzuzoaGtp8QrRaiTcxbPWDwLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8mCYd+lC6mUYu4Wm5xWNDNg73hCX6O6zC+aCrWCSMsOUnkmh1zsxutVcNfND7/4J
	 R9zZ0ZQ+N3HzjSRVmrVCafz2c3J+yDO4r0zyM2mQ/D+aUfSsd+LrPLiK2mU8YevCiC
	 +LP+Os6TNCLswH5f84J1n9Wjof1dj5hRjCYp5xcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 279/459] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Thu, 12 Dec 2024 16:00:17 +0100
Message-ID: <20241212144304.648642646@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,6 +464,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


