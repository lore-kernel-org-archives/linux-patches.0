Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39181F463B;
	Mon, 23 Jun 2025 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717659; cv=none; b=Rj/RJaUhu5r7MRN0RgxkLsJ/y3rJ+pq/E1DyosoUUxuAYEGv/pDV8sb5isf9xIQoO96zcpl3LWa3NReAlvN0ny+kDfQJadcJL0UW0pFNQ3uYXT0yXzFUF0IqlVvAEG4FpZ01K3+AJfxYjeRWIM/5kkLGEztZoU3WgYovAO2bGSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717659; c=relaxed/simple;
	bh=tKU5JGO8gaP2+ZqNLCpsxfKZ1oqu0696nr4E9jnBS2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otpn+OrD0bDkRvItg2SI31QDMwPE0aq5qv/zAPiWLVniFsIQ283CfnYJOnAI7UPHyemY4t44CkgXuay0DtZf90SgpdS8qiiqWA8OCPfZFdQWWBRL2e1gwxkqb2L73IoSMrekczQpnLsTvnXYcCdoMXaxuEGqzLIng7N8beN27vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyeXhCLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyeXhCLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3BBC4CEEA;
	Mon, 23 Jun 2025 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717658;
	bh=tKU5JGO8gaP2+ZqNLCpsxfKZ1oqu0696nr4E9jnBS2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyeXhCLolsp/Q3olvJsplltQfA+V0aEP/gT3eb+C6fuQ5BKi3XopAdkKCv+zVOIIV
	 Nv4yjBLBfYNfmAP/6kmk9tvGwF4F+jTDJvq/YhGVUlPewNjQEVo5gPaZiFyW9GV0A3
	 ZItEi5WUmfTdEOysxxaM3vyJGYpT6r7PuOxmoI4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renato Caldas <renato@calgera.com>,
	Hans de Goede <hdegoede@redhat.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.1 493/508] platform/x86: ideapad-laptop: add missing Ideapad Pro 5 fn keys
Date: Mon, 23 Jun 2025 15:08:58 +0200
Message-ID: <20250623130657.164067868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Renato Caldas <renato@calgera.com>

commit 36e66be874a7ea9d28fb9757629899a8449b8748 upstream.

The scancodes for the Mic Mute and Airplane keys on the Ideapad Pro 5
(14AHP9 at least, probably the other variants too) are different and
were not being picked up by the driver. This adds them to the keymap.

Apart from what is already supported, the remaining fn keys are
unfortunately producing windows-specific key-combos.

Signed-off-by: Renato Caldas <renato@calgera.com>
Link: https://lore.kernel.org/r/20241102183116.30142-1-renato@calgera.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1191,6 +1191,9 @@ static const struct key_entry ideapad_ke
 	{ KE_KEY,	0x27 | IDEAPAD_WMI_KEY, { KEY_HELP } },
 	/* Refresh Rate Toggle */
 	{ KE_KEY,	0x0a | IDEAPAD_WMI_KEY, { KEY_DISPLAYTOGGLE } },
+	/* Specific to some newer models */
+	{ KE_KEY,	0x3e | IDEAPAD_WMI_KEY, { KEY_MICMUTE } },
+	{ KE_KEY,	0x3f | IDEAPAD_WMI_KEY, { KEY_RFKILL } },
 
 	{ KE_END },
 };


