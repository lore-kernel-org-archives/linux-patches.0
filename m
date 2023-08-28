Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF3469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D0DC433C7;
	Mon, 28 Aug 2023 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218733;
	bh=V02ySfT5ZOhgco4PsW9pZNFp9zMCc5q1aVaSseHc+Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Agvik51l7bsp1ZaOmXp3WGZ2mT0hNNpcGZ3Sn4eXohPJ5ZnKlTB9bsxN/Pz2clpuW
	 Ey+dFEN2qfpask5xGn/9uhbzjfmznGuP+C7DLBampVw2pTCaoPKB80CHcfiWs2EK++
	 yPpnzDqPQYITuLV4uFmaxZKdQ3qTLo4jH6JCcRlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 065/122] platform/x86: ideapad-laptop: Add support for new hotkeys found on ThinkBook 14s Yoga ITL
Date: Mon, 28 Aug 2023 12:13:00 +0200
Message-ID: <20230828101158.589016924@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

commit a260f7d726fde52c0278bd3fa085a758639bcee2 upstream.

The Lenovo Thinkbook 14s Yoga ITL has 4 new symbols/shortcuts on their
F9-F11 and PrtSc keys:

F9:    Has a symbol of a head with a headset, the manual says "Service key"
F10:   Has a symbol of a telephone horn which has been picked up from the
       receiver, the manual says: "Answer incoming calls"
F11:   Has a symbol of a telephone horn which is resting on the receiver,
       the manual says: "Reject incoming calls"
PrtSc: Has a symbol of a siccor and a dashed ellipse, the manual says:
       "Open the Windows 'Snipping' Tool app"

This commit adds support for these 4 new hkey events.

Signed-off-by: André Apitzsch <git@apitzsch.eu>
Link: https://lore.kernel.org/r/20230819-lenovo_keys-v1-1-9d34eac88e0a@apitzsch.eu
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1176,6 +1176,11 @@ static const struct key_entry ideapad_ke
 	{ KE_IGNORE,	0x03 | IDEAPAD_WMI_KEY },
 	/* Customizable Lenovo Hotkey ("star" with 'S' inside) */
 	{ KE_KEY,	0x01 | IDEAPAD_WMI_KEY, { KEY_FAVORITES } },
+	{ KE_KEY,	0x04 | IDEAPAD_WMI_KEY, { KEY_SELECTIVE_SCREENSHOT } },
+	/* Lenovo Support */
+	{ KE_KEY,	0x07 | IDEAPAD_WMI_KEY, { KEY_HELP } },
+	{ KE_KEY,	0x0e | IDEAPAD_WMI_KEY, { KEY_PICKUP_PHONE } },
+	{ KE_KEY,	0x0f | IDEAPAD_WMI_KEY, { KEY_HANGUP_PHONE } },
 	/* Dark mode toggle */
 	{ KE_KEY,	0x13 | IDEAPAD_WMI_KEY, { KEY_PROG1 } },
 	/* Sound profile switch */


