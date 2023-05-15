Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92926101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABD8C433EF;
	Mon, 15 May 2023 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173206;
	bh=vA0zeCbEd66IIZ09tbi0zkeB5Meh+dk0ngEv/bIiDe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRj10UwZkW8fKt9yYQLAT/4SlW2GsFFL4KDJtLzBjABKX1Wc7DhiiDhmyXHLTmiKG
	 9lUeuG3Z4SPBOEpa94afEO4166zkHFK0UEcNgh0pClI5In2Z1JZZTdjNWlJ7OJIseC
	 LlAVOH9nILDgcskqUrw1aQoGwdgbaAY5/keS6N8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.4 020/282] pwm: meson: Fix axg ao mux parents
Date: Mon, 15 May 2023 18:26:38 +0200
Message-Id: <20230515161722.879907252@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

commit eb411c0cf59ae6344b34bc6f0d298a22b300627e upstream.

This fix is basically the same as 9bce02ef0dfa ("pwm: meson: Fix the
G12A AO clock parents order"). Vendor driver referenced there has
xtal as first parent also for axg ao. In addition fix the name
of the aoclk81 clock. Apparently name aoclk81 as used by the vendor
driver was changed when mainlining the axg clock driver.

Fixes: bccaa3f917c9 ("pwm: meson: Add clock source configuration for Meson-AXG")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-meson.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -424,7 +424,7 @@ static const struct meson_pwm_data pwm_a
 };
 
 static const char * const pwm_axg_ao_parent_names[] = {
-	"aoclk81", "xtal", "fclk_div4", "fclk_div5"
+	"xtal", "axg_ao_clk81", "fclk_div4", "fclk_div5"
 };
 
 static const struct meson_pwm_data pwm_axg_ao_data = {


