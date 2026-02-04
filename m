Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE6E4219F9;
	Wed,  4 Feb 2026 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216971; cv=none; b=OeGt/Tx6BXhcJU4zYAijrH5ARPli/32M2FHU1j4RJoIQV0yZrdIe56alJ0viC2yfhlT9c3yem6lBtuuHNZn2Ul37E3bkYnefe2iW0DngtiogrP2VNVu/UChah4YmsIjaR46ptPMRsflWW1I5R7CsD0hqQNdm2xEiWQdI64DzSC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216971; c=relaxed/simple;
	bh=bYrV2WwF39+d2qu5vBRNcT/NV8IAepGuwnwocjpgIls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlrNwwyCHYvl7IRVRmC0wa/x9rbFpiUXQPTyno4Fv0b8aC6tt7BuF5X4t3sVBNFhMu90svDvmCWqwWuVX7tB3raUs1Pj67Zgx19HWBsL1Jo9jqWOmvGGO2VVYKlL8vSPl7K2gB4DGnCyaAYeuVigiHYzNE4CBadZkMiHj1l3a+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDi/OyhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDi/OyhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C43C4CEF7;
	Wed,  4 Feb 2026 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216970;
	bh=bYrV2WwF39+d2qu5vBRNcT/NV8IAepGuwnwocjpgIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDi/OyhHVUQv12DPyVjt/C7JWqKkilAFYTZJitgYML9ZMJIgwmUN4lC0oCq8NutVm
	 l6H7EdERBB1vbIRwd6rlGEgDrotxsdeplP7rMz0W0iHWtUk+POaW+y/F8ZqWP8RrIP
	 RtOoHBnbl0raQeizpBr82GJANyr8Fnz1R8tEZcls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 085/206] Input: i8042 - add quirks for MECHREVO Wujie 15X Pro
Date: Wed,  4 Feb 2026 15:38:36 +0100
Message-ID: <20260204143901.272224160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: gongqi <550230171hxy@gmail.com>

commit 19a5d9ba6208e9006a2a9d5962aea4d6e427d8ab upstream.

The MECHREVO Wujie 15X Pro requires several i8042 quirks to function
correctly. Specifically, NOMUX, RESET_ALWAYS, NOLOOP, and NOPNP are
needed to ensure the keyboard and touchpad work reliably.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-3-550230171hxy@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1168,6 +1168,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


