Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB731170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B46C433C7;
	Mon, 11 Sep 2023 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442317;
	bh=3GSnM1Mh25k1sZrWtZzM8go4SNG2Dz1VRKg4INU+2b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+LQkZlCXXnrrVAXSGDUKZWaTvU0/V0AFbPPeQublswyNH7Qv0yV1gv4R64GTrVM8
	 c6iHffz5WhqLHkZbNd1h2lkfW3CCKnNP5QAyRAQFxWcU1vKqNUtm6pSOtC5Vf8akiy
	 pSLaWNN7GPtnahuO5hzF82mi1uBg98gpfrqGNTxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 6.5 722/739] of: property: fw_devlink: Add a devlink for panel followers
Date: Mon, 11 Sep 2023 15:48:41 +0200
Message-ID: <20230911134711.249670114@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit fbf0ea2da3c7cd0b33ed7ae53a67ab1c24838cba upstream.

Inform fw_devlink of the fact that a panel follower (like a
touchscreen) is effectively a consumer of the panel from the purposes
of fw_devlink.

NOTE: this patch isn't required for correctness but instead optimizes
probe order / helps avoid deferrals.

Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230727101636.v4.4.Ibf8e1342b5b7906279db2365aca45e6253857bb3@changeid
Cc: Adam Ford <aford173@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/property.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1266,6 +1266,7 @@ DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-c
 DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
 DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
+DEFINE_SIMPLE_PROP(panel, "panel", NULL)
 DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
 DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
 
@@ -1354,6 +1355,7 @@ static const struct supplier_bindings of
 	{ .parse_prop = parse_resets, },
 	{ .parse_prop = parse_leds, },
 	{ .parse_prop = parse_backlight, },
+	{ .parse_prop = parse_panel, },
 	{ .parse_prop = parse_gpio_compat, },
 	{ .parse_prop = parse_interrupts, },
 	{ .parse_prop = parse_regulators, },


