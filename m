Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE7C749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75B1C43392;
	Thu, 12 Jan 2023 14:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532467;
	bh=ZyjTg/xiQw9dJWuHj55QeHTyLaqOuPbyeDlflUoRpdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arEJ/fqsB146zfb+6asrArPmIsUgRT4NsZY00qddQVjxb4EUnMDO9RbRY6MrsZQXA
	 UPXdfxex4ulviyiRJ2Qt3s+FFh67+wrSYUIUjj8XUU3dp5tOwocNHUVeh12M66Uok0
	 ivZfhDR92oyfgPv6erZ06XEPMspdk0u3CWM3mdME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/783] Input: joystick - fix Kconfig warning for JOYSTICK_ADC
Date: Thu, 12 Jan 2023 14:47:37 +0100
Message-Id: <20230112135530.869919664@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6100a19c4fcfe154dd32f8a8ef4e8c0b1f607c75 ]

Fix a Kconfig warning for JOYSTICK_ADC by also selecting
IIO_BUFFER.

WARNING: unmet direct dependencies detected for IIO_BUFFER_CB
  Depends on [n]: IIO [=y] && IIO_BUFFER [=n]
  Selected by [y]:
  - JOYSTICK_ADC [=y] && INPUT [=y] && INPUT_JOYSTICK [=y] && IIO [=y]

Fixes: 2c2b364fddd5 ("Input: joystick - add ADC attached joystick driver.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20221104201238.31628-1-rdunlap@infradead.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index b080f0cfb068..d8ec5193a941 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -45,6 +45,7 @@ config JOYSTICK_A3D
 config JOYSTICK_ADC
 	tristate "Simple joystick connected over ADC"
 	depends on IIO
+	select IIO_BUFFER
 	select IIO_BUFFER_CB
 	help
 	  Say Y here if you have a simple joystick connected over ADC.
-- 
2.35.1



