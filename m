Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14B553A7;
	Fri,  6 Dec 2024 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498279; cv=none; b=nV66V7JP/+6yD3ZWV/Bcy+K2/+wGz/mTlLJBimWR/M6NK8m9E9nEfTICdTnXDgxuI7MvNlH0Dxodg0h94eMt6JCRFFzmgHDtMS2pAYU6Bz3qsyCtrKafvFl9oJ+b4mAFzuADjOpFKphpoo8I8L7cgrL1zXJU67ZTr1xPJP3gUyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498279; c=relaxed/simple;
	bh=yQGQM+ifpnAc+Amc5Fo5k+APPiHkmcBgV7GIRF5VQYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfJWsaOrZMoXeNObB8KvYUymMbrT1s+LRYFJFdVQ6m8GlZ+ELyPAB4vv2zlAeWu6sbbnIis9b10pKvxcBcBZXExfwcV//E4JBlCKFUZU676NCMVXixVMEjPkB8TxLCaOjMmDujQeyNKC10YS3ONVfA6f/TOm5wy4H4aaPKKr1Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgkh3Q+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgkh3Q+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACD3C4CED1;
	Fri,  6 Dec 2024 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498278;
	bh=yQGQM+ifpnAc+Amc5Fo5k+APPiHkmcBgV7GIRF5VQYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgkh3Q+ZYip+wG5g16v1XrM2K/pvNPA5E7Tc0yN37EJyPPviGMH7TRa8/J+lUsFZo
	 xaJEw9HcQPK6kQY0fLUWt+OWVpYZqS8ausUnFly4VBJK0JR+tdXlGaZIjCKHutSeQm
	 8PZQ8Xppi6hTpj7+Km6IO2m5A0+AgBVhipu3JS18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 537/676] ALSA: hda/realtek: Set PCBeep to default value for ALC274
Date: Fri,  6 Dec 2024 15:35:56 +0100
Message-ID: <20241206143714.335426224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
@@ -471,6 +471,8 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
+		alc_write_coef_idx(codec, 0x6e, 0x0c25);
+		fallthrough;
 	case 0x10ec0294:
 	case 0x10ec0700:
 	case 0x10ec0701:


