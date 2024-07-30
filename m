Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67A81A76AA;
	Tue, 30 Jul 2024 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360339; cv=none; b=XUXOznxRa48d6y8YdF94s85+8jkRVPgy8OsI7CcOtF4UorYUxzfarLYC+RI7ncgzifkuU8tLppEYVqk834ZAPhWiauEQz+dBRva/0SEamIQTeB7oQIzJi9WkDP9xr7hlubIOmJTIVfWHVP93CTKEMZukxUO4LTpy2lHzDLGAQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360339; c=relaxed/simple;
	bh=z52mnZLsxMBtEHm00sIdRq5CEeXpxv0kURuvUczYnAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flLSMMm2kL/EcuIiI6z63d5tZGNsWguoGKoKYs8weLbweUxSZhwu58e191rZMOz1/67aELng8d0kZEC/MO48xUZVHlZzwjIibvMp5XC1eUo4cijMQ23m1zapu4DlF1+JMUacIpVZoEbowpL/XHpE+BsMxTnYqwbVl0IMVrE/i54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfVHXT5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfVHXT5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A53BC32782;
	Tue, 30 Jul 2024 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360339;
	bh=z52mnZLsxMBtEHm00sIdRq5CEeXpxv0kURuvUczYnAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfVHXT5NGdqSOv0ygzeYUNFbmZOePynN8mVkN97aKzUHA89ZKL9vdZxc88FGcPGxT
	 KkW9GKVyM+5fypYB9Ev7v8QjH/Y/CxlWd8WTmqMh9wB9pE1/saUr8YHTFtqzlP8tiQ
	 mHuuH8BCZIEgGnceOREjP+9+LCbkqVH+g61pDZEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 669/809] ASoC: amd: yc: Support mic on Lenovo Thinkpad E16 Gen 2
Date: Tue, 30 Jul 2024 17:49:05 +0200
Message-ID: <20240730151751.327388933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1d9ce4440414c92acb17eece3218fe5c92b141e3 upstream.

Lenovo Thinkpad E16 Gen 2 AMD model (model 21M5) needs a corresponding
quirk entry for making the internal mic working.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1228269
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240725065442.9293-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -224,6 +224,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M5"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
 		}
 	},


