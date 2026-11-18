Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061875;
	b=wd1aTZ3u/4riE0XdhDqdzGzqQyxcKwrm0WJt5I7lAdcYVHWWbAVvLjJQXKSaXo2nDTsz
	 i8WyyH6wvdn/iUuNLKJcGoBBZF9z/4WTjl6irZ07emk2wkMLL3XdIEa1GMpkvFXY7oSqR
	 Y/S/2MNZLoUKqQ2x9DuYk6Tkm2q6eDU+CU+TLurkdhYjY4XXZfO44F+zuSMsGBSbV2jgk
	 84x6oaUdROnhYugVKCnqxMiUVX6qfGPv9EDZ9S/XUwJCnaONC7qE5ZA87cNo8Kwl59UFG
	 D0z+vjnrXambWn9KnyC+NulGIhsFs32gRxB2cB9Xx19OUrNM8lMFV2mn/ba0AzT+UMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHQkz6YNIQFd0slzzrl9fGLqZKu9XCab1xcLjDfnanw=;
	b=RgucIU8G6PwKEfEc0Bw85XW16jsXyBxsrWyFCA5TkCoxBn5c/x1hsUGHlcv06fNoNjF6
	 g9nvJ1fx6CWTgQ/ZcmEqWffY8S7dezKdos3NPUQsOAzGNxtz4uWpN6vxaG5raM2klFsb/
	 IvYhjc3r10gPKWP9MVwngouNYc45DqZw1wx4vixBsYA5cVI4l4g5/0I1GOprEXnm/xCRQ
	 l+tz6TPI5WOc/HrY70eyXDOKZDBf7Nm9UauAimDXZV0CnYJ518cZ9goqZ/GY3I27Ak4kg
	 4GH+MnIULAeB6qEwIUuHyiJni3zMMRESotRgHFtKGQVbz5hSfQKwpfs77b05BJMG3Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/hNYQ7x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C62606A320;
	Thu, 19 Nov 2026 04:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/hNYQ7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A61F000C5;
	Thu, 19 Nov 2026 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061875;
	bh=ZHQkz6YNIQFd0slzzrl9fGLqZKu9XCab1xcLjDfnanw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/hNYQ7xhxmkNsQAUpWz8iQQSGCJsGWByXMv2E86SHcsjgp6LebEzUC5uaf96tC4z
	 y71t8YleEIer1cG+npnxlfYpb0oreXXJQEWvtsU8gOWZdZ0ziRUxq9KeqGxsK5xvk5
	 n3PJFU1E241bv6csj5EwJCgcfg0qT53GpFMxNtLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1709/1848] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 16:02:27 +0100
Message-ID: <20261118150031.243700778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit f0f400459bf6a037e70768de623fff3f8920b8bb ]

The status property follows only the charge-status GPIO. Without input
power a charger such as the BQ24133 releases its open-drain STAT pin,
and depending on the board the GPIO then reads as charging.

On Kobol Helios64 the board runs from its battery after a mains loss,
and the charger reports online 0 with status "Charging".

Report "Discharging" whenever the online GPIO is present and inactive.

Fixes: df68c44c720a ("power: supply: gpio-charger: Add support for charger status.")
Assisted-by: LLM
Signed-off-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261018-gpio-charger-offline-v2-1-482795f9e27c@iav.lv
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/gpio-charger.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/gpio-charger.c b/drivers/power/supply/gpio-charger.c
index 6139f736ecbe4..fba7b0616059c 100644
--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -100,7 +100,10 @@ static int gpio_charger_get_property(struct power_supply *psy,
 		val->intval = gpiod_get_value_cansleep(gpio_charger->gpiod);
 		break;
 	case POWER_SUPPLY_PROP_STATUS:
-		if (gpiod_get_value_cansleep(gpio_charger->charge_status))
+		/* Without input power the battery discharges, whatever the status pin says */
+		if (gpio_charger->gpiod && !gpiod_get_value_cansleep(gpio_charger->gpiod))
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (gpiod_get_value_cansleep(gpio_charger->charge_status))
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		else
 			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



