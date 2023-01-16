Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365666FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA3BC433D2;
	Mon, 16 Jan 2023 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887298;
	bh=4ACBcbDJ6Ctcg/srlEdFd2WrfFh78XgoTZQLLlxPVTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmfK/aTRxbtXaEe6LMEJ3CSKesEK9VQIf39/MvaslHbeZYi2CFIrwp2oUImu7xBAt
	 Op6nX22jiLvcHlPVVOH+gFf3577RcCebE7qd49qjddFZpIbUhYSnq/A30PLv4naukz
	 LvZS3C3ePC3cEcIdXQxzN9wft18Twc4pkSjaHYu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/521] spi: Update reference to struct spi_controller
Date: Mon, 16 Jan 2023 16:45:57 +0100
Message-Id: <20230116154851.488063700@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit bf585ccee22faf469d82727cf375868105b362f7 ]

struct spi_master has been renamed to struct spi_controller. Update the
reference in spi.rst to make it clickable again.

Fixes: 8caab75fd2c2 ("spi: Generalize SPI "master" to "controller"")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20221101173252.1069294-1-j.neuschaefer@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/spi.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/spi.rst b/Documentation/driver-api/spi.rst
index f64cb666498a..f28887045049 100644
--- a/Documentation/driver-api/spi.rst
+++ b/Documentation/driver-api/spi.rst
@@ -25,8 +25,8 @@ hardware, which may be as simple as a set of GPIO pins or as complex as
 a pair of FIFOs connected to dual DMA engines on the other side of the
 SPI shift register (maximizing throughput). Such drivers bridge between
 whatever bus they sit on (often the platform bus) and SPI, and expose
-the SPI side of their device as a :c:type:`struct spi_master
-<spi_master>`. SPI devices are children of that master,
+the SPI side of their device as a :c:type:`struct spi_controller
+<spi_controller>`. SPI devices are children of that master,
 represented as a :c:type:`struct spi_device <spi_device>` and
 manufactured from :c:type:`struct spi_board_info
 <spi_board_info>` descriptors which are usually provided by
-- 
2.35.1



