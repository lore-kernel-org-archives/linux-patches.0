Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F8721E0BC;
	Thu, 12 Dec 2024 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020240; cv=none; b=oTrOyQU9HjNE23GZ1d9A+sRPuvjNEp6ZSdoNUyKcHhruVIc07304k8SJbFOMM5NH4KCrLx5h0F73w/huEc/EIzKns0UX4Q2ZgUc6PwXqQ9buVLl8oIbLmH2573Z5BoM181Fl5yUEcnqtmj0qmxhtKFelzHq3AZZreeWGiiNq7do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020240; c=relaxed/simple;
	bh=nZnNn93YNpYUUA2goygRPkdD4q84Ehu/LtMIAZAMf7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhoFQLTrLY0uNXnDmB+D9fU5tEpT3r5SUkrab2NqpqjfDs9YuMNq7ie+npwI2E3mpOpSweGAmCg1AmbT6YwpE8NaiAvEhlvRCZWs3zBIQQdGyjYTOXnCyEDFIGqX3Elgfjy5JMF3B+MdWOZUCB7ljvbaDm4YrTCvAWqQf5B7//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJcdw59E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJcdw59E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1887EC4CED0;
	Thu, 12 Dec 2024 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020240;
	bh=nZnNn93YNpYUUA2goygRPkdD4q84Ehu/LtMIAZAMf7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJcdw59EAeXNBExGkekKkxVv3m1O1tYa+vTv2P4yf5XQ1IgPqVYY7/nYB30GaMFd6
	 hZXyv6tnwbum3he/3iTpxtaFhGHg6ggvCKAK+5nyN++zUOiCK2NrigslPIUEDVvwA5
	 6IeSVXJXYLpC8BZ/vSPThYDa/WclcEqZF/Tp8Zpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 414/772] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Thu, 12 Dec 2024 15:55:59 +0100
Message-ID: <20241212144407.023998960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,6 +469,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


