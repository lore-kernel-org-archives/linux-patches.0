Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585881;
	b=hYr60DNnNO1kQbRMbHiCWtmfP6JVZ5criCGSOJnpOT7fpUkONG43ytKH40KhGhPoVjdX
	 Mle9ZWGoPVRHDrGR0pROHDFNaB0VRMhh6NQIK76mN/OGBjZJJPKmdjhxPm/63CUyqEYSA
	 JYYcOM3lEjYu+gimtcIfbkuPrembVk9xOKQFurg7phA5xtilcbx3bhxIqeBiQTx+orx3A
	 J7DrvP0ZKSfO0krHW8ZdcW+visT2k1gudrCNFzvytOEd0MxfRS5VysBD1k1RsJY8vLL6U
	 2kVfiU72XYA7cNUgPsQBz2lsR451QGInkIEZBgJcBsSJ/9YP16f4yPmuHSIIWATJmMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3vrE8J9CBymMw71h//AKI78J8D6/4V7/DgO47SAnPKg=;
	b=txGIvRsGvu8QWPFvjcLAhOBQhgyMun5pv9Kwyxyqx7NyYn9ZX2yy2Juq/ehS/2dne1b9
	 PqzjFdaubf2nq2XQKRoEFQ9RobVzuGTWo8S7Z6tq0mo8PG/wMusLDyFJWV9DnHWXAXpIE
	 M0BcyX19TYGzm5EQCkBP71+HkAhHXCzXYOQeImBK4broW27PgNdndnVHTAoqcilhwWbHo
	 fptgrGJABchYw99qEkxm5uGThWHfN8ZiF3tJNgLHkJe3jV5ckCoHDcL6sXPNckq9lJXWs
	 DFYChBE+xACSW7xYJrPZPdhvu2eIgIF5cUip7t2lffv7EacWUZkcXbULefNDix1lP5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAnzovur;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF43606EA9D;
	Fri, 13 Nov 2026 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAnzovur
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84D31F000C7;
	Fri, 13 Nov 2026 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585881;
	bh=3vrE8J9CBymMw71h//AKI78J8D6/4V7/DgO47SAnPKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAnzovurCoJ5YivelNv0GnnRBxC0RdJZ6fF9qLAiuX65W8wW6wb0Yabd3UmREnc6u
	 MvYAxkwpxaKW9/mhAgzReLsLrWJEpZCgs+cXKVrTP0NqEfZbelnIL9jomq17voGm3+
	 xTZjRzWuEMehMdbW14kURULSuZROcyIEz4R0h1UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 449/507] media: microchip-isc: fix SBGGR10 Bayer pattern
Date: Fri, 13 Nov 2026 10:52:33 -0500
Message-ID: <20261113153811.951140152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit bb96c78c5f87072913f8825faebe64bf711a503c ]

SBGGR10 was mapped to ISC_BAY_CFG_RGRG instead of ISC_BAY_CFG_BGBG,
causing red/blue channel swap.

Fixes: 1e8f401474d6 ("media: atmel: atmel-isc: reworked driver and formats")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-sama5d2-isc.c | 2 +-
 drivers/media/platform/microchip/microchip-sama7g5-isc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 57a5aae3cabfb..5e41eee45dbd7 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -148,7 +148,7 @@ static struct isc_format sama5d2_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index a841266ffc30f..9e78ea07b013a 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -157,7 +157,7 @@ static struct isc_format sama7g5_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
-- 
2.53.0



