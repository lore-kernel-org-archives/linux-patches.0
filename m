Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1CB101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F8C433EF;
	Mon, 15 May 2023 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173209;
	bh=0kM0V+605O1M1znJUIHIVJQociBMYCy5OXAFrQeck+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUFSVLHDWK1dwhn1g4V4EULeDGvJrNai2ejClC/u02rtiaoSWb4I/RTTo/XTAJnVM
	 zI1yatMjwDQmO7cP93Iq55RZfo9AgiLmc8VslSoVICfsp1rhllbaR0VDFmcjF+yJUD
	 L8o+nXPA8272s+EnZavUU3QMCwM/BURD7gLgtkmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.4 021/282] pwm: meson: Fix g12a ao clk81 name
Date: Mon, 15 May 2023 18:26:39 +0200
Message-Id: <20230515161722.909797309@linuxfoundation.org>
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

commit 9e4fa80ab7ef9eb4f7b1ea9fc31e0eb040e85e25 upstream.

Fix the name of the aoclk81 clock. Apparently name aoclk81 as used by
the vendor driver was changed when mainlining the g12a clock driver.

Fixes: f41efceb46e6 ("pwm: meson: Add clock source configuration for Meson G12A")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-meson.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -433,7 +433,7 @@ static const struct meson_pwm_data pwm_a
 };
 
 static const char * const pwm_g12a_ao_ab_parent_names[] = {
-	"xtal", "aoclk81", "fclk_div4", "fclk_div5"
+	"xtal", "g12a_ao_clk81", "fclk_div4", "fclk_div5"
 };
 
 static const struct meson_pwm_data pwm_g12a_ao_ab_data = {
@@ -442,7 +442,7 @@ static const struct meson_pwm_data pwm_g
 };
 
 static const char * const pwm_g12a_ao_cd_parent_names[] = {
-	"xtal", "aoclk81",
+	"xtal", "g12a_ao_clk81",
 };
 
 static const struct meson_pwm_data pwm_g12a_ao_cd_data = {


