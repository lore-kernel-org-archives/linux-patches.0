Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44791BDDE;
	Wed,  3 Jan 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5dMcD9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355DCC433C8;
	Wed,  3 Jan 2024 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301511;
	bh=0JlQ/FFmlBDYKoUnDd9C+FR+SufNMeFjdOdNXitDCyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5dMcD9Hbk3b6Bnu2Dq634nZRrbUvhcMG/FTVJymea9Enldl74OYj8akFFYMPj551
	 6Zlq2iu+HrsDzITNeEy+FGSs0FS9Xvn3BALSEom/wxbakaRaf9sSyrL1ObnD6K2CHI
	 uL74fwr7G/DwV50NZvOUiuDnoc8fwLtA6Vqv0qho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 53/95] Input: soc_button_array - add mapping for airplane mode button
Date: Wed,  3 Jan 2024 17:55:01 +0100
Message-ID: <20240103164901.992254853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit ea3715941a9b7d816a1e9096ac0577900af2a69e upstream.

This add a mapping for the airplane mode button on the TUXEDO Pulse Gen3.

While it is physically a key it behaves more like a switch, sending a key
down on first press and a key up on 2nd press. Therefor the switch event
is used here. Besides this behaviour it uses the HID usage-id 0xc6
(Wireless Radio Button) and not 0xc8 (Wireless Radio Slider Switch), but
since neither 0xc6 nor 0xc8 are currently implemented at all in
soc_button_array this not to standard behaviour is not put behind a quirk
for the moment.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20231215171718.80229-1-wse@tuxedocomputers.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -299,6 +299,11 @@ static int soc_button_parse_btn_desc(str
 		info->name = "power";
 		info->event_code = KEY_POWER;
 		info->wakeup = true;
+	} else if (upage == 0x01 && usage == 0xc6) {
+		info->name = "airplane mode switch";
+		info->event_type = EV_SW;
+		info->event_code = SW_RFKILL_ALL;
+		info->active_low = false;
 	} else if (upage == 0x01 && usage == 0xca) {
 		info->name = "rotation lock switch";
 		info->event_type = EV_SW;


