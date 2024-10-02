Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0DC1D07B1;
	Wed,  2 Oct 2024 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876698; cv=none; b=kjfTLTAdGaKOnTpq26pfIz+MpjPq50fRugymjDSCPp1dj3ltQcOjtCcS/0YiO8JziZBmTJo50cOt1cWSwFxx5KBYL+O+iySjhD1MieRBw0GDOxwJtaGxT4fw+cKUG8A2igSqFzcJjMqSFcFfyqj/1V7GiQbPsyCqxSi47M/vwUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876698; c=relaxed/simple;
	bh=jQ/lMNifQcUH925wABrmBMXCXup8/0jrpo7dwamkQnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Izfphwn44jxC6kYKZSZy9uR7QGkCF+M5Rp7Q8ESXJ2kfk3N7jvi5euclEkK9K3uBG3HFsJEgUpVY+ormUGJm6x4iu1T5JNEkedSwKCFgvpWY6dGo2CPUG+02mRSssxdLSRYT7L2EnxBP7YMfaA7hjqZ0/ibIplRd/9OwLfvoyXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2l8trlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2l8trlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D79BC4CECD;
	Wed,  2 Oct 2024 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876697;
	bh=jQ/lMNifQcUH925wABrmBMXCXup8/0jrpo7dwamkQnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2l8trlzSdL0a67UV2TimenXUWZPeOz/J0gA/JmNJ02RC+FABD8Z3UDegxfnfqn/+
	 TyE9yRusQUjmHfz3KDdl0znDf4wJImy7GojekhehI3UTITfRRxEsm+GAjMdwsT7oOi
	 NWTu8Fwm+VC/7ZPWwXDoSEiV0B0U9MLOMyVFm/wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.11 533/695] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Wed,  2 Oct 2024 14:58:51 +0200
Message-ID: <20241002125843.776559661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 01eed86d50af9fab27d876fd677b86259ebe9de3 upstream.

There might be devices out in the wild where the board name is GMxXGxx
instead of GMxXGxX.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1138,6 +1138,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


