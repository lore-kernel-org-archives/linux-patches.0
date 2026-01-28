Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86F304968;
	Wed, 28 Jan 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615594; cv=none; b=C4tfykRc/EDxcf3R7ETEKMlLAvpi0td3NJCART+so21GbSkxJoYe7DU9bmKAbc57ipfMNE7Q27NmjyTAGGUtrqWy/yu++v5DgYp/2IMbUdB0gsyYSXUeK/OWIpIgN3HdLBczeEGOfkMNllUt8EQ5OUdQ6+idJWqnW0ivqdzzcpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615594; c=relaxed/simple;
	bh=D9tPILHVKhU9ZXQi1A7FEA/1bxYzhaL2xXq7na8BXKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phdQFVAmgAKVPo/lXWbFhIDyxGPcPW8Mi8IAS9Bw6Gn1KejCt0S0HqcPXWbGDVHxAVGfqP//qr/esVVuAvy7ENhvy2gTBjkgvQTnEw7X8jS7Yk7VbBRUu+nl9L3DuSUlbDyW5xyOsH5Oux2o+qAsiehm2aY3tzSMYD4yu5D5AuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aV1qfWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aV1qfWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBEBC4CEF1;
	Wed, 28 Jan 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615594;
	bh=D9tPILHVKhU9ZXQi1A7FEA/1bxYzhaL2xXq7na8BXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aV1qfWL4mkAqJsEVLSsdcLSF54FYtDOStQs0mjJhKFHhlVF9nRndMRUlM2Cf/CS9
	 IZBLIgGAwuzyvuDPHwTZKrdO+AFoB+317esTaic1oWuoL7UqRyBPC8bmpJoQoS6gir
	 KXBThc5YxZfYaXmfgvnApGLgelwSC+yG9cap0A/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 055/227] Input: i8042 - add quirks for MECHREVO Wujie 15X Pro
Date: Wed, 28 Jan 2026 16:21:40 +0100
Message-ID: <20260128145346.322110746@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1176,6 +1176,13 @@ static const struct dmi_system_id i8042_
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
 	 * after suspend fixable with the forcenorestore quirk.


