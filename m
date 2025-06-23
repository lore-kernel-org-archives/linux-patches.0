Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF371F7580;
	Mon, 23 Jun 2025 22:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716581; cv=none; b=u0D+dxcp+BQk7XH19/rU8rFvN/uemTtVJ67Z7Plwa5dNzyCNLU4pBzw95ZqInPEtXsBBwjqswkHO+bygX6CUYQOFNpNyBwac9CoF2CP4cTLikbuPzT9QUTwlqm0WixdAlAG+y1kSFRpylIw/uwl5nD7STRljDddZfWyztAiEiPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716581; c=relaxed/simple;
	bh=ncpcgd/TrZv6YascrINiJ928OIXC4jN+DHYQgw5c1Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVPdw+dV45pBdOxjLOctesVyYTvRZqHSu1Vl9y9lcWB1qzisuACE1KDUco2ZI6GKqu1KfHExP2gGju83k0FIeZhiyyrBO1/UGOiNZzfztcVlIC42JOZlxv3ze+20o6r/nHnY33z0aHonvYTbgsE3tc8zEXo37CU/RiOUvL0OPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHm9dNzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHm9dNzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB4DC4CEEA;
	Mon, 23 Jun 2025 22:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716581;
	bh=ncpcgd/TrZv6YascrINiJ928OIXC4jN+DHYQgw5c1Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHm9dNzW3x3i2xkkwmQ1D1J4vui/thSSuW6OJc742DTBkF+vAxd3R76MwbdMrjsZs
	 BGn7HPr942pbPnJb6KVaUpS7rdoG2pcOwKrHg42hZ3oGj17A91AfibGfSiztDzbG6d
	 lKq2NI8UDuZVzV/QqO5A+TDD/VJSh0p2qoITNiU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renato Caldas <renato@calgera.com>,
	Hans de Goede <hdegoede@redhat.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 274/290] platform/x86: ideapad-laptop: add missing Ideapad Pro 5 fn keys
Date: Mon, 23 Jun 2025 15:08:55 +0200
Message-ID: <20250623130635.166484558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1101,6 +1101,9 @@ static const struct key_entry ideapad_ke
 	{ KE_KEY,	0x27 | IDEAPAD_WMI_KEY, { KEY_HELP } },
 	/* Refresh Rate Toggle */
 	{ KE_KEY,	0x0a | IDEAPAD_WMI_KEY, { KEY_DISPLAYTOGGLE } },
+	/* Specific to some newer models */
+	{ KE_KEY,	0x3e | IDEAPAD_WMI_KEY, { KEY_MICMUTE } },
+	{ KE_KEY,	0x3f | IDEAPAD_WMI_KEY, { KEY_RFKILL } },
 
 	{ KE_END },
 };


