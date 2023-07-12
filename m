Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13C51854
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB4EC433C7
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689421713;
	bh=7UfelKqHCOp1PXS/gmy9rCk72X1nxvezRF5XMYCRbV0=;
	h=Resent-From:Resent-Date:Resent-To:From:Date:To:Cc:Subject:From;
	b=JFyXlx2Ivufy2QcsCv866jh71tQ8QY3ufRAtIjcrGVPAowHyaIAsy4Ja91N2ai0SL
	 S0SV7PP27r5ya+Inbc0U7ui3z0eWId4h0FPzc6WRsXJD7HxWwx6gHssANbTSGMzATZ
	 nSM5HyCZofbPFkWkht799rLHUG2iAGum35ueN/7P6hAFxyCMd1nj0zQoWx64CoATFm
	 Cr/dyCDIIMZPGc2ZfXfrJGosypnnzpxdVS9Hl8+P5sGal/hsfhXlP03aV3sp4lLrdu
	 aecCRXECeEcH8cNuD9ozA3NtL5LccMuS4VuxMZJSXD7v8jpGR5WLo9tObVi6OW4Mt/
	 jciIQ+4G3vP9w==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Sat, 15 Jul 2023 12:48:29 +0100
Resent-Message-ID: <ZLKHjY2rWjazvzoE@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 12 Jul 2023 12:16:51 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <broonie@kernel.org>)
	id 1qJXpx-004s0L-B1
	for broonie@sirena.co.uk; Wed, 12 Jul 2023 12:16:51 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB3F6176A
	for <broonie@sirena.co.uk>; Wed, 12 Jul 2023 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 11FFFC433C9; Wed, 12 Jul 2023 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E70C433C7;
	Wed, 12 Jul 2023 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689160608;
	bh=7UfelKqHCOp1PXS/gmy9rCk72X1nxvezRF5XMYCRbV0=;
	h=From:Subject:Date:To:Cc:From;
	b=t18Cd8+/8iKUOy6hfpG90r5INxph0FKOqOul4kyvaRy9WVNZAjaVAWRfGBVm7Vrqk
	 4Mk613vEz1udfxEADzjtDSZWP9KfSTsU2+2SWq8l2VUxDnXdI1eUTB6LBKwjZXo8BZ
	 qbl5swOMZzmlarSyxqJ+c+aDFOJhtTTn0mBu71k4y962+/E4f4TFPU4vdGSBVF2WNW
	 fUjJ7e4T4+/VbjsS3PSnHU0OI1bssrghc1oVA1SP4RYGQbz34ymh8r/nVZ+owOUQZ4
	 EW14+Rd5Njc2ReBMMP69yl8unTIdia2eYaYieo0/+fP1CH7X23khUAHnrWWjNKoxGa
	 oAMyqDYTGvFGg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Jul 2023 12:16:38 +0100
Message-Id: <20230712-regmap-max-transfer-v1-0-80e2aed22e83@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJaLrmQC/x3MMQqAMAxA0atIZgO1Ci1eRRyiTTWDVVIRQby7x
 fEN/z+QWYUz9NUDypdk2VNBU1cwr5QWRgnFYI1tjTMelZeNDtzoxlMp5ciKgQJP3rqmayOU8lC
 Ocv/XYXzfDyZeNRplAAAA
To: Ansuel Smith <ansuelsmth@gmail.com>, Jim Wylder <jwylder@google.com>, 
 Xu Yilun <yilun.xu@intel.com>, matthew.gerlach@linux.intel.com, 
 Mark Brown <broonie@kernel.org>
Cc: stable@kernel.org
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1187; i=broonie@kernel.org;
 h=from:subject:message-id; bh=7UfelKqHCOp1PXS/gmy9rCk72X1nxvezRF5XMYCRbV0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkroubE6Bj3dgj8umToqLowDIvv6SqOWnstlVDO
 1Y+UEMKCH6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6LmwAKCRAk1otyXVSH
 0Gj0B/0fKEM+w63PDIkU0rSKoQaaLwTq0MdkJnWnG8J/2KpIR/vrczs1hFTOV0WdZzRiu3MKmw6
 Ab/bU3cLXEG+Vp+ilvNZAujcu2HJblhIxNoz/HMAjmZWjhAECSGE5PneGt5m0MutbsNeiCqltaA
 R0tc/4xVRvf13oyZE287Qo0FT7esZBbL1JI802mYE0dh9I6TJ8FlWjFbeBEkQHkeE1yqkZvnEQl
 /UuNEK6u8y66aOW1gxsI2S+CLDQ6tNx81SA/KWjDrHNDU21D/Y8RxOqnVOJg9ib8YDBU39bhNoa
 lT7fyKsorr+/lUjKRQNahZpjssM+DOiXrKA/Arm+XuwpaBA7
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: [PATCH 0/2] regmap: Redo fixes for raw I/O length restrictions
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 9MI+ZVU5MyUT

During the v6.4 release there was an attempt to address the fact that
the specification of maximum I/O sizes for raw buses in the core does
not take account of the register or pad bits in the maxium length.
After this was merged it was realised that there are number of custom
bus implementations in drivers which were relying on the prior behavior
in various ways.

This should be factored out into the core but that will require
coordination with all the buses involved so let's fall back to the
original interface and add the accounting to the I2C bus where the
omission was originally observed.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark Brown (2):
      regmap: Drop initial version of maximum transfer length fixes
      regmap: Account for register length in SMBus I/O limits

 drivers/base/regmap/regmap-i2c.c      | 8 ++++----
 drivers/base/regmap/regmap-spi-avmm.c | 2 +-
 drivers/base/regmap/regmap.c          | 6 ++----
 3 files changed, 7 insertions(+), 9 deletions(-)
---
base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
change-id: 20230708-regmap-max-transfer-dadeb827143f

Best regards,
-- 
Mark Brown <broonie@kernel.org>

